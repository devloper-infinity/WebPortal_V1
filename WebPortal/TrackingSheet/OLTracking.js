(function (w) {
    'use strict';
    var loadingRequests = 0;
    function parse(value) { if (typeof value === 'string') { try { return JSON.parse(value); } catch (error) { return value; } } return value; }
    function loader() {
        var element = document.getElementById('oltGlobalLoader');
        if (element) return element;
        if (!document.getElementById('oltLoaderStyles')) {
            var style = document.createElement('style'); style.id = 'oltLoaderStyles';
            style.textContent = '.olt-loading-backdrop{display:none;position:fixed;inset:0;z-index:99999;align-items:center;justify-content:center;background:rgba(15,35,55,.48)}.olt-loading-backdrop.open{display:flex}.olt-loading-box{min-width:240px;padding:24px 30px;border-radius:10px;background:#fff;box-shadow:0 18px 55px rgba(0,0,0,.25);text-align:center;color:#17324d;font-weight:700}.olt-loading-spinner{width:44px;height:44px;margin:0 auto 13px;border:5px solid #d9e8ef;border-top-color:#117a9b;border-radius:50%;animation:olt-spin .8s linear infinite}@keyframes olt-spin{to{transform:rotate(360deg)}}';
            document.head.appendChild(style);
        }
        element = document.createElement('div'); element.id = 'oltGlobalLoader'; element.className = 'olt-loading-backdrop';
        element.innerHTML = '<div class="olt-loading-box"><div class="olt-loading-spinner"></div><div id="oltGlobalLoaderText">Please wait...</div></div>';
        document.body.appendChild(element); return element;
    }
    function showLoading(message) {
        loadingRequests++; var element = loader(), text = document.getElementById('oltGlobalLoaderText');
        if (text) text.textContent = message || 'Please wait...'; element.classList.add('open');
    }
    function hideLoading(force) {
        loadingRequests = force ? 0 : Math.max(0, loadingRequests - 1);
        if (loadingRequests === 0) { var element = document.getElementById('oltGlobalLoader'); if (element) element.classList.remove('open'); }
    }

    function call(page, method, data) {

        showLoading('Loading, please wait...');
        return fetch(page + '/' + method, { method: 'POST', credentials: 'same-origin', headers: { 'Content-Type': 'application/json; charset=utf-8' }, body: JSON.stringify(data || {}) })
            .then(function (response) { return response.json().then(function (json) { if (!response.ok) throw new Error((json && json.Message) || 'Request failed.'); return parse(json.d); }); })
            .then(function (result) { hideLoading(false); return result; }, function (error) { hideLoading(false); throw error; });
    }

    function val(object, names) { for (var i = 0; i < names.length; i++) if (object[names[i]] !== undefined) return object[names[i]]; return ''; }
    function options(element, rows, idNames, textNames, placeholder) {
        element.innerHTML = '<option value="">' + (placeholder || 'Select') + '</option>';
        rows.forEach(function (row) { var option = document.createElement('option'); option.value = val(row, idNames); option.textContent = val(row, textNames); element.appendChild(option); });
    }
    function esc(value) { return String(value == null ? '' : value).replace(/[&<>"']/g, function (character) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character]; }); }
    function alertBox(message, error) {
        var element = document.getElementById('oltAlert'); if (!element) { window.alert(message); return; }
        element.textContent = message; element.className = 'olt-alert' + (error ? ' error' : ''); element.style.display = 'block';
        window.setTimeout(function () { element.style.display = 'none'; }, 5000);
    }
    window.addEventListener('pageshow', function () { hideLoading(true); });
    w.OLT = { call: call, val: val, options: options, esc: esc, alert: alertBox, showLoading: showLoading, hideLoading: hideLoading };
})(window);
