<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SetAppreciationDisciplinaryAction.aspx.cs" Inherits="WebPortal.Admin.SetAppreciationDisciplinaryAction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .body {
            margin: 0 !important;
        }

        :root {
            --setappr-ink: #142033;
            --setappr-muted: #64748b;
            --setappr-border: #dbe5f1;
            --setappr-soft: #f5f8fc;
            --setappr-blue: #1d4ed8;
            --setappr-teal: #0f766e;
            --setappr-amber: #b45309;
            --setappr-red: #b91c1c;
        }

        .setappr-page {
            padding: 0px 0 28px;
            color: var(--setappr-ink);
            font-size: 13px;
        }

        .setappr-shell {
            width: 100%;
            max-width: 1480px;
            margin: 0 auto;
        }

        .setappr-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            min-height: 78px;
            padding: 16px 18px;
            border: 1px solid rgba(255,255,255,.2);
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #193b72 0%, #0f766e 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .setappr-title {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

            .setappr-title .icon-box {
                width: 44px;
                height: 44px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: rgba(255,255,255,.16);
                font-size: 18px;
            }

            .setappr-title h1 {
                margin: 0;
                font-size: 22px;
                line-height: 1.15;
                font-weight: 800;
                letter-spacing: 0;
            }

            .setappr-title p {
                margin: 4px 0 0;
                color: rgba(255,255,255,.82);
                font-size: 12px;
            }

        .setappr-chip-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 8px;
        }

        .setappr-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 11px;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
        }

        .setappr-panel {
            margin-top: 14px;
            border: 1px solid var(--setappr-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .setappr-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--setappr-border);
            background: #f8fafc;
        }

        .setappr-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

            .setappr-section-title i {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: #e9f2ff;
                color: var(--setappr-blue);
            }

            .setappr-section-title h2 {
                margin: 0;
                font-size: 16px;
                line-height: 1.2;
                font-weight: 800;
                letter-spacing: 0;
            }

        .setappr-panel-body {
            padding: 16px;
        }

        .setappr-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 16px;
        }

            .setappr-form-grid.two-col {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

        .setappr-field {
            min-width: 0;
        }

            .setappr-field.full {
                grid-column: 1 / -1;
            }

            .setappr-field label,
            .setappr-filter label {
                display: block;
                margin: 0 0 6px;
                color: #526179;
                font-size: 11px;
                font-weight: 900;
                text-transform: uppercase;
            }

            .setappr-page .form-control,
            .setappr-field .form-control {
                width: 100% !important;
                min-height: 38px;
                border: 1px solid #cfd9e6;
                border-radius: 7px;
                color: #172033;
                font-size: 13px;
                box-shadow: none;
            }

        .setappr-readonly {
            display: flex;
            align-items: center;
            width: 100%;
            min-height: 38px;
            margin: 0;
            padding: 8px 10px;
            border: 1px solid #d9e3ef;
            border-radius: 7px;
            background: #f8fafc;
            color: #172033;
            font-weight: 700 !important;
            word-break: break-word;
        }

        .setappr-editor-wrap {
            border: 1px solid #d9e3ef;
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
        }

            .setappr-editor-wrap .cke {
                width: 100% !important;
                border: 0 !important;
            }

        .setappr-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 14px;
        }

        .btn-setappr {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            padding: 8px 14px;
            border: 1px solid transparent;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 800;
            line-height: 1;
            cursor: pointer;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
        }

            .btn-setappr:hover {
                transform: translateY(-1px);
                text-decoration: none;
            }

        .btn-setappr-primary {
            background: var(--setappr-blue);
            color: #fff;
            box-shadow: 0 8px 18px rgba(29, 78, 216, .2);
        }

            .btn-setappr-primary:hover,
            .btn-setappr-primary:focus {
                color: #fff;
                background: #1e40af;
            }

        .btn-setappr-soft {
            border-color: #cbd5e1;
            background: #fff;
            color: #20304a;
        }

            .btn-setappr-soft:hover,
            .btn-setappr-soft:focus {
                color: #0f766e;
                border-color: #99f6e4;
                background: #ecfeff;
            }

        .setappr-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .setappr-table-shell {
            width: 100%;
            overflow: auto;
        }

        #setappr_gr_table {
            width: 100% !important;
            margin-bottom: 0 !important;
        }

            #setappr_gr_table thead th,
            .table.dataTable th {
                border-bottom: 1px solid var(--setappr-border) !important;
                background: #f8fafc !important;
                color: #1d3557 !important;
                font-size: 11px;
                font-weight: 900;
                text-transform: uppercase;
                white-space: nowrap;
            }

            #setappr_gr_table tbody td {
                vertical-align: middle;
                color: #172033;
                font-size: 12px;
                white-space: nowrap;
            }

            #setappr_gr_table tbody a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 34px;
                padding: 5px 9px;
                border-radius: 999px;
                background: #eef6ff;
                color: var(--setappr-blue);
                font-weight: 900;
                text-decoration: none;
            }

                #setappr_gr_table tbody a:hover {
                    background: #dbeafe;
                }

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #cfd9e6;
            border-radius: 7px;
            min-height: 34px;
            padding: 5px 9px;
        }

        .setappr-loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 20000;
            background: rgba(15, 23, 42, .28);
        }

        .setappr-loading-card {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 220px;
            min-height: 150px;
            padding: 22px;
            border: 1px solid rgba(203, 213, 225, .8);
            border-radius: 8px;
            background: rgba(255,255,255,.96);
            text-align: center;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .26);
            transform: translate(-50%, -50%);
        }

            .setappr-loading-card img {
                width: 70px;
                height: 70px;
                object-fit: contain;
            }

            .setappr-loading-card div {
                margin-top: 8px;
                color: #334155;
                font-size: 12px;
                font-weight: 900;
            }

        .setappr-modal.modal.fade .modal-dialog {
            transform: translate3d(0, 28px, 0) scale(.98);
            transition: transform .28s ease, opacity .28s ease;
        }

        .setappr-modal.modal.show .modal-dialog {
            transform: translate3d(0, 0, 0) scale(1);
        }

        .setappr-modal .modal-dialog {
            max-width: min(1120px, calc(100vw - 48px));
        }

        .setappr-modal .modal-content {
            border: 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 26px 80px rgba(15, 23, 42, .32);
        }

        .setappr-modal .modal-header {
            align-items: center;
            min-height: 64px;
            padding: 17px 22px;
            border-bottom: 0;
            color: #fff;
            background: linear-gradient(135deg, #193b72 0%, #0f766e 100%);
        }

        .setappr-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: #fff;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: 0;
        }

            .setappr-modal .modal-title i {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                background: rgba(255,255,255,.16);
            }

        .setappr-modal .close {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            margin: 0;
            padding: 0;
            border-radius: 50%;
            background: rgba(255,255,255,.14);
            color: #fff;
            text-shadow: none;
            opacity: 1;
        }

        .setappr-modal .modal-body {
            max-height: calc(100vh - 190px);
            overflow-y: auto;
            padding: 22px;
            background: var(--setappr-soft);
        }

        .setappr-modal .modal-footer {
            gap: 10px;
            padding: 15px 22px;
            border-top: 1px solid #e5e7eb;
            background: #fff;
        }

        .setappr-preview-document {
            max-width: 920px;
            min-height: 340px;
            margin: 0 auto;
            border: 1px solid #dce6f2;
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 22px 55px rgba(15, 23, 42, .12);
        }

        .setappr-slide-card {
            max-width: 1000px;
            min-height: 340px;
            margin: 0 auto;
            padding: 28px 32px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 16px 40px rgba(15, 23, 42, .08);
        }

        .setappr-preview-banner {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 24px 28px;
            color: #fff;
            background: linear-gradient(135deg, #173b70 0%, #1d4ed8 62%, #0f766e 100%);
        }

            .setappr-preview-banner::after {
                content: "";
                position: absolute;
                right: -45px;
                bottom: -72px;
                width: 190px;
                height: 190px;
                border: 28px solid rgba(255,255,255,.08);
                border-radius: 50%;
                pointer-events: none;
            }

        .setappr-preview-brand {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .setappr-preview-brand-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 46px;
            height: 46px;
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 12px;
            background: rgba(255,255,255,.14);
            color: #fff;
            font-size: 19px;
            box-shadow: inset 0 1px 0 rgba(255,255,255,.18);
        }

        .setappr-preview-eyebrow {
            display: block;
            margin-bottom: 3px;
            color: #bfdbfe;
            font-size: 10px;
            font-weight: 900;
            letter-spacing: 1.3px;
            text-transform: uppercase;
        }

        .setappr-preview-brand h3 {
            margin: 0;
            color: #fff;
            font-size: 21px;
            font-weight: 800;
            line-height: 1.25;
        }

        .setappr-preview-date {
            position: relative;
            z-index: 1;
            min-width: 132px;
            padding: 9px 13px;
            border: 1px solid rgba(255,255,255,.22);
            border-radius: 10px;
            background: rgba(15, 23, 42, .2);
            color: #dbeafe;
            font-size: 11px;
            font-weight: 800;
            text-align: left;
            white-space: nowrap;
        }

            .setappr-preview-date label {
                display: block;
                margin: 2px 0 0;
                color: #fff;
                font-size: 13px;
            }

        .setappr-preview-body {
            padding: 28px;
            background: linear-gradient(180deg, #ffffff 0%, #fbfdff 100%);
        }

        .setappr-preview-meta {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .setappr-preview-meta-item {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
            padding: 14px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
        }

            .setappr-preview-meta-item i {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                flex: 0 0 34px;
                width: 34px;
                height: 34px;
                border-radius: 9px;
                background: #e8f1ff;
                color: #1d4ed8;
            }

            .setappr-preview-meta-item span {
                display: block;
                margin-bottom: 2px;
                color: #64748b;
                font-size: 10px;
                font-weight: 900;
                letter-spacing: .55px;
                text-transform: uppercase;
            }

            .setappr-preview-meta-item label {
                display: block;
                margin: 0;
                color: #172033;
                font-size: 13px;
                font-weight: 800;
                line-height: 1.4;
                word-break: break-word;
            }

        .setappr-slide-meta {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding-bottom: 18px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            font-size: 13px;
            line-height: 1.7;
        }

        .setappr-slide-date {
            min-width: 170px;
            text-align: right;
            white-space: nowrap;
        }

        .setappr-preview-subject {
            margin: 20px 0 18px;
            padding: 15px 18px;
            border: 1px solid #d8e5f4;
            border-left: 4px solid #1d4ed8;
            border-radius: 10px;
            background: #f4f8ff;
            text-align: left;
        }

            .setappr-preview-subject span {
                display: block;
                margin-bottom: 4px;
                color: #64748b;
                font-size: 10px;
                font-weight: 900;
                letter-spacing: .7px;
                text-transform: uppercase;
            }

        .setappr-slide-subject {
            margin: 24px 0 18px;
            padding: 16px 20px;
            border-top: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            text-align: center;
        }

            .setappr-preview-subject h5 {
                margin: 0;
                color: #173b70;
                font-size: 16px;
                font-weight: 800;
                line-height: 1.45;
            }

            .setappr-slide-subject h5 {
                margin: 0;
                color: #193b72;
                font-size: 15px;
                font-weight: 800;
                line-height: 1.4;
            }

        .setappr-preview-content {
            min-height: 180px;
            padding: 20px 22px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #fff;
            color: #1f2937;
            font-size: 14px;
            font-weight: 500;
            line-height: 1.8;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .04);
        }

        .setappr-slide-content {
            color: #1f2937;
            font-size: 14px;
            font-weight: 500;
            line-height: 1.75;
        }

            .setappr-preview-content label,
            .setappr-slide-content label {
                display: block;
                margin: 0;
                max-width: 100%;
            }

        .setappr-swal-popup {
            border-radius: 16px !important;
            box-shadow: 0 28px 80px rgba(15, 23, 42, .24) !important;
        }

        .setappr-swal-confirm {
            min-width: 104px;
            border-radius: 8px !important;
            font-weight: 800 !important;
        }

        #setappr_viewdetails .carousel {
            padding: 0 50px 34px;
        }

        #setappr_viewdetails .carousel-inner {
            overflow: hidden;
            border-radius: 8px;
        }

        #setappr_viewdetails .carousel-item {
            transition: transform .55s ease-in-out, opacity .35s ease;
        }

            #setappr_viewdetails .carousel-item.active .setappr-slide-card {
                animation: setapprSlideIn .38s ease both;
            }

        #setappr_viewdetails .carousel-control-prev,
        #setappr_viewdetails .carousel-control-next {
            top: 50%;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #193b72;
            opacity: 1;
            transform: translateY(-50%);
        }

        #setappr_viewdetails .carousel-control-prev {
            left: 4px;
        }

        #setappr_viewdetails .carousel-control-next {
            right: 4px;
        }

            #setappr_viewdetails .carousel-control-prev:hover,
            #setappr_viewdetails .carousel-control-next:hover {
                background: var(--setappr-teal);
            }

        #setappr_viewdetails .carousel-indicators {
            bottom: -4px;
            margin-bottom: 0;
        }

            #setappr_viewdetails .carousel-indicators li {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #94a3b8;
                opacity: .6;
            }

            #setappr_viewdetails .carousel-indicators .active {
                background: var(--setappr-blue);
                opacity: 1;
            }

        .setappr-empty-state {
            max-width: 520px;
            margin: 0 auto;
            padding: 34px 20px;
            border: 1px dashed #cbd5e1;
            border-radius: 8px;
            background: #fff;
            color: var(--setappr-muted);
            text-align: center;
            font-weight: 800;
        }

        .setappr-waiting .modal-content {
            border: 0;
            border-radius: 8px;
            background: transparent;
            box-shadow: none;
        }

        .setappr-waiting-card {
            margin: 0 auto;
            padding: 26px 30px;
            border-radius: 8px;
            background: rgba(15, 23, 42, .88);
            color: #fff;
            text-align: center;
            box-shadow: 0 24px 70px rgba(15, 23, 42, .34);
        }

            .setappr-waiting-card img {
                width: 76px;
                height: 76px;
                object-fit: contain;
            }

            .setappr-waiting-card span {
                display: block;
                margin-top: 10px;
                font-size: 17px;
                font-weight: 800;
            }

        .setappr-dots {
            display: inline-block;
            margin-left: 4px;
            animation: setapprPulse 1s linear infinite;
        }

        @keyframes setapprSlideIn {
            from {
                opacity: .55;
                transform: translateY(12px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes setapprPulse {
            0%, 100% {
                opacity: .35;
            }

            50% {
                opacity: 1;
            }
        }

        @media (max-width: 991.98px) {
            .setappr-form-grid,
            .setappr-form-grid.two-col,
            .setappr-filter-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767.98px) {
            .setappr-hero,
            .setappr-panel-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .setappr-chip-row,
            .setappr-actions {
                justify-content: flex-start;
            }

            .setappr-form-grid,
            .setappr-form-grid.two-col,
            .setappr-filter-grid {
                grid-template-columns: 1fr;
            }

            .setappr-modal .modal-dialog {
                max-width: calc(100vw - 18px);
                margin: .75rem auto;
            }

            .setappr-modal .modal-body {
                max-height: calc(100vh - 150px);
                padding: 14px;
            }

            .setappr-preview-document {
                min-height: 0;
                border-radius: 12px;
            }

            .setappr-slide-card {
                min-height: 0;
                padding: 20px 16px;
            }

            .setappr-preview-banner {
                align-items: flex-start;
                padding: 20px;
            }

            .setappr-preview-brand h3 {
                font-size: 17px;
            }

            .setappr-preview-date {
                min-width: 110px;
            }

            .setappr-preview-body {
                padding: 18px;
            }

            .setappr-preview-meta {
                grid-template-columns: 1fr;
            }

            .setappr-slide-meta {
                display: block;
            }

            .setappr-slide-date {
                margin-top: 10px;
                text-align: left;
            }

            #setappr_viewdetails .carousel {
                padding: 0 0 34px;
            }

            #setappr_viewdetails .carousel-control-prev,
            #setappr_viewdetails .carousel-control-next {
                top: auto;
                bottom: -2px;
                transform: none;
            }
        }
    </style>
    <style>
        .setappr-profile-card {
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            border: 1px solid #e4ecf7;
            border-radius: 18px;
            padding: 22px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, .08);
        }

        .setappr-form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .setappr-field label {
            display: block;
            font-size: 13px;
            font-weight: 800;
            color: #334155;
            margin-bottom: 7px;
        }

            .setappr-field label i {
                color: #2563eb;
                margin-right: 6px;
            }

        .setappr-field .form-control {
            height: 42px;
            border-radius: 12px;
            border: 1px solid #dbe7f3;
            font-size: 13px;
            font-weight: 600;
            color: #1e293b;
            background: #fff;
            box-shadow: 0 4px 12px rgba(15, 23, 42, .04);
        }

            .setappr-field .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
            }

        .setappr-readonly {
            background: linear-gradient(135deg, #f8fafc, #eef6ff) !important;
            cursor: default;
        }

        .setappr-employee-field select {
            background: #fff;
        }

        @media (max-width: 992px) {
            .setappr-form-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 576px) {
            .setappr-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            try {
                if (window.CKEDITOR && !CKEDITOR.instances['setappr_description']) {
                    CKEDITOR.replace('setappr_description');
                }
            } catch (e) {
                if (window.console) {
                    console.warn(e);
                }
            }
            setappr_BindUsers();
            setappr_bindgrid();
        });
    </script>
    <script src="../ckeditor/ckeditor.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <label id="lbl_loginEmpID" runat="server"   ClientIDMode="Static" hidden></label>
    <asp:HiddenField ID="hdnLoginEmpID" runat="server" />

    <div class="setappr-loading" id="load1" aria-hidden="true">
        <div class="setappr-loading-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please...</div>
        </div>
    </div>

    <div class="setappr-page">
        <div class="setappr-shell">
            <header class="setappr-hero">
                <div class="setappr-title">
                    <span class="icon-box"><i class="fas fa-award"></i></span>
                    <div>
                        <h1>Set Appreciation and Disciplinary Action</h1>
                        <p>Employee recognition, warnings, and PIP communication</p>
                    </div>
                </div>
                <div class="setappr-chip-row">
                    <span class="setappr-chip"><i class="fas fa-envelope"></i>Notification</span>
                    <span class="setappr-chip"><i class="fas fa-history"></i>Action History</span>
                </div>
            </header>

            <section class="setappr-panel">
                <div class="setappr-panel-head">
                    <div class="setappr-section-title">
                        <i class="fas fa-user-check"></i>
                        <h2>Employee Details</h2>
                    </div>
                </div>
                <div class="setappr-panel-body">
                    <label id="setappr_apprid" style="display: none;"></label>
                    <div class="setappr-profile-card">
                        <div class="setappr-form-grid">

                            <div class="setappr-field setappr-employee-field">
                                <label><i class="fas fa-user-check"></i>Employee</label>
                                <select id="setappr_employee" name="setappr_employee" class="form-control" onchange="setappr_getEmpInfo(this);">
                                </select>
                            </div>
                            <div class="setappr-field">
                                <label><i class="fas fa-calendar-check"></i>Joining Date</label>
                                <input type="text" id="setappr_joiningdate" class="form-control setappr-readonly" readonly />
                            </div>

                            <div class="setappr-field">
                                <label><i class="fas fa-building"></i>Department</label>
                                <input type="text" id="setappr_department" class="form-control setappr-readonly" readonly />
                            </div>

                            <div class="setappr-field">
                                <label><i class="fas fa-briefcase"></i>Designation</label>
                                <input type="text" id="setappr_designation" class="form-control setappr-readonly" readonly />
                            </div>

                            <div class="setappr-field">
                                <label><i class="fas fa-user-tie"></i>Reporting Manager</label>
                                <input type="text" id="setappr_repotingmanager" class="form-control setappr-readonly" readonly />
                            </div>

                        </div>
                    </div>
                </div>
            </section>

            <section class="setappr-panel">
                <div class="setappr-panel-head">
                    <div class="setappr-section-title">
                        <i class="fas fa-file-signature"></i>
                        <h2>Action Letter</h2>
                    </div>
                </div>
                <div class="setappr-panel-body">
                    <div class="setappr-form-grid two-col">
                        <div class="setappr-field">
                            <label for="setappr_type">Type</label>
                            <select id="setappr_type" name="setappr_type" class="form-control" onchange="setappr_getApprTitle(this);">
                                <option value="">Select</option>
                                <option value="Appreciation">Appreciation</option>
                                <option value="DisciplinaryAction">Disciplinary Action</option>
                                <option value="PerformanceImprovementPlan">Performance Improvement Plan</option>
                            </select>
                        </div>
                        <div class="setappr-field">
                            <label for="setappr_title">Title</label>
                            <select id="setappr_title" name="setappr_title" class="form-control" onchange="setappr_getApprDesc(this);"> <option value="">Select</option></select>
                        </div>
                    </div>

                    <div class="setappr-form-grid two-col" id="setappr_trother" style="display: none; margin-top: 14px;">
                        <div class="setappr-field" id="setappr_tdperiodrow">
                            <label id="setappr_tdperiodheader" for="setappr_period">Period</label>
                            <select id="setappr_period" name="setappr_period" class="form-control"></select>
                        </div>
                        <div class="setappr-field" id="setappr_tdeffectivedaterow">
                            <label id="setappr_tdeffectivedateheader" for="setappr_effectivedate">Effective Date</label>
                            <input type="date" id="setappr_effectivedate" name="setappr_effectivedate" class="form-control" />
                        </div>
                    </div>

                    <div class="setappr-field full" style="margin-top: 14px;">
                        <label for="setappr_description">Description</label>
                        <div class="setappr-editor-wrap">
                            <textarea id="setappr_description" name="setappr_description"></textarea>
                        </div>
                    </div>

                    <div class="setappr-actions">
                        <button type="button" id="setappr_btnpreview" name="setappr_btnpreview" class="btn-setappr btn-setappr-soft" onclick="return setappr_preview();">
                            <i class="fas fa-eye"></i>Preview
                       
                        </button>
                        <button type="button" id="setappr_btnsubmit" name="setappr_btnsubmit" class="btn-setappr btn-setappr-primary" onclick="return setappr_submit();">
                            <i class="fas fa-paper-plane"></i>Submit
                       
                        </button>
                    </div>
                </div>
            </section>

            <section class="setappr-panel">
                <div class="setappr-panel-head">
                    <div class="setappr-section-title">
                        <i class="fas fa-table"></i>
                        <h2>Appreciation and Disciplinary Action Details</h2>
                    </div>
                </div>
                <div class="setappr-panel-body">
                    <div class="setappr-filter-grid">
                        <div class="setappr-filter">
                            <label for="filterYear">Year</label>
                            <select id="filterYear" class="form-control">
                                <option value="">All Years</option>
                            </select>
                        </div>
                        <div class="setappr-filter">
                            <label for="filterMonth">Month</label>
                            <select id="filterMonth" class="form-control">
                                <option value="">All Months</option>
                            </select>
                        </div>
                        <div class="setappr-filter">
                            <label for="filterLocation">Location</label>
                            <select id="filterLocation" class="form-control">
                                <option value="">All Locations</option>
                            </select>
                        </div>
                        <div class="setappr-filter">
                            <label for="filterDepartment">Department</label>
                            <select id="filterDepartment" class="form-control">
                                <option value="">All Departments</option>
                            </select>
                        </div>
                    </div>

                    <div class="setappr-table-shell">
                        <table class="table table-striped table-hover" id="setappr_gr_table">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3">Code</th>
                                    <th class="sort border-top ps-3">Name</th>
                                    <th class="sort border-top ps-3">Joining Date</th>
                                    <th class="sort border-top ps-3">Branch</th>
                                    <th class="sort border-top ps-3">Department</th>
                                    <th class="sort border-top ps-3">Designation</th>
                                    <th class="sort border-top ps-3">Reporting Manager</th>
                                    <th class="sort border-top ps-3">Action Month</th>
                                    <th class="sort border-top ps-3">Action Year</th>
                                    <th class="sort border-top ps-3 text-center">Appreciation</th>
                                    <th class="sort border-top ps-3 text-center">Warnings</th>
                                    <th class="sort border-top ps-3 text-center">PIP</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <div class="modal fade setappr-modal" id="setappr_previewpop" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title"><i class="fas fa-file-alt"></i>Letter Preview</div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="setappr-preview-document">
                        <div class="setappr-preview-banner">
                            <div class="setappr-preview-brand">
                                <span class="setappr-preview-brand-icon"><i class="fas fa-envelope-open-text"></i></span>
                                <div>
                                    <span class="setappr-preview-eyebrow">Infinity IPS / HRMS</span>
                                    <h3>Employee Action Letter</h3>
                                </div>
                            </div>
                            <div class="setappr-preview-date">
                                <span>Date</span>
                                <label id="setappr_popdate"></label>
                            </div>
                        </div>
                        <div class="setappr-preview-body">
                            <div class="setappr-preview-meta">
                                <div style="display: none;">
                                    <label id="setappr_popcode"></label>
                                </div>
                                <div class="setappr-preview-meta-item">
                                    <i class="fas fa-user"></i>
                                    <div>
                                        <span>Employee Name</span>
                                        <label id="setappr_popname"></label>
                                    </div>
                                </div>
                                <div style="display: none;">
                                    <label id="setappr_poplocation"></label>
                                </div>
                                <div class="setappr-preview-meta-item">
                                    <i class="fas fa-calendar-check"></i>
                                    <div>
                                        <span>Joining Date</span>
                                        <label id="setappr_popdoj"></label>
                                    </div>
                                </div>
                            </div>
                            <div class="setappr-preview-subject">
                                <span>Subject</span>
                                <h5 id="setappr_popsubject"></h5>
                            </div>
                            <div class="setappr-preview-content">
                                <label id="setappr_popdesc"></label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-end">
                    <button type="button" class="btn-setappr btn-setappr-soft" data-dismiss="modal"><i class="fas fa-times"></i>Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade setappr-waiting" id="waitingpanel" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered text-center" role="document">
            <div class="modal-content">
                <div class="setappr-waiting-card">
                    <img src="../Images/Load.gif" alt="Loading" />
                    <span id="spntext">System is updating details. Please wait<span class="setappr-dots">...</span></span>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade setappr-modal" id="setappr_dverror" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title"><i class="fas fa-info-circle"></i><span id="setappr_errmsg"></span></h6>
                </div>
                <div class="modal-footer justify-content-end">
                    <button class="btn-setappr btn-setappr-primary" type="button" id="setappr_btnMessage">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade setappr-modal" id="setappr_viewdetails" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title setappr-detail-header" id="setappr_detailsheader"><i class="fas fa-copy"></i>Action Details</div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="dvslidermain"></div>
                </div>
                <div class="modal-footer justify-content-between">
                    <a id="setappr_openmodify" class="btn-setappr btn-setappr-primary" href="#" style="display: none;"><i class="fas fa-external-link-alt"></i>Open Modification Page</a>
                    <button type="button" class="btn-setappr btn-setappr-soft" data-dismiss="modal"><i class="fas fa-times"></i>Close</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        .modal-header {
            /*background: linear-gradient(120deg, #2563eb 0%, #1d9de6 65%, #22c1dc 100%) !important;*/
            width: 100%;
        }

        .setappr-slider-shell {
            /* background: linear-gradient(180deg, #f8fbff 0%, #ffffff 100%);*/
            border: 1px solid #e3edf8;
            border-radius: 20px;
            padding: 15px;
        }

        .setappr-slider-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            carousel-control-prev margin-bottom: 18px;
        }

        .setappr-slider-kicker {
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #2563eb;
        }

        .setappr-slider-top h5 {
            margin: 4px 0 0;
            font-size: 20px;
            font-weight: 800;
            color: #0f172a;
        }

        .setappr-slider-count {
            padding: 7px 16px;
            border-radius: 30px;
            color: #fff;
            font-size: 12px;
            font-weight: 800;
            background: linear-gradient(120deg, #2563eb, #22c1dc);
        }

        .setappr-carousel {
            padding: 0 52px 45px;
        }

        .setappr-slide-card {
            overflow: hidden;
            border-radius: 22px;
            background: #fff;
            border: 1px solid #e4ecf7;
            box-shadow: 0 15px 35px rgba(15, 23, 42, .10);
        }

        .setappr-slide-hero {
            position: relative;
            text-align: center;
            padding: 34px 22px 28px;
            color: #fff;
            /*    background: linear-gradient(120deg, #2563eb 0%, #1d9de6 65%, #22c1dc 100%);*/
        }

            .setappr-slide-hero::before {
                content: "";
                position: absolute;
                top: -70px;
                left: -70px;
                width: 190px;
                height: 190px;
                border-radius: 50%;
                background: rgba(255,255,255,.12);
            }

        .setappr-slide-badge {
            position: absolute;
            top: 16px;
            right: 18px;
            padding: 6px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
            background: rgba(255,255,255,.20);
        }

        .setappr-slide-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 14px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.14);
        }

            .setappr-slide-icon i {
                font-size: 31px;
                color: #fff;
            }

        .setappr-slide-hero h4 {
            margin: 0;
            font-weight: 800;
            font-size: 24px;
        }

        .setappr-slide-hero p {
            margin: 8px 0 0;
            opacity: .92;
            font-size: 14px;
        }

        .setappr-slide-body {
            padding: 22px;
        }

        .setappr-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .setappr-info-box {
            background: #f8fafc;
            border: 1px solid #e5edf6;
            border-radius: 14px;
            padding: 14px;
        }

            .setappr-info-box label,
            .setappr-remark-box label {
                display: block;
                font-size: 12px;
                font-weight: 800;
                color: #64748b;
                margin-bottom: 6px;
            }

                .setappr-info-box label i,
                .setappr-remark-box label i {
                    color: #2563eb;
                    margin-right: 6px;
                }

            .setappr-info-box span {
                font-size: 14px;
                font-weight: 700;
                color: #1e293b;
            }

        .setappr-remark-box {
            margin-top: 15px;
            background: #fff7ed;
            border: 1px solid #fed7aa;
            border-radius: 14px;
            padding: 15px;
        }

            .setappr-remark-box p {
                margin: 0;
                font-size: 14px;
                font-weight: 600;
                color: #7c2d12;
                line-height: 1.6;
            }

        .setappr-carousel-control {
            width: 35px;
            height: 35px;
            top: 50%;
            transform: translateY(-50%);
            border-radius: 50%;
            opacity: 1;
            /*  background: linear-gradient(120deg, #2563eb, #22c1dc);*/
            box-shadow: 0 8px 18px rgba(37,99,235,.25);
        }

            .setappr-carousel-control i {
                color: #fff;
                font-size: 16px;
            }

        .carousel-control-prev.setappr-carousel-control {
            left: 0;
        }

        .carousel-control-next.setappr-carousel-control {
            right: 0;
        }

        .setappr-indicators {
            bottom: 0;
        }

            .setappr-indicators li {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background: #94a3b8;
            }

                .setappr-indicators li.active {
                    width: 26px;
                    border-radius: 20px;
                    background: #2563eb;
                }

        .setappr-empty-state {
            text-align: center;
            padding: 45px 20px;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            color: #64748b;
        }

            .setappr-empty-state i {
                font-size: 42px;
                color: #94a3b8;
                margin-bottom: 12px;
            }

            .setappr-empty-state h5 {
                margin: 0;
                font-weight: 800;
                color: #334155;
            }

            .setappr-empty-state p {
                margin: 8px 0 0;
                font-size: 13px;
            }

        @media (max-width: 768px) {
            .setappr-carousel {
                padding: 0 0 45px;
            }

            .setappr-carousel-control {
                display: none;
            }

            .setappr-info-grid {
                grid-template-columns: 1fr;
            }

            .setappr-slider-top {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }

        #setappr_viewdetails .modal-dialog {
            max-width: min(1040px, calc(100vw - 34px));
        }

        #setappr_viewdetails .modal-body {
            padding: 18px;
            background: #edf3f9;
        }

        #setappr_viewdetails .modal-header {
            align-items: center;
            min-height: 82px;
            padding: 12px 18px;
            border-bottom: 1px solid #dbe7f3;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
            box-shadow: var(--chr-shadow);
        }

        #setappr_viewdetails .close {
            min-width: 34px;
            background: #edf3f9;
            color: #193b72;
        }

        #setappr_viewdetails .setappr-detail-header {
            flex: 1;
            min-width: 0;
        }

            #setappr_viewdetails .setappr-detail-header i {
                display: inline-flex;
                width: auto;
                height: auto;
                min-width: 0;
                border-radius: 0;
                background: transparent;
            }

        .setappr-header-summary {
            display: flex;
            align-items: center;
            gap: 13px;
            /* min-width: 0;*/
            width: 100%;
        }

        .setappr-header-main {
            width: 100%;
            color: #fff !important;
        }

            .setappr-header-main span {
                display: block;
                margin-bottom: 3px;
                color: #fff !important;
                font-size: 11px;
                font-weight: 900;
                letter-spacing: 0;
                text-transform: uppercase;
            }

            .setappr-header-main strong {
                display: block;
                max-width: 100%;
                color: #fff !important;
                font-size: 17px;
                line-height: 1.25;
                font-weight: 900;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .setappr-header-main em {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                margin-top: 4px;
                color: white;
                font-size: 12px;
                font-style: normal;
                font-weight: 800;
            }

                .setappr-header-main em i {
                    color: #fff !important;
                }

        .setappr-slider-shell {
            padding: 16px;
            border: 1px solid #dbe7f3;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, .10);
        }

        .setappr-slider-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin: 0 0 14px;
            padding: 12px 14px;
            border: 1px solid #e1eaf5;
            border-radius: 8px;
            background: #f8fbff;
        }

        .setappr-slider-kicker {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #193b72;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: 0;
            text-transform: uppercase;
        }

            .setappr-slider-kicker i {
                color: #0f766e;
            }

        .setappr-slider-count {
            display: inline-flex;
            align-items: center;
            min-height: 30px;
            padding: 6px 12px;
            border: 1px solid #bfd5f4;
            border-radius: 8px;
            background: #eaf3ff;
            color: #193b72;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .setappr-carousel {
            padding: 0 48px 38px;
        }

            .setappr-carousel .carousel-inner {
                border-radius: 8px;
            }

        .setappr-slide-card {
            display: block;
            max-width: none;
            min-height: 0;
            margin: 0;
            padding: 0;
            overflow: hidden;
            border: 1px solid #dce8f4;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 14px 34px rgba(15, 23, 42, .10);
        }

        .setappr-detail-header .setappr-slide-rail {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            width: 100%;
            padding: 8px 10px;
            border-radius: 8px;
            color: #fff;
            /*  background: #193b72;*/
        }

        .setappr-slide-appreciation .setappr-slide-rail {
            /* background: linear-gradient(150deg, #0f766e 0%, #14532d 100%);*/
        }

        .setappr-slide-disciplinary .setappr-slide-rail {
            /* background: linear-gradient(150deg, #193b72 0%, #b45309 100%);*/
        }

        .setappr-slide-pip .setappr-slide-rail {
            /*background: linear-gradient(150deg, #1d4ed8 0%, #0f766e 100%);*/
        }

        .setappr-slide-sequence {
            flex: 0 0 auto;
            padding: 8px 12px;
            border: 1px solid rgba(255,255,255,.34);
            border-radius: 7px;
            background: rgba(255,255,255,.14);
            font-size: 25px;
            font-weight: 900;
            margin-right: 20px;
        }

        .setappr-slide-type {
            min-width: 0;
            margin-top: 0;
            font-size: 12px;
            line-height: 1.25;
            font-weight: 900;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .setappr-slide-line {
            flex: 0 0 auto;
            width: 3px;
            height: 18px;
            border-radius: 999px;
            background: rgba(255,255,255,.72);
        }

        .setappr-slide-hero {
            position: static;
            display: flex;
            align-items: center;
            gap: 14px;
            min-height: auto;
            padding: 22px 24px 18px;
            border-bottom: 1px solid #e6eef7;
            color: #102033;
            text-align: left;
            color: #fff;
        }

            .setappr-slide-hero::before {
                display: none;
            }

        .setappr-slide-icon {
            width: 40px;
            height: 40px;
            min-width: 40px;
            margin: 0;
            border: 1px solid #bfd5f4;
            border-radius: 8px;
            background: #eaf3ff;
        }

            .setappr-slide-icon i {
                color: #193b72;
                font-size: 22px;
            }

        .setappr-slide-heading {
            min-width: 0;
        }

            .setappr-slide-heading span {
                display: block;
                margin-bottom: 4px;
                color: #64748b;
                font-size: 11px;
                font-weight: 900;
                letter-spacing: 0;
                text-transform: uppercase;
            }

        .setappr-slide-hero h5 {
            margin: 0;
            color: black !important;
            font-size: 20px;
            line-height: 1.28;
            font-weight: 900;
            word-break: break-word;
        }

        .setappr-slide-hero p {
            margin: 0;
        }

        .setappr-slide-body {
            padding: 0 24px 24px;
        }

        .setappr-info-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .setappr-info-box {
            min-width: 0;
            padding: 13px 14px;
            border: 1px solid #dbe7f3;
            border-radius: 8px;
            background: #f8fbff;
        }

            .setappr-info-box label,
            .setappr-remark-box label {
                display: flex;
                align-items: center;
                gap: 7px;
                margin: 0 0 7px;
                color: #64748b;
                font-size: 11px;
                font-weight: 900;
                letter-spacing: 0;
                text-transform: uppercase;
            }

                .setappr-info-box label i,
                .setappr-remark-box label i {
                    margin: 0;
                    color: #0f766e;
                }

            .setappr-info-box span {
                display: block;
                color: #172033;
                font-size: 13px;
                line-height: 1.45;
                font-weight: 800;
                word-break: break-word;
            }

        .setappr-remark-box {
            margin-top: 0;
            padding: 15px;
            border: 1px solid #f2c894;
            border-radius: 8px;
            background: #fff8ef;
        }

        .setappr-remark-text {
            max-height: min(36vh, 330px);
            overflow: auto;
            color: #6d320d;
            font-size: 13px;
            line-height: 1.65;
            font-weight: 650;
            word-break: break-word;
        }

            .setappr-remark-text p,
            .setappr-remark-text ul,
            .setappr-remark-text ol {
                margin-top: 0;
                margin-bottom: 8px;
            }

            .setappr-remark-text :last-child {
                margin-bottom: 0;
            }

        .setappr-carousel-control {
            width: 38px;
            height: 38px;
            top: 50%;
            border: 0;
            border-radius: 8px;
            background: #193b72;
            opacity: 1;
            transform: translateY(-50%);
            box-shadow: 0 10px 22px rgba(25, 59, 114, .22);
        }

            .setappr-carousel-control:hover,
            .setappr-carousel-control:focus {
                background: #0f766e;
            }

            .setappr-carousel-control i {
                color: #fff;
                font-size: 14px;
            }

        .carousel-control-prev.setappr-carousel-control {
            left: 0;
        }

        .carousel-control-next.setappr-carousel-control {
            right: 0;
        }

        .setappr-indicators {
            bottom: 0;
            margin-bottom: 0;
        }

            .setappr-indicators li {
                width: 8px;
                height: 8px;
                border-radius: 999px;
                background: #94a3b8;
                opacity: .8;
            }

                .setappr-indicators li.active {
                    width: 24px;
                    background: #193b72;
                }

        @media (max-width: 768px) {
            #setappr_viewdetails .modal-dialog {
                max-width: calc(100vw - 14px);
                margin: 7px auto;
            }

            #setappr_viewdetails .modal-body {
                padding: 10px;
            }

            #setappr_viewdetails .modal-header {
                align-items: flex-start;
                padding: 10px 12px;
            }

            .setappr-header-summary {
                align-items: flex-start;
                flex-direction: column;
                gap: 8px;
            }

            .setappr-detail-header .setappr-slide-rail {
                width: 100%;
                justify-content: space-between;
            }

            .setappr-header-main strong {
                font-size: 20px;
                overflow: visible;
                text-overflow: clip;
                white-space: normal;
                color: #fff !important;
            }

            .setappr-slider-shell {
                padding: 10px;
            }

            .setappr-slider-top {
                align-items: flex-start;
                flex-direction: column;
            }

            .setappr-carousel {
                padding: 0 0 36px;
            }

            .setappr-slide-card {
                min-height: 0;
            }

            .setappr-slide-type {
                max-width: none;
                font-size: 12px;
                text-align: left;
                white-space: normal;
            }

            .setappr-slide-line {
                display: none;
            }

            .setappr-slide-hero,
            .setappr-slide-body {
                padding: 16px;
            }

            .setappr-slide-hero {
                align-items: flex-start;
            }

                .setappr-slide-hero h4 {
                    font-size: 17px;
                }

            .setappr-info-grid {
                grid-template-columns: 1fr;
            }

            .setappr-carousel-control {
                display: none;
            }

            .setappr-remark-text {
                max-height: none;
            }
        }
    </style>

</asp:Content>
