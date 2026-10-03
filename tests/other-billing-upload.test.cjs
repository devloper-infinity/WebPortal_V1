const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const root = path.resolve(__dirname, '..');
const page = fs.readFileSync(path.join(root, 'WebPortal/Admin/OtherBilling.aspx'), 'utf8');
const script = fs.readFileSync(path.join(root, 'WebPortal/Scripts/Functions/OtherBilling.js'), 'utf8');
const uploadCode = page.slice(page.indexOf('        var otherBillingUploadPromise'), page.indexOf('        $(document).on("dragover"'));
const elements = {};
const values = { '#otherBilling_Project': '661', '#otherBilling_DealNo': 'Existing deal' };
const messages = [];
let xhr;
let imports = 0;
let importSuccess;
const context = vm.createContext({
    console,
    document: { getElementById(id) { return elements[id] ||= { style: {}, classList: { add() {} } }; } },
    window: { location: { pathname: '/Admin/OtherBilling.aspx' } },
    FormData: class { append() {} },
    XMLHttpRequest: class { constructor() { xhr = this; } open() {} send() {} },
    $: selector => ({ val: () => values[selector] || '', modal() {}, focus() {} }),
    Swal: { fire: message => { messages.push(message); return Promise.resolve(); } },
    PageMethods: { set_timeout() {}, ImportExcel(project, deal, status, success) { imports++; importSuccess = success; } }
});
vm.runInContext(script, context);
vm.runInContext(uploadCode, context);

(async () => {
    vm.runInContext('getFileName({ target: { name: "attachment", files: [{ name: "billing.xlsx" }] } })', context);
    const pending = context.btnOtherBilling_Import();
    assert.equal(imports, 0, 'Import must wait for upload completion');
    xhr.status = 200;
    xhr.responseText = JSON.stringify({ success: true });
    xhr.onload();
    await pending;
    assert.equal(imports, 1, 'Acknowledged upload should allow import');
    importSuccess(-5);
    assert.equal(messages.at(-1).title, 'Billing Database Error', 'SQL failure must be distinguished from Excel parsing');
    assert.match(messages.at(-1).text, /uploaded file has been kept/);

    vm.runInContext('getFileName({ target: { name: "attachment", files: [{ name: "invalid.xlsx" }] } })', context);
    const failed = context.btnOtherBilling_Import();
    xhr.status = 500;
    xhr.responseText = '<html>Server error</html>';
    xhr.onload();
    await failed;
    assert.equal(imports, 1, 'Failed upload must not trigger import');
    assert.equal(messages.at(-1).title, 'Upload Failed');

    vm.runInContext('getFileName({ target: { name: "attachment", files: [] } })', context);
    await context.btnOtherBilling_Import();
    assert.equal(imports, 1, 'Cleared selection must require a new upload');
    assert.equal(messages.at(-1).title, 'File Required');
    console.log('PASS: upload completion is required; failed and cleared uploads cannot import.');
})().catch(error => { console.error(error); process.exitCode = 1; });
