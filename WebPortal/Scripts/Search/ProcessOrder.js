(function (window, document) {
    'use strict';

    var cfg = window.ProcessOrderUIConfig || { ids: {} };
    var ids = cfg.ids || {};
    var keyValue = null;
    var startTime = null;

    function byId(name) {
        return document.getElementById(ids[name] || name);
    }

    function setMessage(message, color) {
        var box = byId('dvError');
        var label = byId('lblError');
        if (!box || !label) return;
        box.style.display = '';
        label.innerHTML = message || '';
        label.style.color = color || 'Green';
        window.HideLabel();
    }

    function getOrderValue() {
        if (window.drp_Order && typeof window.drp_Order.GetValue === 'function') {
            return window.drp_Order.GetValue();
        }
        var drp = byId('drpOrder');
        return drp ? drp.value : 0;
    }

    function addHidden(form, name, value) {
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        form.appendChild(input);
    }

    function enhanceUi() {
        document.documentElement.classList.add('po-modern-ready');
        var shell = document.querySelector('.po-modern-shell');
        if (!shell) return;

        var inputs = shell.querySelectorAll('input[type="text"], input[type="password"], textarea, select');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].classList.add('po-control');
        }

        var buttons = shell.querySelectorAll('input[type="submit"], input[type="button"], button');
        for (var b = 0; b < buttons.length; b++) {
            buttons[b].classList.add('po-btn');
        }

        var tables = shell.querySelectorAll('table');
        for (var t = 0; t < tables.length; t++) {
            if (!tables[t].closest('.po-table-wrap')) {
                var wrap = document.createElement('div');
                wrap.className = 'po-table-wrap';
                tables[t].parentNode.insertBefore(wrap, tables[t]);
                wrap.appendChild(tables[t]);
            }
        }
    }

    window.HideLabel = function () {
        window.setTimeout(function () {
            var box = byId('dvError');
            if (box) box.style.display = 'none';
        }, 5000);
    };

    window.Confirm = function (form) {
        var selectedIndex = getOrderValue();
        var remark = byId('txtTaskRemark');
        var remarkError = byId('lblRemarkError');
        var chkDispatch = byId('chkDispatch');
        var chkCancel = byId('chkCancel');
        var chkHold = byId('chkHold');

        if (chkDispatch && chkDispatch.checked && selectedIndex > 0) {
            addHidden(form, 'confirm_value', window.confirm('Do you want to dispatch Order?') ? 'Yes' : 'No');
        }

        if (chkCancel && chkCancel.checked && selectedIndex > 0) {
            if (remark && remark.value === '') {
                if (remarkError) remarkError.innerHTML = 'Please Enter Remark';
                return false;
            }
            addHidden(form, 'confirmCancel_value', window.confirm('Do you want to Cancel Order?') ? 'Yes' : 'No');
        }

        if (chkHold && chkHold.checked && selectedIndex > 0) {
            if (remark && remark.value === '') {
                if (remarkError) remarkError.innerHTML = 'Please Enter Remark';
                return false;
            }
            addHidden(form, 'confirmHold_value', window.confirm('Do you want to Hold Order?') ? 'Yes' : 'No');
        }
        return true;
    };

    window.txtTaskRemark_Change = function () {
        var chkHold = byId('chkHold');
        var chkCancel = byId('chkCancel');
        var remark = byId('txtTaskRemark');
        var remarkError = byId('lblRemarkError');
        if ((chkHold && chkHold.checked || chkCancel && chkCancel.checked) && getOrderValue() > 0) {
            remarkError.innerHTML = remark && remark.value ? '' : 'Please Enter Remark';
        }
    };

    window.OnMoreInfoClick = function (element, key) {
        if (window.callbackPanel) callbackPanel.SetContentHtml('');
        if (window.popup) popup.ShowAtElement(element);
        keyValue = key;
    };
    window.popup_Shown = function () { if (window.callbackPanel) callbackPanel.PerformCallback(keyValue); };

    window.OnEndCallback1 = function () { if (window.grid1 && grid1.cp_message === '3') { setMessage('Chain Sheet Deleted Successfully.', 'Green'); grid1.cp_message = ''; } };
    window.OnEndCallback2 = function () { if (window.grid2 && grid2.cp_message === '3') { setMessage('Search Chain Sheet Deleted Successfully.', 'Green'); grid2.cp_message = ''; } };
    window.OnEndCallback = function () {
        if (!window.grid || !grid.cp_message) { var box = byId('dvError'); if (box) box.style.display = 'none'; return; }
        var messages = { '1': 'Infinity Order updated successfully.', '0': 'Infinity Order already exists!', '3': 'Chain Sheet Deleted Successfully.', '4': "Infinity Order name can't be blank." };
        setMessage(messages[grid.cp_message] || '', grid.cp_message === '0' ? 'Red' : 'Green');
        grid.cp_message = '';
    };

    window.ValidateDate = function () {
        var from = byId('txtSignatureDate');
        var to = byId('txtRecordingDate');
        var label = byId('lblDateError');
        if (!from || !to || !label) return true;
        if (Date.parse(from.value) > Date.parse(to.value)) {
            label.innerHTML = 'Recording date should be greater than Signature date.';
            label.style.color = 'Red';
            return false;
        }
        label.innerHTML = '';
        return true;
    };

    window.btnToRight_Click = function () {
        var txt = byId('txtParcelId');
        var list = byId('lstParcelIds');
        if (!txt || !list || !txt.value.trim()) return false;
        for (var i = 0; i < list.options.length; i++) {
            if (txt.value.trim() === list.options[i].value) return false;
        }
        var option = document.createElement('option');
        option.text = txt.value.trim();
        option.value = txt.value.trim();
        list.add(option);
        txt.value = '';
        return false;
    };

    window.btnToLeft_Click = function () {
        var list = byId('lstParcelIds');
        if (list && list.selectedIndex >= 0) list.options[list.selectedIndex] = null;
        return false;
    };

    window.GetParcelIds = function () {
        var list = byId('lstParcelIds');
        var hidden = byId('hdnParcelIds');
        if (!list || !hidden) return;
        var values = [];
        for (var i = 0; i < list.options.length; i++) values.push(list.options[i].value);
        hidden.value = values.join(',');
    };

    window.CheckCheckboxes = function () {
        var boxes = ['chkDispatch', 'chkCancel', 'chkHold', 'chkTax'].map(byId);
        var partial = document.querySelector('[id*="chkPartial"]');
        if (partial) boxes.push(partial);
        var checked = boxes.filter(function (x) { return x && x.checked; });
        if (!checked.length) return;
        boxes.forEach(function (box) { if (box && box !== checked[0]) box.checked = false; });
    };

    window.OnMoreInfoClickS = function (element) { if (window.callbackPanel1) callbackPanel1.SetContentHtml(''); if (window.popupD) popupD.ShowAtElement(element); keyValue = getOrderValue(); };
    window.popupD_Shown = function () { if (window.callbackPanel1) callbackPanel1.PerformCallback(keyValue); };
    window.OnMoreInfoClickAttachments = function (element, key) { if (window.CallbackPanelAttachments) CallbackPanelAttachments.SetContentHtml(''); if (window.popupAttachments) popupAttachments.ShowAtElement(element); keyValue = key; };
    window.popupAttachments_Shown = function () { if (window.CallbackPanelAttachments) CallbackPanelAttachments.PerformCallback(keyValue); };
    window.OnMoreInfoClickCheckList = function (element) { if (window.callbackPanel11) callbackPanel11.SetContentHtml(''); if (window.popupCheckList) popupCheckList.ShowAtElement(element); keyValue = getOrderValue(); };
    window.popupCheckList_Shown = function () { if (window.callbackPanel11) callbackPanel11.PerformCallback(keyValue); };
    window.OnMoreInfoClickTaxDetails = function (element) { if (window.callbackPanel111) callbackPanel111.SetContentHtml(''); if (window.popupTaxDetails) popupTaxDetails.ShowAtElement(element); keyValue = getOrderValue(); };
    window.popupTaxDetails_Shown = function () { if (window.callbackPanel111) callbackPanel111.PerformCallback(keyValue); };

    window.onSelectAll = function (s) {
        if (!window.jQuery) return false;
        window.jQuery('[id*="CheckBox1"]').each(function () {
            try { window[this.id].SetChecked(s.GetChecked()); } catch (err) { }
        });
        return false;
    };

    window.GetCountryDetails = function () {
        var parm = byId('drpStatus');
        if (parm && parm.options[parm.selectedIndex].text === 'Transfer' && window.drpCaller) window.drpCaller.display = true;
    };

    window.ShowHideFoundddl = function () {
        var ddl = byId('ddlSearchBy');
        var found = byId('ddlFound');
        var search = byId('txtSearchBy');
        var display = ddl && ddl.selectedIndex > 0 ? 'block' : 'none';
        if (found) found.style.display = display;
        if (search) search.style.display = display;
    };

    window.OnBeginCallback_AutoComplete = function () { startTime = new Date(); };
    window.OnEndCallback_AutoComplete = function () {
        var result = ((new Date() - startTime) / 1000).toString();
        if (result.length > 4) result = result.substr(0, 4);
        if (window.time) time.SetText(result + ' sec');
        if (window.label) label.SetText('Time to retrieve the last data:');
    };

    window.getFlickerSolved = function () { var panel = byId('panel1'); if (panel) panel.style.display = 'none'; };
    window.CheckAll = function (oCheckbox) {
        var grid = byId('grdCheckList');
        if (!grid || !grid.rows) return;
        for (var i = 1; i < grid.rows.length; i++) {
            var input = grid.rows[i].cells[0].getElementsByTagName('input')[0];
            if (input) input.checked = oCheckbox.checked;
        }
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', enhanceUi);
    } else {
        enhanceUi();
    }
})(window, document);
