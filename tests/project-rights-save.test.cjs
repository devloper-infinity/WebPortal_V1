const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('WebPortal/Scripts/Functions/ProjectConfiguration.js', 'utf8');
const start = source.indexOf('function projectrights_bindprojectslist()');
const end = source.indexOf('function projectrights_loadProjectRights', start);
function fixture(transitioning = false) {
    const states = new Map(), requests = [], errors = [], successes = [], modalCalls = [];
    const rows = [{ value: '1', checked: true }, { value: '2', checked: true, hidden: true }, { value: '3', checked: false }];
    function $(selector) {
        if (Object.prototype.toString.call(selector) === '[object String]') selector = String(selector);
        if (selector && selector.value) return { val: () => selector.value };
        if (Array.isArray(selector)) return {
            find(filter) { return {
                each(fn) { rows.filter(r => !filter.includes(':checked') || r.checked).forEach(r => fn.call(r)); },
                prop(key, value) { rows.forEach(r => r[key] = value); }
            }; }
        };
        if (!states.has(selector)) states.set(selector, { events: {}, data: {}, props: {}, value: '' });
        const state = states.get(selector);
        return {
            off() { return this; }, on(event, fn) { state.events[event] = fn; return this; },
            one(event, fn) { state.events[event] = fn; return this; },
            prop(key, value) { if (value === undefined) return state.props[key]; state.props[key] = value; return this; },
            val() { return state.value; },
            data(key) { return state.data[key]; },
            modal(action) { modalCalls.push(action); return this; },
            DataTable() { return { rows: () => ({ nodes: () => rows }) }; }
        };
    }
    $.ajax = options => requests.push(options);
    const ctx = { $, toastr: { error: m => errors.push(m), success: m => successes.push(m) }, alert() {}, projectrights_loadProjectRights() {} };
    vm.createContext(ctx); vm.runInContext(source.slice(start, end), ctx); ctx.projectrights_bindprojectslist();
    $('#projectrights_ddlUser'); states.get('#projectrights_ddlUser').value = '101';
    $('#projectrights_tblProjectRights'); states.get('#projectrights_tblProjectRights').data.employeeId = '101';
    $('#projectrights_processingModal'); states.get('#projectrights_processingModal').data['bs.modal'] = { _isTransitioning: transitioning, _isShown: true };
    return { states, requests, errors, successes, modalCalls,
        save() { states.get('#projectrights_btnSaveRights').events['click.projectRights'].call('#projectrights_btnSaveRights'); },
        shown() { states.get('#projectrights_processingModal').events['shown.bs.modal.projectRightsSave'](); }
    };
}
let f = fixture(); f.save();
assert.deepEqual(JSON.parse(f.requests[0].data), { EmployeeId: '101', ProjectIds: ['1', '2'] });
assert.equal(f.requests[0].timeout, 60000);
f.save(); assert.equal(f.requests.length, 1);
f.requests[0].success({ d: 'Success' }); f.requests[0].complete();
assert.equal(f.successes.length, 1); assert.equal(f.modalCalls.at(-1), 'hide');
assert.equal(f.states.get('#projectrights_btnSaveRights').props.disabled, false);
assert.equal(f.states.get('#projectrights_ddlUser, #projectrights_btnLoad').props.disabled, false);
f = fixture(true); f.save(); f.requests[0].error({}, 'timeout'); f.requests[0].complete();
assert.match(f.errors[0], /timed out/); assert.notEqual(f.modalCalls.at(-1), 'hide');
f.shown(); assert.equal(f.modalCalls.at(-1), 'hide');
for (const status of ['error', 'parsererror']) {
    f = fixture(); f.save(); f.requests[0].error({}, status); f.requests[0].complete();
    assert.equal(f.modalCalls.at(-1), 'hide'); assert.equal(f.states.get('#projectrights_btnSaveRights').props.disabled, false);
}
f = fixture(); f.states.get('#projectrights_tblProjectRights').data.employeeId = '102'; f.save();
assert.equal(f.requests.length, 0); assert.match(f.errors[0], /load their rights/);
f = fixture(); f.save(); f.requests[0].success({ d: 'Database busy' }); f.requests[0].complete();
assert.deepEqual(f.errors, ['Database busy']); assert.equal(f.modalCalls.at(-1), 'hide');
console.log('PASS: filtered selections, duplicate clicks, loaded employee check, success, server failure, timeout, network/parsing errors, and modal animation cleanup.');
