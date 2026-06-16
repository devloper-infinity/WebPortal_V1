<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRReportInput.aspx.cs" Inherits="WebPortal.Admin.HRReportInput" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

    <style>
        /*:root {
            --hr-primary: #2563eb;
            --hr-primary-dark: #1d4ed8;
            --hr-accent: #06b6d4;
            --hr-bg: #f5f7fb;
            --hr-surface: rgba(255,255,255,.92);
            --hr-border: #e5e7eb;
            --hr-text: #0f172a;
            --hr-muted: #64748b;
            --hr-radius: 18px;
            --hr-shadow: 0 20px 45px rgba(15,23,42,.08);
        }

        body {
            background: var(--hr-bg);
            color: var(--hr-text);
        }

        .content-header {
            padding: 20px 20px 0;
        }

            .content-header .container {
                max-width: 100%;
            }

            .content-header .callout-info {
                position: relative;
                overflow: hidden;
                border: 0 !important;
                border-radius: 22px;
                padding: 24px 28px;
                background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 48%, #06b6d4 100%);
                color: #fff;
                box-shadow: var(--hr-shadow);
            }

                .content-header .callout-info:after {
                    content: "";
                    position: absolute;
                    right: -80px;
                    top: -80px;
                    width: 220px;
                    height: 220px;
                    border-radius: 999px;
                    background: rgba(255,255,255,.16);
                }

            .content-header h6 {
                font-size: 1.35rem;
                font-weight: 800;
                letter-spacing: -.02em;
            }

        .col-lg-12 {
            padding: 20px;
        }

        .card {
            border: 1px solid var(--hr-border) !important;
            border-radius: var(--hr-radius) !important;
            box-shadow: var(--hr-shadow) !important;
            background: var(--hr-surface);
        }

        .card-body {
            padding: 22px !important;
        }

        .card-tabs {
            overflow: hidden;
        }

            .card-tabs > .card-header {
                background: #fff !important;
                border-bottom: 1px solid var(--hr-border) !important;
                padding: 14px 16px 0 !important;
            }

        .nav-tabs {
            gap: 8px;
            border-bottom: 0 !important;
            flex-wrap: wrap;
        }

            .nav-tabs .nav-link {
                border: 1px solid transparent !important;
                border-radius: 999px !important;
                color: var(--hr-muted) !important;
                padding: 10px 16px !important;
                font-weight: 700;
                transition: all .2s ease;
            }

                .nav-tabs .nav-link:hover {
                    background: #eff6ff;
                    color: var(--hr-primary) !important;
                }

                .nav-tabs .nav-link.active {
                    background: var(--hr-primary) !important;
                    color: #fff !important;
                    box-shadow: 0 10px 22px rgba(37,99,235,.25);
                }

        .tab-pane > .table:first-child {
            display: block;
            width: 100%;
            margin-bottom: 18px;
            border: 1px solid var(--hr-border);
            border-radius: var(--hr-radius);
            padding: 18px;
            background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
        }

            .tab-pane > .table:first-child tbody,
            .tab-pane > .table:first-child tr {
                display: contents;
            }

        .tab-pane > .table:first-child {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px;
        }

            .tab-pane > .table:first-child td {
                display: block;
                border: 0 !important;
                padding: 0 !important;
            }

                .tab-pane > .table:first-child td:empty {
                    display: none;
                }

                .tab-pane > .table:first-child td b {
                    display: block;
                    margin-bottom: 7px;
                    color: var(--hr-muted);
                    font-size: .78rem;
                    letter-spacing: .04em;
                    text-transform: uppercase;
                }

        .form-control,
        select.form-control,
        input.form-control {
            width: 100% !important;
            min-height: 42px;
            border-radius: 12px !important;
            border: 1px solid var(--hr-border) !important;
            background-color: #fff !important;
            color: var(--hr-text) !important;
            box-shadow: none !important;
        }

            .form-control:focus {
                border-color: var(--hr-primary) !important;
                box-shadow: 0 0 0 4px rgba(37,99,235,.12) !important;
            }

        input[type="file"].form-control {
            padding: 8px 12px;
        }

        .btn.btn-primary {
            min-height: 42px;
            border: 0 !important;
            border-radius: 12px !important;
            padding: 10px 22px !important;
            font-weight: 800;
            background: linear-gradient(135deg, var(--hr-primary), var(--hr-accent)) !important;
            box-shadow: 0 12px 24px rgba(37,99,235,.24);
        }

            .btn.btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 16px 30px rgba(37,99,235,.30);
            }

        .dropzone {
            margin-top: 8px;
            border: 0 !important;
            background: transparent !important;
        }

        .dz-preview {
            border-radius: 12px;
            padding: 8px 12px;
            background: #eef6ff;
            color: var(--hr-primary-dark);
            font-weight: 600;
        }

        hr {
            border-top: 1px solid var(--hr-border);
            margin: 20px 0;
        }

        .tab-pane > table[id] {
            border-collapse: separate !important;
            border-spacing: 0;
            overflow: hidden;
            border: 1px solid var(--hr-border);
            border-radius: var(--hr-radius);
            background: #fff;
        }

            .tab-pane > table[id] thead th {
                background: #f8fafc;
                color: #475569;
                font-size: .78rem;
                letter-spacing: .04em;
                text-transform: uppercase;
                border-top: 0 !important;
                border-bottom: 1px solid var(--hr-border) !important;
                padding: 14px 12px !important;
            }

            .tab-pane > table[id] tbody td {
                padding: 13px 12px !important;
                vertical-align: middle;
                border-color: #eef2f7 !important;
            }

        .modal-content {
            border: 0;
            border-radius: var(--hr-radius);
            box-shadow: var(--hr-shadow);
        }

        .modal-header {
            border-bottom: 1px solid var(--hr-border);
        }

        .loading {
            border-radius: var(--hr-radius);
            background: rgba(255,255,255,.9);
            backdrop-filter: blur(8px);
            box-shadow: var(--hr-shadow);
            color: var(--hr-text);
        }

        @media (max-width: 992px) {
            .tab-pane > .table:first-child {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .content-header, .col-lg-12 {
                padding-left: 12px;
                padding-right: 12px;
            }

            .tab-pane > .table:first-child {
                grid-template-columns: 1fr;
            }

            .card-body {
                padding: 14px !important;
            }
        }*/

        /* Labels above fields */
        /*.tab-pane .table tr {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
        }

        .tab-pane .table td {
            display: flex;
            flex-direction: column;
            border-top: none !important;
            min-width: 260px;
        }

            .tab-pane .table td b {
                margin-bottom: 8px;
                color: var(--hr-text);
                font-weight: 600;
            }*/


        /* Asset-style modern HR report layout */
        :root {
            --hr-primary: #4f46e5;
            --hr-primary-dark: #3730a3;
            --hr-accent: #0e7490;
            --hr-bg: #f6f8fc;
            --hr-surface: #ffffff;
            --hr-border: #d9e2f1;
            --hr-text: #0b1f3a;
            --hr-muted: #58708d;
            --hr-radius: 16px;
            --hr-shadow: 0 12px 28px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--hr-bg) !important;
        }

        .content-header {
            display: none;
        }

        .col-lg-12 {
            padding: 10px 12px 0 !important;
        }

        .card {
            border: 0 !important;
            box-shadow: none !important;
            background: transparent !important;
        }

            .card > .card-body {
                padding: 0 !important;
            }

        .card-tabs {
            border: 1px solid #dce6f4 !important;
            border-radius: 0 !important;
            background: #f8fbff !important;
            box-shadow: none !important;
            overflow: visible !important;
        }

            .card-tabs > .card-header {
                margin: 8px 0 12px !important;
                padding: 8px 6px !important;
                background: #eaf0fb !important;
                border: 0 !important;
                border-radius: 14px !important;
            }

        .nav-tabs {
            display: grid !important;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 10px !important;
            width: 100%;
        }

            .nav-tabs .nav-item {
                width: 100%;
            }

            .nav-tabs .nav-link {
                width: 100%;
                min-height: 42px;
                display: flex !important;
                align-items: center;
                justify-content: center;
                gap: 8px;
                border: 1px solid transparent !important;
                border-radius: 10px !important;
                background: transparent !important;
                color: #102a4c !important;
                font-size: 12px;
                font-weight: 800 !important;
                box-shadow: none !important;
            }

                .nav-tabs .nav-link.active {
                    background: #fff !important;
                    color: #083344 !important;
                    border-color: #d7e2f0 !important;
                    border-bottom: 3px solid #087c9a !important;
                    box-shadow: 0 8px 14px rgba(15, 23, 42, .10) !important;
                }

                .nav-tabs .nav-link:hover {
                    background: #f7fbff !important;
                    color: #083344 !important;
                }

        .card-tabs > .card-body {
            margin: 0 14px 14px !important;
            padding: 20px !important;
            background: #fff !important;
            border-radius: 18px !important;
            box-shadow: 0 8px 18px rgba(15, 23, 42, .04) !important;
        }

        .tab-pane > .table:first-child,
        .tab-pane > .table:first-child.hr-modern-form {
            display: block !important;
            width: 100%;
            margin: 0 0 22px !important;
            padding: 0 !important;
            border: 0 !important;
            border-radius: 0 !important;
            background: transparent !important;
        }

        .hr-modern-form tbody {
            display: block !important;
            width: 100%;
        }

        .hr-modern-form tr {
            display: grid !important;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px 18px !important;
            width: 100%;
            margin-bottom: 16px !important;
        }

        .hr-modern-form td,
        .tab-pane .table.hr-modern-form td {
            display: block !important;
            min-width: 0 !important;
            padding: 0 !important;
            border: 0 !important;
        }

        .hr-form-field label {
            display: block;
            margin: 0 0 8px;
            color: #17365d;
            font-size: 12px;
            font-weight: 700;
        }

        .hr-form-field .form-control,
        .hr-form-field select.form-control,
        .hr-form-field input.form-control,
        .hr-form-field textarea.form-control {
            width: 100% !important;
            height: 42px;
            min-height: 42px;
            border-radius: 10px !important;
            border: 1px solid #cfdced !important;
            background-color: #fff !important;
            color: #0f172a !important;
            font-size: 12px;
            box-shadow: none !important;
        }

        .hr-form-field textarea.form-control {
            height: auto;
            min-height: 86px;
        }

        .hr-form-field .form-control:focus {
            border-color: #087c9a !important;
            box-shadow: 0 0 0 3px rgba(8,124,154,.12) !important;
        }

        .hr-action-cell {
            display: flex !important;
            align-items: end;
            gap: 10px;
        }

        .btn.btn-primary {
            min-height: 42px;
            border-radius: 10px !important;
            background: linear-gradient(135deg, #2563eb, #6d28d9) !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25) !important;
            font-size: 12px;
            font-weight: 800;
        }

        .tab-pane > table[id] {
            width: 100% !important;
            margin-top: 18px;
            border: 1px solid #d9e2f1 !important;
            border-radius: 14px !important;
            overflow: hidden;
            background: #fff;
        }

            .tab-pane > table[id] thead th {
                background: #f4f7fb !important;
                color: #17365d !important;
                font-size: 12px !important;
            }

        @media (max-width: 992px) {
            .nav-tabs {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .hr-modern-form tr {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .nav-tabs, .hr-modern-form tr {
                grid-template-columns: 1fr;
            }

            .card-tabs > .card-body {
                margin: 0 8px 8px !important;
                padding: 14px !important;
            }
        }


        /* Final HR module polish: asset-style cards, modern tabs, and fixed data grids */
        .card-tabs {
            background: transparent !important;
            border: 0 !important;
        }

            .card-tabs > .card-header {
                margin: 0 0 14px !important;
                padding: 8px !important;
                background: #eaf1fb !important;
                border-radius: 14px !important;
                box-shadow: inset 0 0 0 1px #d9e5f4 !important;
            }

        .nav-tabs {
            gap: 12px !important;
        }

            .nav-tabs .nav-link {
                height: 46px !important;
                border-radius: 10px !important;
                letter-spacing: .01em;
            }

                .nav-tabs .nav-link.active {
                    border-bottom: 3px solid #087c9a !important;
                    box-shadow: 0 9px 18px rgba(15, 23, 42, .12) !important;
                }

        .card-tabs > .card-body {
            position: relative;
            padding: 18px !important;
            border: 1px solid #d9e5f4 !important;
            border-radius: 18px !important;
            background: #fff !important;
        }

        .tab-pane:before {
            display: block;
            margin: 2px 0 4px;
            color: #0b1f3a;
            font-size: 18px;
            font-weight: 800;
        }

        .tab-pane:after {
            content: "Fill in the details below and review the saved records.";
            display: block;
            margin: -2px 0 16px;
            padding-bottom: 14px;
            color: #58708d;
            font-size: 12px;
            border-bottom: 1px solid #d9e5f4;
        }

        .tab-pane > .table:first-child.hr-modern-form {
            padding: 0 6px 4px !important;
            margin-bottom: 22px !important;
        }

        .hr-modern-form tr {
            grid-template-columns: repeat(4, minmax(190px, 1fr)) !important;
            align-items: end !important;
        }

            .hr-modern-form tr:empty {
                display: none !important;
            }

        .hr-form-field label {
            text-transform: none !important;
            color: #17365d !important;
            font-size: 12px !important;
            font-weight: 700 !important;
        }

        .hr-form-field .form-control,
        .hr-form-field select.form-control,
        .hr-form-field input.form-control {
            height: 44px !important;
            min-height: 44px !important;
            border-radius: 10px !important;
            padding: 8px 13px !important;
        }

        .hr-action-cell {
            align-self: end !important;
        }

        .btn.btn-primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            height: 44px !important;
            min-width: 88px;
            padding: 0 22px !important;
        }

        hr {
            border: 0 !important;
            border-top: 1px solid #d9e5f4 !important;
            margin: 20px 0 16px !important;
        }

        /* Top Toolbar Alignment */
        .dataTables_wrapper .row:first-child {
            display: flex !important;
            align-items: center !important;
            justify-content: flex-start !important;
            gap: 15px !important;
            margin-bottom: 15px !important;
        }

        /* Page Length */
        .dataTables_wrapper .dataTables_length {
            display: flex !important;
            align-items: center !important;
            margin: 0 !important;
        }

            .dataTables_wrapper .dataTables_length label {
                display: flex !important;
                align-items: center !important;
                gap: 8px;
                margin: 0 !important;
                font-size: 13px;
            }

        /* Excel Button */
        .dt-buttons {
            margin: 0 !important;
            display: flex !important;
            align-items: center !important;
        }

        .buttons-excel {
            height: 40px !important;
            margin: 0 !important;
        }

        /* Search Box */
        .dataTables_wrapper .dataTables_filter {
            margin-left: auto !important;
            display: flex !important;
            align-items: center !important;
        }

            .dataTables_wrapper .dataTables_filter label {
                display: flex !important;
                align-items: center !important;
                gap: 8px;
                margin: 0 !important;
            }

            .dataTables_wrapper .dataTables_filter input {
                width: 240px !important;
                margin-left: 0 !important;
            }

        .dt-button, button.dt-button, .buttons-excel, .btn-secondary {
            min-height: 38px !important;
            border: 0 !important;
            border-radius: 10px !important;
            padding: 8px 16px !important;
            background: linear-gradient(135deg, #ff9f8e, #fb5f90) !important;
            color: #0b1f3a !important;
            font-weight: 800 !important;
            box-shadow: 0 8px 18px rgba(251, 95, 144, .22) !important;
        }

        /* Critical reset: record grids must remain real tables, not flex rows */
        .tab-pane > table[id],
        .dataTables_wrapper table[id],
        table.dataTable {
            display: table !important;
            width: 100% !important;
            min-width: 760px !important;
            table-layout: auto !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            border: 1px solid #d9e2f1 !important;
            border-radius: 12px !important;
            overflow: hidden !important;
        }

            .tab-pane > table[id] thead,
            .tab-pane > table[id] tbody,
            .dataTables_wrapper table[id] thead,
            .dataTables_wrapper table[id] tbody,
            table.dataTable thead,
            table.dataTable tbody {
                display: table-header-group !important;
                padding: 0px;
            }

            .tab-pane > table[id] tbody,
            .dataTables_wrapper table[id] tbody,
            table.dataTable tbody {
                display: table-row-group !important;
            }

            .tab-pane > table[id] tr,
            .dataTables_wrapper table[id] tr,
            table.dataTable tr {
                display: table-row !important;
                margin: 0 !important;
            }

            .tab-pane > table[id] th,
            .tab-pane > table[id] td,
            .dataTables_wrapper table[id] th,
            .dataTables_wrapper table[id] td,
            table.dataTable th,
            table.dataTable td {
                display: table-cell;
                min-width: auto !important;
                padding: 13px 14px !important;
                border-top: 0 !important;
                border-bottom: 1px solid #edf2f8 !important;
                white-space: nowrap !important;
            }

            .tab-pane > table[id] thead th,
            .dataTables_wrapper table[id] thead th,
            table.dataTable thead th {
                background: #eef6ff !important;
                color: #17365d !important;
                font-size: 12px !important;
                font-weight: 800 !important;
            }

            .tab-pane > table[id] tbody tr:hover td,
            .dataTables_wrapper table[id] tbody tr:hover td,
            table.dataTable tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_scroll, .dataTables_scrollBody {
            width: 100% !important;
        }

        .dataTables_wrapper .row:nth-child(2) {
            overflow-x: auto !important;
            margin: 0 !important;
        }

        @media (max-width: 992px) {
            .hr-modern-form tr {
                grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
            }

            .dataTables_wrapper .row:first-child {
                align-items: stretch !important;
                flex-direction: column !important;
            }
        }

        @media (max-width: 576px) {
            .hr-modern-form tr {
                grid-template-columns: 1fr !important;
            }

            .card-tabs > .card-body {
                padding: 14px !important;
            }
        }
    </style>

    <script>

        $(document).ready(function () {

            newCompany_BindGrid();

            socialsite_bindusersNew();
            socialsite_bindgrid();
            socialsite_BindYear();

            glassrating_BindYear();
            glassrating_BindGrid();
            glasscomp_bindcompetitors();
            glasscomp_BindYear();
            glasscomp_BindGrid();

            var dtToday = new Date();

            var month = dtToday.getMonth() + 1;
            var day = dtToday.getDate();
            var year = dtToday.getFullYear();

            if (month < 10)
                month = '0' + month.toString();
            if (day < 10)
                day = '0' + day.toString();

            var maxDate = year + '-' + month + '-' + day;
            $('#socialsite_datevisited').attr('max', maxDate);
        });

        window.onload = function () {
            document.getElementById('socialsite_attachment').addEventListener('change', getFileName);
            document.getElementById('glassrating_attachment').addEventListener('change', getFileName_glass);
            document.getElementById('glasscomp_attachment').addEventListener('change', getFileName_glasscomp);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }

        const getFileName_glass = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("glass_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("glass_dropzone").classList.add("dz-max-files-reached");
            document.getElementById("glassrating_conentdiv").style.display = '';
            document.getElementById("glassrating_filesdiv").innerHTML = file.name;
        }

        const getFileName_glasscomp = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("glasscomp_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("glasscomp_dropzone").classList.add("dz-max-files-reached");
            document.getElementById("glasscomp_conentdiv").style.display = '';
            document.getElementById("glasscomp_filesdiv").innerHTML = file.name;
        }

    </script>

    <script>
        // Modern HR form layout: pair each label cell with its field cell so labels sit above fields.
        function applyModernHrFormLayout() {
            $('.tab-pane > table.table:first-child').each(function () {
                var $table = $(this);
                if ($table.data('modernized') === true) return;

                $table.find('tr').each(function () {
                    var $row = $(this);
                    var $cells = $row.children('td').toArray();
                    var $newCells = $();

                    for (var i = 0; i < $cells.length; i++) {
                        var $cell = $($cells[i]);
                        var $label = $cell.children('b').first();
                        var next = $cells[i + 1] ? $($cells[i + 1]) : null;

                        if ($label.length && next && !next.children('b').length) {
                            var $fieldCell = $('<td class="hr-field-cell"></td>');
                            var $field = $('<div class="hr-form-field"></div>');
                            $('<label></label>').html($label.html().replace(':', '')).appendTo($field);
                            next.contents().appendTo($field);
                            $field.appendTo($fieldCell);
                            $newCells = $newCells.add($fieldCell);
                            i++;
                        } else if ($.trim($cell.text()).length || $cell.children().length) {
                            $cell.addClass('hr-action-cell');
                            $newCells = $newCells.add($cell);
                        }
                    }

                    $row.empty().append($newCells);
                });

                $table.data('modernized', true).addClass('hr-modern-form');
            });
        }

        $(document).ready(function () {
            applyModernHrFormLayout();
            $('a[data-toggle="pill"]').on('shown.bs.tab', applyModernHrFormLayout);
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <input id="glass_filep" style="display: none;" />
    <input id="glasscomp_filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-money-check-alt mr-2"></i>
                    Social Media Inputs
                </div>

                <div class="dashboard-subtitle">
                    Manage employee advance payments, installments, balances, and repayment tracking.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b>Social Site Visit</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><b>Glassdoor Rating</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false"><b>Glassdoor Competitors</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-addcompany-tab" data-toggle="pill" href="#custom-tabs-one-addcompany" role="tab" aria-controls="custom-tabs-one-addcompany" aria-selected="false"><b>Add New Company</b></a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-4">
                                        <label class="form-label"><b>Employee:</b></label>
                                        <select id="socialsite_employee" name="socialsite_employee" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Social Site:</b></label>
                                        <select id="socialsite_site" name="socialsite_site" class="form-control">
                                            <option value="">Select</option>
                                            <option value="Naukri">Naukri</option>
                                            <option value="LinkedIn">LinkedIn</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Date Visited:</b></label>
                                        <input type="date"
                                            id="socialsite_datevisited"
                                            name="socialsite_datevisited"
                                            class="form-control"
                                            onkeydown="return false" />
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Month:</b></label>
                                        <select id="socialsite_month" name="socialsite_month" class="form-control">
                                            <option value="">Select</option>
                                            <option value="January">January</option>
                                            <option value="February">February</option>
                                            <option value="March">March</option>
                                            <option value="April">April</option>
                                            <option value="May">May</option>
                                            <option value="June">June</option>
                                            <option value="July">July</option>
                                            <option value="August">August</option>
                                            <option value="September">September</option>
                                            <option value="October">October</option>
                                            <option value="November">November</option>
                                            <option value="December">December</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Year:</b></label>
                                        <select id="socialsite_year" name="socialsite_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Attachment:</b></label>
                                        <input type="file" id="socialsite_attachment" name="socialsite_attachment" class="form-control" />

                                        <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete mt-2" id="dropzone">
                                            <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column"
                                                id="conentdiv"
                                                style="display: none!important;">
                                                <div class="flex-1 d-flex flex-between-center">
                                                    <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>

                                                    <div class="dropdown font-sans-serif">
                                                        <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none"
                                                            type="button"
                                                            data-bs-toggle="dropdown"
                                                            aria-haspopup="true"
                                                            aria-expanded="false">
                                                            <svg class="svg-inline--fa fa-ellipsis"
                                                                style="display: none!important"
                                                                aria-hidden="true"
                                                                focusable="false"
                                                                data-prefix="fas"
                                                                data-icon="ellipsis"
                                                                role="img"
                                                                xmlns="http://www.w3.org/2000/svg"
                                                                viewBox="0 0 448 512">
                                                                <path fill="currentColor"
                                                                    d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z">
                                                                </path>
                                                            </svg>
                                                        </button>

                                                        <div class="dropdown-menu dropdown-menu-end border py-2">
                                                            <a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12 text-center mt-3">
                                        <button id="socialsite_btnsubmit" class="btn btn-primary" onclick="return socialsite_submit();">Submit</button>
                                    </div>
                                </div>
                                <hr />
                                <table class="table" id="socialsite_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 5%">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 20%;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 20%;">Site Visited</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 20%;">Date Visited</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 20%;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">FileName</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-2">
                                        <label class="form-label"><b>Month</b></label>
                                        <select id="glassrating_month" name="glassrating_month" class="form-control">
                                            <option value="">Select</option>
                                            <option value="January">January</option>
                                            <option value="February">February</option>
                                            <option value="March">March</option>
                                            <option value="April">April</option>
                                            <option value="May">May</option>
                                            <option value="June">June</option>
                                            <option value="July">July</option>
                                            <option value="August">August</option>
                                            <option value="September">September</option>
                                            <option value="October">October</option>
                                            <option value="November">November</option>
                                            <option value="December">December</option>
                                        </select>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label"><b>Year</b></label>
                                        <select id="glassrating_year" name="glassrating_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label"><b>Company Rating</b></label>
                                        <input type="text" id="glassrating_companyrating"
                                            name="glassrating_companyrating" class="form-control">
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label"><b>Attachment</b></label>
                                        <input type="file" id="glassrating_attachment"
                                            name="glassrating_attachment" class="form-control">
                                    </div>

                                    <div class="col-md-2">
                                        <button id="glassrating_btnsubmit"
                                            class="btn btn-primary w-100"
                                            onclick="return glassrating_submit();">
                                            Submit
                                        </button>
                                    </div>

                                </div>
                                <br />
                                <hr />
                                <table class="table" id="glassrating_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Company Rating</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">Attachment</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                                <div class="row g-3">

                                    <!-- Company -->
                                    <div class="col-md-3">
                                        <label class="form-label"><b>Company</b></label>
                                        <select id="glasscomp_company" name="glasscomp_company" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <!-- Month -->
                                    <div class="col-md-2">
                                        <label class="form-label"><b>Month</b></label>
                                        <select id="glasscomp_month" name="glasscomp_month" class="form-control">
                                            <option value="">Select</option>
                                            <option value="January">January</option>
                                            <option value="February">February</option>
                                            <option value="March">March</option>
                                            <option value="April">April</option>
                                            <option value="May">May</option>
                                            <option value="June">June</option>
                                            <option value="July">July</option>
                                            <option value="August">August</option>
                                            <option value="September">September</option>
                                            <option value="October">October</option>
                                            <option value="November">November</option>
                                            <option value="December">December</option>
                                        </select>
                                    </div>

                                    <!-- Year -->
                                    <div class="col-md-2">
                                        <label class="form-label"><b>Year</b></label>
                                        <select id="glasscomp_year" name="glasscomp_year" class="form-control">
                                            <option value="">Select</option>
                                        </select>
                                    </div>

                                    <!-- Company Rating -->
                                    <div class="col-md-2">
                                        <label class="form-label"><b>Company Rating</b></label>
                                        <input type="text"
                                            id="glasscomp_companyrating"
                                            name="glasscomp_companyrating"
                                            class="form-control" />
                                    </div>

                                    <!-- Attachment -->
                                    <div class="col-md-3">
                                        <label class="form-label"><b>Attachment</b></label>
                                        <input type="file"
                                            id="glasscomp_attachment"
                                            name="glasscomp_attachment"
                                            class="form-control" />

                                        <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete mt-2"
                                            id="glasscomp_dropzone">
                                            <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column"
                                                id="glasscomp_conentdiv"
                                                style="display: none !important;">

                                                <div class="flex-1 d-flex flex-between-center">
                                                    <div id="glasscomp_filesdiv"
                                                        style="margin-top: 10px; margin-bottom: 10px;">
                                                    </div>

                                                    <div class="dropdown font-sans-serif">
                                                        <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none"
                                                            type="button"
                                                            data-bs-toggle="dropdown">
                                                            <span class="fas fa-ellipsis-h"></span>
                                                        </button>

                                                        <div class="dropdown-menu dropdown-menu-end border py-2">
                                                            <a class="dropdown-item"
                                                                href="#!"
                                                                data-dz-remove="data-dz-remove">Remove File
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <!-- Submit Button Row -->
                                <div class="row mt-4">
                                    <div class="col-12 text-center">
                                        <button id="glasscomp_btnsubmit"
                                            class="btn btn-primary px-4"
                                            onclick="return glasscomp_submit();">
                                            Submit
                                        </button>
                                    </div>
                                </div>

                                <hr />
                                <table class="table" id="glasscomp_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Company Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Company Rating</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">Attachment</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-addcompany" role="tabpanel" aria-labelledby="custom-tabs-one-addcompany-tab">
                                <div class="row align-items-end g-3">

                                    <hr />
                                    <div class="col-md-4">
                                        <label class="form-label"><b>Company</b></label>
                                        <input type="text" id="newcompany_add" name="newcompany_add" class="form-control">
                                    </div>

                                    <div class="col-md-2">
                                        <button id="newcompany_btnsubmit" name="newcompany_btnsubmit" type="button" class="btn btn-primary w-100" onclick="return newcompany_submit();">Submit</button>
                                    </div>
                                </div>
                                <hr />
                                <table class="table" id="table_newcompany">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Company Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="socialsite_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="socialsite_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="socialsite_btnMessage" onclick="return socialsite_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>

        $(document).ready(function () {

            newCompany_BindGrid();

            socialsite_bindusersNew();
            socialsite_bindgrid();
            socialsite_BindYear();

            glassrating_BindYear();
            glassrating_BindGrid();
            glasscomp_bindcompetitors();
            glasscomp_BindYear();
            glasscomp_BindGrid();

            var dtToday = new Date();

            var month = dtToday.getMonth() + 1;
            var day = dtToday.getDate();
            var year = dtToday.getFullYear();

            if (month < 10)
                month = '0' + month.toString();
            if (day < 10)
                day = '0' + day.toString();

            var maxDate = year + '-' + month + '-' + day;
            $('#socialsite_datevisited').attr('max', maxDate);
        });

        window.onload = function () {
            document.getElementById('socialsite_attachment').addEventListener('change', getFileName);
            document.getElementById('glassrating_attachment').addEventListener('change', getFileName_glass);
            document.getElementById('glasscomp_attachment').addEventListener('change', getFileName_glasscomp);
        }

        const getFileName = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("dropzone").classList.add("dz-max-files-reached");
            document.getElementById("conentdiv").style.display = '';
            document.getElementById("filesdiv").innerHTML = file.name;
        }

        const getFileName_glass = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("glass_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("glass_dropzone").classList.add("dz-max-files-reached");
            document.getElementById("glassrating_conentdiv").style.display = '';
            document.getElementById("glassrating_filesdiv").innerHTML = file.name;
        }

        const getFileName_glasscomp = (event) => {
            const files = event.target.files;
            var file = files[0];
            document.getElementById("glasscomp_filep").value = files[0].name;

            const fd = new FormData();

            // add all selected files
            fd.append(event.target.name, file, file.name);
            // create the request
            const xhr = new XMLHttpRequest();

            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    // we done!
                }
            };
            var url = window.location.href;
            // path to server would be where you'd normally post the form to
            xhr.open('POST', url, true);
            xhr.send(fd);
            document.getElementById("glasscomp_dropzone").classList.add("dz-max-files-reached");
            document.getElementById("glasscomp_conentdiv").style.display = '';
            document.getElementById("glasscomp_filesdiv").innerHTML = file.name;
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <input id="glass_filep" style="display: none;" />
    <input id="glasscomp_filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Social Media Inputs</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b>Social Site Visit</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><b>Glassdoor Rating</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false"><b>Glassdoor Competitors</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-addcompany-tab" data-toggle="pill" href="#custom-tabs-one-addcompany" role="tab" aria-controls="custom-tabs-one-addcompany" aria-selected="false"><b>Add New Company</b></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">

                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Employee:</b></td>
                                        <td>
                                            <select id="socialsite_employee" name="socialsite_employee" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Social Site:</b></td>
                                        <td>
                                            <select id="socialsite_site" name="socialsite_site" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="Naukri">Naukri</option>
                                                <option value="LinkedIn">LinkedIn</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td><b>Date Visited:</b></td>
                                        <td>
                                            <input type="date" id="socialsite_datevisited" onkeydown="return false" name="socialsite_datevisited" class="form-control" style="width: 300px;" />
                                        </td>

                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="socialsite_month" name="socialsite_month" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="January">January</option>
                                                <option value="February">February</option>
                                                <option value="March">March</option>
                                                <option value="April">April</option>
                                                <option value="May">May</option>
                                                <option value="June">June</option>
                                                <option value="July">July</option>
                                                <option value="August">August</option>
                                                <option value="September">September</option>
                                                <option value="October">October</option>
                                                <option value="November">November</option>
                                                <option value="December">December</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Year:</b></td>
                                        <td>
                                            <select id="socialsite_year" name="socialsite_year" class="form-control" style="width: 300px;">
                                                <option value="Select">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="socialsite_attachment" name="socialsite_attachment" class="form-control" style="width: 300px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                        <div class="dropdown font-sans-serif">
                                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <button id="socialsite_btnsubmit" class="btn btn-primary" onclick="return socialsite_submit();">Submit</button>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="socialsite_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Site Visited</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date Visited</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">FileName</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="glassrating_month" name="glassrating_month" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="January">January</option>
                                                <option value="February">February</option>
                                                <option value="March">March</option>
                                                <option value="April">April</option>
                                                <option value="May">May</option>
                                                <option value="June">June</option>
                                                <option value="July">July</option>
                                                <option value="August">August</option>
                                                <option value="September">September</option>
                                                <option value="October">October</option>
                                                <option value="November">November</option>
                                                <option value="December">December</option>
                                            </select>
                                        </td>
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="glassrating_year" name="glassrating_year" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Company Rating:</b></td>
                                        <td>
                                            <input type="text" id="glassrating_companyrating" name="glassrating_datevisited" class="form-control" style="width: 300px;" />
                                        </td>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="glassrating_attachment" name="glassrating_attachment" class="form-control" style="width: 300px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="glass_dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="glassrating_conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="glassrating_filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                        <div class="dropdown font-sans-serif">
                                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <button id="glassrating_btnsubmit" class="btn btn-primary" onclick="return glassrating_submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="glassrating_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Company Rating</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">Attachment</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Company:</b></td>
                                        <td>
                                            <select id="glasscomp_company" name="glasscomp_company" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="glasscomp_month" name="glasscomp_month" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                                <option value="January">January</option>
                                                <option value="February">February</option>
                                                <option value="March">March</option>
                                                <option value="April">April</option>
                                                <option value="May">May</option>
                                                <option value="June">June</option>
                                                <option value="July">July</option>
                                                <option value="August">August</option>
                                                <option value="September">September</option>
                                                <option value="October">October</option>
                                                <option value="November">November</option>
                                                <option value="December">December</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="glasscomp_year" name="glasscomp_year" class="form-control" style="width: 300px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>

                                        <td><b>Company Rating:</b></td>
                                        <td>
                                            <input type="text" id="glasscomp_companyrating" name="glasscomp_companyrating" class="form-control" style="width: 300px;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Attachment:</b></td>
                                        <td>
                                            <input type="file" id="glasscomp_attachment" name="glasscomp_attachment" class="form-control" style="width: 300px;" />
                                            <div class="dropzone dropzone-multiple p-0 dz-clickable dz-file-processing dz-file-complete" id="glasscomp_dropzone">
                                                <div class="dz-preview dz-preview-multiple m-0 d-flex flex-column" id="glasscomp_conentdiv" style="display: none!important;">
                                                    <div class="flex-1 d-flex flex-between-center">
                                                        <div id="glasscomp_filesdiv" style="margin-top: 10px; margin-bottom: 10px;"></div>
                                                        <div class="dropdown font-sans-serif">
                                                            <button class="btn btn-link text-600 btn-sm dropdown-toggle btn-reveal dropdown-caret-none" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="svg-inline--fa fa-ellipsis" style="display: none!important" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="ellipsis" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="">
                                                                    <path fill="currentColor" d="M120 256C120 286.9 94.93 312 64 312C33.07 312 8 286.9 8 256C8 225.1 33.07 200 64 200C94.93 200 120 225.1 120 256zM280 256C280 286.9 254.9 312 224 312C193.1 312 168 286.9 168 256C168 225.1 193.1 200 224 200C254.9 200 280 225.1 280 256zM328 256C328 225.1 353.1 200 384 200C414.9 200 440 225.1 440 256C440 286.9 414.9 312 384 312C353.1 312 328 286.9 328 256z"></path></svg><!-- <span class="fas fa-ellipsis-h"></span> Font Awesome fontawesome.com --></button>
                                                            <div class="dropdown-menu dropdown-menu-end border py-2"><a class="dropdown-item" href="#!" data-dz-remove="data-dz-remove">Remove File</a></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <button id="glasscomp_btnsubmit" class="btn btn-primary" onclick="return glasscomp_submit();">Submit</button>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="glasscomp_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Company Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Company Rating</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attachment</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; display: none;">Attachment</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-addcompany" role="tabpanel" aria-labelledby="custom-tabs-one-addcompany-tab">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <b>Company :</b>
                                        </td>
                                        <td>
                                            <input type="text" id="newcompany_add" name="newcompany_add" class="form-control" style="width: 300px;" />
                                        </td>
                                        <td>
                                            <button id="newcompany_btnsubmit" name="newcompany_btnsubmit" type="button" class="btn btn-primary" onclick="return newcompany_submit();">Submit</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="table_newcompany">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Company Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="socialsite_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="socialsite_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="socialsite_btnMessage" onclick="return socialsite_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>--%>
