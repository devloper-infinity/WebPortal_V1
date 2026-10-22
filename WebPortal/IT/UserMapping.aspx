<%@ Page Title="User Mapping Management" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="UserMapping.aspx.cs" Inherits="WebPortal.IT.UserMapping" %>

<asp:Content ID="UserMappingHead" ContentPlaceHolderID="head" runat="server">
    <style>
        .um-page {
            padding: 8px 0 28px;
            color: #172b4d
        }

        .um-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 20px 24px;
            margin-bottom: 18px;
            border-radius: 16px;
            color: #fff;
            background: linear-gradient(120deg,#174ea6,#167d9a);
            box-shadow: 0 10px 26px rgba(26,66,116,.14)
        }

            .um-hero h1 {
                font-size: 22px;
                font-weight: 700;
                margin: 0
            }

        .um-context {
            margin: 6px 0 0;
            opacity: .92
        }

        .um-back-link {
            display: inline-flex;
            flex: 0 0 auto;
            align-items: center;
            gap: 10px;
            padding: 8px 15px 8px 9px;
            border: 1px solid rgba(255,255,255,.42);
            border-radius: 11px;
            color: #fff !important;
            background: rgba(255,255,255,.13);
            box-shadow: 0 5px 16px rgba(8,42,91,.12);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none !important;
            transition: color .18s ease, background .18s ease, border-color .18s ease, transform .18s ease, box-shadow .18s ease;
            backdrop-filter: blur(8px)
        }

            .um-back-link i {
                display: grid;
                width: 30px;
                height: 30px;
                place-items: center;
                border-radius: 8px;
                background: rgba(255,255,255,.2);
                font-size: 13px;
                transition: background .18s ease, transform .18s ease
            }

            .um-back-link:hover {
                transform: translateY(-1px);
                border-color: rgba(255,255,255,.8);
                color: #1556a0 !important;
                background: #fff;
                box-shadow: 0 8px 20px rgba(8,42,91,.2)
            }

                .um-back-link:hover i {
                    transform: translateX(-2px);
                    color: #fff;
                    background: #2868b8
                }

            .um-back-link:focus-visible {
                outline: 3px solid rgba(255,255,255,.85);
                outline-offset: 3px
            }

        .um-invoice-summary {
            display: grid;
            grid-template-columns: minmax(190px, .7fr) minmax(0, 2fr);
            align-items: stretch;
            gap: 20px;
            padding: 18px;
            margin-bottom: 20px;
            border: 1px solid #dce8f5;
            border-radius: 16px;
            background: linear-gradient(135deg,#fff 0%,#f7fbff 100%);
            box-shadow: 0 8px 24px rgba(31,71,116,.08)
        }

        .um-summary-heading {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 14px 8px 8px;
            border-right: 1px solid #e1eaf4
        }

        .um-summary-icon {
            display: grid;
            flex: 0 0 42px;
            width: 42px;
            height: 42px;
            place-items: center;
            border-radius: 12px;
            color: #fff;
            background: linear-gradient(135deg,#2768c9,#168ca0);
            box-shadow: 0 5px 12px rgba(39,104,201,.2)
        }

            .um-summary-icon i {
                font-size: 17px
            }

        .um-summary-heading h2 {
            margin: 0;
            color: #183b66;
            font-size: 15px;
            font-weight: 750
        }

        .um-summary-heading p {
            margin: 4px 0 0;
            color: #73839a;
            font-size: 11px
        }

        .um-record-context {
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 12px
        }

            .um-record-context > div {
                min-width: 0;
                padding: 12px 14px;
                border: 1px solid #e4edf6;
                border-radius: 12px;
                background: rgba(255,255,255,.88);
                transition: border-color .18s ease, transform .18s ease, box-shadow .18s ease
            }

                .um-record-context > div:hover {
                    transform: translateY(-2px);
                    border-color: #bfd4ee;
                    box-shadow: 0 6px 14px rgba(31,71,116,.08)
                }

            .um-record-context span {
                display: block;
                margin-bottom: 6px;
                color: #70819a;
                font-size: 10px;
                font-weight: 700;
                letter-spacing: .07em;
                text-transform: uppercase
            }

                .um-record-context span i {
                    margin-right: 5px;
                    color: #4380c8
                }

            .um-record-context strong {
                display: block;
                overflow-wrap: anywhere;
                color: #1d3555;
                font-size: 14px;
                font-weight: 650;
                line-height: 1.4
            }

        .um-card {
            background: #fff;
            border: 1px solid #e1e9f2;
            border-radius: 14px;
            box-shadow: 0 8px 22px rgba(25,55,90,.06);
            padding: 18px;
            margin-bottom: 16px
        }

            .um-card h2 {
                font-size: 16px;
                font-weight: 700;
                margin: 0 0 16px
            }

        .um-grid {
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 14px
        }

            .um-grid.two {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }

        .um-field {
            min-width: 0
        }

            .um-field.full {
                grid-column: 1/-1
            }

            .um-field label {
                display: block;
                font-weight: 600;
                font-size: 12px;
                margin: 0 0 6px;
                color: #334155
            }

            .um-field .form-control {
                min-height: 38px;
                border-radius: 8px
            }

        .um-required {
            color: #b91c1c
        }

        .um-actions {
            display: flex;
            align-items: center;
            gap: 9px;
            flex-wrap: wrap
        }

        .um-tabs {
            border-bottom: 1px solid #d9e4f0;
            margin-bottom: 16px
        }

            .um-tabs .nav-link {
                font-weight: 700;
                color: #52627a
            }

                .um-tabs .nav-link.active {
                    color: #185abc;
                    border-color: #d9e4f0 #d9e4f0 #fff
                }

        .um-table-wrap {
            width: 100%;
            overflow-x: auto
        }

        .um-muted {
            font-size: 12px;
            color: #64748b
        }

        .um-status {
            display: inline-block;
            border-radius: 20px;
            padding: 3px 9px;
            font-size: 11px;
            font-weight: 700;
            background: #e7f7ed;
            color: #18723b
        }

            .um-status.off {
                background: #f1f3f5;
                color: #687385
            }

        .um-validation {
            display: none;
            color: #b91c1c;
            font-size: 12px;
            margin-top: 5px
        }

        .um-loader {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(255,255,255,.68);
            z-index: 10000;
            align-items: center;
            justify-content: center
        }

            .um-loader.show {
                display: flex
            }

            .um-loader span {
                background: #fff;
                padding: 14px 20px;
                border-radius: 10px;
                box-shadow: 0 6px 24px #94a3b866;
                font-weight: 700
            }

        .um-section-note {
            padding: 10px 12px;
            background: #f3f8ff;
            border-left: 3px solid #2870ca;
            border-radius: 5px;
            margin-bottom: 12px;
            font-size: 12px
        }

        .um-mapping-card {
            position: relative;
            overflow: hidden;
            padding: 0;
            border-color: #dbe6f2;
            box-shadow: 0 14px 34px rgba(22,54,91,.09)
        }

            .um-mapping-card::before {
                position: absolute;
                top: 0;
                right: 0;
                left: 0;
                height: 4px;
                background: linear-gradient(90deg,#1c62bf,#16b4aa,#70d4c2);
                content: ""
            }

        .um-mapping-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 22px 24px 16px
        }

        .um-mapping-title-icon {
            display: grid;
            flex: 0 0 46px;
            width: 46px;
            height: 46px;
            place-items: center;
            border: 1px solid #cfe4f5;
            border-radius: 14px;
            color: #1764ad;
            background: linear-gradient(145deg,#eaf4ff,#dcf8f3);
            font-size: 19px
        }

        .um-mapping-heading-copy {
            min-width: 0;
            flex: 1
        }

            .um-mapping-heading-copy h2 {
                margin: 0 !important;
                color: #17385e;
                font-size: 19px !important;
                font-weight: 750 !important;
                letter-spacing: -.02em
            }

            .um-mapping-heading-copy p {
                margin: 4px 0 0;
                color: #71839a;
                font-size: 12px
            }

        .um-mapping-heading-tag {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 12px;
            border: 1px solid #dce8f4;
            border-radius: 999px;
            color: #48647f;
            background: #f7faff;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap
        }

            .um-mapping-heading-tag i {
                color: #19a994
            }

        .um-mapping-callout {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 24px 18px;
            padding: 11px 14px;
            border: 1px solid #d9eafa;
            border-left: 3px solid #3180d1;
            border-radius: 10px;
            color: #45617f;
            background: linear-gradient(100deg,#f2f8ff,#f7fcff);
            font-size: 12px;
            line-height: 1.5
        }

            .um-mapping-callout i {
                color: #3280ce;
                font-size: 15px
            }

        .um-mapping-form {
            margin: 0 24px;
            padding: 18px;
            border: 1px solid #e3ebf4;
            border-radius: 14px;
            background: linear-gradient(145deg,#fbfdff,#f6f9fd)
        }

        .um-mapping-grid {
            display: grid;
            grid-template-columns: minmax(180px,1.1fr) minmax(260px,1.45fr) repeat(2,minmax(150px,.9fr));
            align-items: start;
            gap: 16px
        }

        .um-mapping-grid .um-field label {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 8px;
            color: #435a75;
            font-size: 11px;
            font-weight: 750;
            letter-spacing: .045em;
            text-transform: uppercase
        }

        .um-mapping-grid .form-control {
            min-height: 43px;
            border: 1px solid #d4dfeb;
            border-radius: 10px;
            color: #203b5d;
            background-color: #fff;
            box-shadow: 0 1px 2px rgba(22,54,91,.025);
            transition: border-color .18s ease, box-shadow .18s ease
        }

            .um-mapping-grid .form-control:focus {
                border-color: #68a5df;
                box-shadow: 0 0 0 3px rgba(49,128,209,.13)
            }

        .um-mapping-grid #um_mapping_employees {
            min-height: 124px;
            padding: 7px 9px;
            line-height: 1.55
        }

        .um-mapping-grid #um_mapping_employees[aria-readonly="true"] {
            border-color: #83b7df;
            background-color: #f8fbff;
            box-shadow: 0 0 0 3px rgba(49,128,209,.1)
        }

        .um-mapping-grid #um_mapping_employees option:checked {
            color: #fff !important;
            background-color: #2469ad !important;
            background-image: linear-gradient(0deg,#2469ad,#2469ad) !important
        }

        .um-mapping-grid .um-muted {
            display: block;
            margin-top: 7px;
            color: #7b8ca1;
            font-size: 11px
        }

        .um-mapping-period {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            grid-column: 1/-1;
            margin-top: -3px;
            padding: 10px 12px;
            border: 1px solid #d8eee9;
            border-radius: 9px;
            color: #54756f;
            background: #f2fbf8;
            font-size: 11px;
            line-height: 1.45
        }

            .um-mapping-period i {
                margin-top: 1px;
                color: #159b87
            }

        .um-mapping-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            padding: 17px 24px 18px
        }

            .um-mapping-actions .btn {
                min-height: 40px;
                padding: 9px 15px;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 700;
                transition: transform .16s ease, box-shadow .16s ease
            }

                .um-mapping-actions .btn:hover {
                    transform: translateY(-1px)
                }

            .um-mapping-actions .btn-primary {
                border: 0;
                background: linear-gradient(105deg,#1768c4,#16ad9c);
                box-shadow: 0 7px 16px rgba(25,123,170,.2)
            }

            .um-mapping-actions .btn-outline-primary {
                border-color: #b9cde2;
                color: #315b84;
                background: #fff
            }

            .um-mapping-actions .btn-outline-secondary {
                border-color: #d4dfeb;
                color: #566a81;
                background: #fff
            }

        .um-mapping-validation {
            margin: 0 24px 4px;
            padding: 0 12px
        }

            .um-mapping-validation:not(:empty) {
                padding-top: 9px;
                padding-bottom: 9px;
                border: 1px solid #f1c9c9;
                border-radius: 9px;
                background: #fff7f7
            }

        .um-mapping-history {
            margin: 6px 24px 24px;
            padding: 17px 17px 12px;
            border: 1px solid #e3ebf4;
            border-radius: 14px;
            background: #fff
        }

        .um-mapping-history-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px
        }

            .um-mapping-history-heading h3 {
                margin: 0;
                color: #203d60;
                font-size: 14px;
                font-weight: 750
            }

            .um-mapping-history-heading p {
                margin: 4px 0 0;
                color: #7b8ca1;
                font-size: 11px
            }

        .um-mapping-history-tag {
            padding: 6px 10px;
            border-radius: 999px;
            color: #55708d;
            background: #f1f6fb;
            font-size: 10px;
            font-weight: 750;
            letter-spacing: .04em;
            text-transform: uppercase
        }

        .um-mapping-card .dataTables_wrapper {
            color: #60748c;
            font-size: 11px
        }

        .um-mapping-card .dataTables_wrapper .dataTables_filter input,
        .um-mapping-card .dataTables_wrapper .dataTables_length select {
            min-height: 34px;
            border: 1px solid #d6e1ec;
            border-radius: 8px;
            color: #294565;
            background: #fff
        }

        .um-mapping-card #um_mappings_table {
            min-width: 680px !important;
            margin-top: 10px !important;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid #e4ebf3;
            border-radius: 10px;
            overflow: hidden
        }

            .um-mapping-card #um_mappings_table thead th {
                padding: 12px 13px;
                border: 0;
                color: #eaf3ff;
                background: #153d67;
                font-size: 10px;
                font-weight: 750;
                letter-spacing: .05em;
                text-transform: uppercase
            }

            .um-mapping-card #um_mappings_table tbody td {
                padding: 12px 13px;
                border-top: 1px solid #edf1f6;
                color: #344c68;
                vertical-align: middle
            }

            .um-mapping-card #um_mappings_table tbody tr:hover {
                background: #f5f9fe
            }

            .um-mapping-card #um_mappings_table .um-actions {
                gap: 6px
            }

            .um-mapping-card #um_mappings_table .btn {
                padding: 6px 9px;
                border-radius: 8px;
                font-size: 10px;
                font-weight: 700
            }

        .um-user-form-card,
        .um-user-table-card {
            border-color: #dce7f2;
            box-shadow: 0 12px 30px rgba(22,54,91,.075)
        }

        .um-user-form-card {
            position: relative;
            overflow: hidden;
            padding: 0
        }

            .um-user-form-card::before,
            .um-user-table-card::before {
                position: absolute;
                top: 0;
                right: 0;
                left: 0;
                height: 4px;
                background: linear-gradient(90deg,#1c62bf,#16b4aa,#70d4c2);
                content: ""
            }

        .um-user-heading {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0
        }

        .um-user-title-icon {
            display: grid;
            flex: 0 0 42px;
            width: 42px;
            height: 42px;
            place-items: center;
            border: 1px solid #cfe4f5;
            border-radius: 13px;
            color: #1764ad;
            background: linear-gradient(145deg,#eaf4ff,#dcf8f3);
            font-size: 17px
        }

        .um-user-heading-copy {
            min-width: 0
        }

            .um-user-heading-copy h2 {
                margin: 0 !important;
                color: #17385e;
                font-size: 18px !important;
                font-weight: 750 !important;
                letter-spacing: -.02em
            }

            .um-user-heading-copy p {
                margin: 4px 0 0;
                color: #71839a;
                font-size: 11px
            }

        .um-user-form-heading {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 20px 23px 16px
        }

        .um-user-form-body {
            margin: 0 23px 22px;
            padding: 18px;
            border: 1px solid #e3ebf4;
            border-radius: 13px;
            background: linear-gradient(145deg,#fbfdff,#f6f9fd)
        }

        .um-user-grid {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 15px
        }

            .um-user-grid .um-field label {
                display: flex;
                align-items: center;
                gap: 6px;
                margin-bottom: 8px;
                color: #435a75;
                font-size: 11px;
                font-weight: 750;
                letter-spacing: .045em;
                text-transform: uppercase
            }

            .um-user-grid .um-field label i {
                color: #6387ad
            }

            .um-user-grid .form-control {
                min-height: 43px;
                border: 1px solid #d4dfeb;
                border-radius: 10px;
                color: #203b5d;
                background-color: #fff;
                box-shadow: 0 1px 2px rgba(22,54,91,.025);
                transition: border-color .18s ease, box-shadow .18s ease
            }

                .um-user-grid .form-control:focus {
                    border-color: #68a5df;
                    box-shadow: 0 0 0 3px rgba(49,128,209,.13)
                }

        .um-user-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 17px
        }

            .um-user-actions .btn-primary {
                min-height: 41px;
                padding: 9px 17px;
                border: 0;
                border-radius: 10px;
                color: #fff;
                background: linear-gradient(105deg,#1768c4,#16ad9c);
                box-shadow: 0 7px 16px rgba(25,123,170,.2);
                font-size: 12px;
                font-weight: 750;
                transition: transform .16s ease, box-shadow .16s ease
            }

                .um-user-actions .btn-primary:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 9px 19px rgba(25,123,170,.25)
                }

        .um-user-guidance {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: #71839a;
            font-size: 11px;
            line-height: 1.45
        }

            .um-user-guidance i {
                color: #4e8dcc
            }

        .um-user-validation {
            margin-top: 10px
        }

        .um-user-table-card {
            position: relative;
            overflow: hidden;
            padding: 0
        }

        .um-user-table-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 20px 23px 15px;
            border-bottom: 1px solid #edf2f7
        }

        .um-user-table-tag {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 11px;
            border: 1px solid #dce8f4;
            border-radius: 999px;
            color: #55708d;
            background: #f7faff;
            font-size: 10px;
            font-weight: 750;
            letter-spacing: .04em;
            text-transform: uppercase;
            white-space: nowrap
        }

            .um-user-table-tag i {
                color: #1c8b9c
            }

        .um-user-table-wrap {
            padding: 12px 22px 20px
        }

        .um-user-table-card .dataTables_wrapper {
            color: #61758c;
            font-size: 11px
        }

        .um-user-table-card .dataTables_length,
        .um-user-table-card .dataTables_filter {
            margin-bottom: 12px;
            color: #425b77;
            font-size: 11px;
            font-weight: 650
        }

            .um-user-table-card .dataTables_length select,
            .um-user-table-card .dataTables_filter input {
                min-height: 35px;
                border: 1px solid #d6e2ee;
                border-radius: 9px;
                outline: 0;
                color: #294565;
                background: #fff
            }

            .um-user-table-card .dataTables_filter input {
                width: 190px;
                margin-left: 7px;
                padding: 6px 10px
            }

                .um-user-table-card .dataTables_filter input:focus {
                    border-color: #75a8d9;
                    box-shadow: 0 0 0 3px rgba(49,128,209,.12)
                }

        .um-user-table-card #um_users_table {
            min-width: 1050px !important;
            width: 100% !important;
            margin: 0 !important;
            border: 1px solid #e1eaf3;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 11px;
            overflow: hidden
        }

            .um-user-table-card #um_users_table thead th {
                padding: 12px 11px;
                border: 0;
                color: #f1f7ff;
                background: linear-gradient(100deg,#12395f,#174873);
                font-size: 10px;
                font-weight: 750;
                letter-spacing: .045em;
                line-height: 1.35;
                white-space: nowrap
            }

            .um-user-table-card #um_users_table tbody td {
                padding: 11px;
                border-top: 1px solid #edf2f7;
                color: #344c68;
                background: #fff;
                font-size: 11px;
                line-height: 1.5;
                vertical-align: middle
            }

            .um-user-table-card #um_users_table tbody tr:nth-child(even) td {
                background: #f8fafd
            }

            .um-user-table-card #um_users_table tbody tr:hover td {
                background: #eef6ff
            }

            .um-user-table-card #um_users_table th:first-child,
            .um-user-table-card #um_users_table td:first-child {
                width: 55px;
                text-align: center
            }

            .um-user-table-card #um_users_table th:last-child,
            .um-user-table-card #um_users_table td:last-child {
                min-width: 130px
            }

        .um-user-current-status {
            display: inline-block;
            max-width: 140px;
            padding: 5px 9px;
            overflow: hidden;
            border: 1px solid #d7e7f6;
            border-radius: 999px;
            color: #35658e;
            background: #f1f8ff;
            font-size: 10px;
            font-weight: 700;
            text-overflow: ellipsis;
            vertical-align: middle;
            white-space: nowrap
        }

        .um-user-table-card .um-end-user {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            min-height: 32px;
            padding: 6px 10px;
            border: 1px solid #efcaca;
            border-radius: 8px;
            color: #a94747;
            background: #fff7f7;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap;
            transition: transform .15s ease, box-shadow .15s ease, background .15s ease
        }

            .um-user-table-card .um-end-user:hover {
                transform: translateY(-1px);
                color: #963737;
                background: #ffeded;
                box-shadow: 0 4px 9px rgba(169,71,71,.12)
            }

        .um-user-table-card .dataTables_info,
        .um-user-table-card .dataTables_paginate {
            margin-top: 12px;
            color: #71839a !important;
            font-size: 11px
        }

        .um-user-table-card .dataTables_paginate .paginate_button {
            margin-left: 3px !important;
            padding: 6px 10px !important;
            border: 1px solid transparent !important;
            border-radius: 7px !important;
            color: #49617c !important;
            background: transparent !important
        }

            .um-user-table-card .dataTables_paginate .paginate_button.current,
            .um-user-table-card .dataTables_paginate .paginate_button.current:hover {
                border-color: #c9dcef !important;
                color: #1b5e9f !important;
                background: #edf6ff !important
            }

            .um-user-table-card .dataTables_paginate .paginate_button:hover {
                border-color: #d6e4f2 !important;
                color: #1d568e !important;
                background: #f4f8fd !important
            }

        .um-resources-card {
            padding: 20px;
            border-color: #dce7f2;
            box-shadow: 0 12px 30px rgba(22,54,91,.075)
        }

            .um-resources-card > .um-actions {
                gap: 14px;
                padding: 2px 1px 13px;
                border-bottom: 1px solid #edf2f7
            }

            .um-resources-card h2 {
                color: #193b60;
                font-size: 17px !important;
                font-weight: 750 !important
            }

            .um-resources-card h2 i {
                margin-right: 5px
            }

            .um-resources-card #um_resource_filter_project {
                min-height: 38px;
                border: 1px solid #d6e2ee;
                border-radius: 9px;
                color: #36516f;
                background-color: #fff;
                box-shadow: 0 1px 3px rgba(20,56,96,.04)
            }

        .um-resource-table-wrap {
            padding-bottom: 5px
        }

        .um-resources-card .dataTables_wrapper {
            color: #61758c;
            font-size: 11px
        }

            .um-resources-card .dataTables_wrapper::after {
                display: block;
                clear: both;
                content: ""
            }

        .um-resources-card .dt-buttons {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 12px
        }

            .um-resources-card .dt-buttons .um-resource-export {
                display: inline-flex !important;
                align-items: center;
                gap: 8px;
                min-height: 38px;
                padding: 8px 14px !important;
                border: 1px solid #138d76 !important;
                border-radius: 9px !important;
                color: #fff !important;
                background: linear-gradient(110deg,#168b79,#20ad94) !important;
                box-shadow: 0 5px 12px rgba(25,149,126,.18);
                font-size: 11px !important;
                font-weight: 750 !important;
                text-shadow: none !important;
                transition: transform .16s ease, box-shadow .16s ease
            }

                .um-resources-card .dt-buttons .um-resource-export::before {
                    content: "\f1c3";
                    font-family: "Font Awesome 5 Free";
                    font-weight: 900
                }

                .um-resources-card .dt-buttons .um-resource-export:hover {
                    transform: translateY(-1px);
                    background: linear-gradient(110deg,#117c6c,#149982) !important;
                    box-shadow: 0 8px 16px rgba(25,149,126,.24)
                }

        .um-resources-card .dataTables_filter {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            margin: 0 0 12px;
            color: #425b77;
            font-size: 11px;
            font-weight: 650
        }

            .um-resources-card .dataTables_filter label {
                display: flex;
                align-items: center;
                gap: 8px;
                margin: 0
            }

            .um-resources-card .dataTables_filter input {
                width: 190px;
                min-height: 36px;
                margin: 0 !important;
                padding: 6px 10px;
                border: 1px solid #d6e2ee;
                border-radius: 9px;
                outline: 0;
                color: #294565;
                background: #fff;
                transition: border-color .16s ease, box-shadow .16s ease
            }

                .um-resources-card .dataTables_filter input:focus {
                    border-color: #75a8d9;
                    box-shadow: 0 0 0 3px rgba(49,128,209,.12)
                }

        .um-resource-table-wrap .dataTables_scroll {
            border: 1px solid #e1eaf3;
            border-radius: 11px;
            background: #fff
        }

        .um-resources-card #um_resources_table {
            min-width: 1480px !important;
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate;
            border-spacing: 0;
            table-layout: auto
        }

            .um-resources-card #um_resources_table thead th {
                padding: 12px 11px;
                border: 0;
                border-bottom: 1px solid #214e78;
                color: #f1f7ff;
                background: linear-gradient(100deg,#12395f,#174873);
                font-size: 10px;
                font-weight: 750;
                letter-spacing: .045em;
                line-height: 1.35;
                white-space: nowrap
            }

            .um-resources-card #um_resources_table tbody td {
                padding: 12px 11px;
                border-top: 1px solid #edf2f7;
                color: #344c68;
                background: #fff;
                font-size: 11px;
                line-height: 1.5;
                vertical-align: middle
            }

            .um-resources-card #um_resources_table tbody tr:nth-child(even) td {
                background: #f8fafd
            }

            .um-resources-card #um_resources_table tbody tr:hover td {
                background: #eef6ff
            }

            .um-resources-card #um_resources_table th:nth-child(1),
            .um-resources-card #um_resources_table td:nth-child(1) {
                width: 65px
            }

            .um-resources-card #um_resources_table th:nth-child(2),
            .um-resources-card #um_resources_table td:nth-child(2) {
                min-width: 145px
            }

            .um-resources-card #um_resources_table th:nth-child(3),
            .um-resources-card #um_resources_table td:nth-child(3) {
                min-width: 135px
            }

            .um-resources-card #um_resources_table th:nth-child(4),
            .um-resources-card #um_resources_table td:nth-child(4) {
                min-width: 170px
            }

            .um-resources-card #um_resources_table th:nth-child(6),
            .um-resources-card #um_resources_table td:nth-child(6),
            .um-resources-card #um_resources_table th:nth-child(7),
            .um-resources-card #um_resources_table td:nth-child(7) {
                min-width: 160px
            }

            .um-resources-card #um_resources_table th:nth-child(12),
            .um-resources-card #um_resources_table td:nth-child(12) {
                min-width: 270px
            }

        .um-resource-actions {
            min-width: 250px;
            gap: 6px
        }

            .um-resource-actions .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                min-height: 31px;
                padding: 6px 9px;
                border-radius: 8px;
                font-size: 10px;
                font-weight: 700;
                line-height: 1.2;
                white-space: nowrap;
                transition: transform .15s ease, box-shadow .15s ease, color .15s ease, background .15s ease
            }

                .um-resource-actions .btn:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 4px 9px rgba(23,57,95,.12)
                }

            .um-resource-actions .um-view-resource {
                border-color: #b8dce9;
                color: #147b98;
                background: #f1fbfe
            }

            .um-resource-actions .um-edit-resource {
                border-color: #c7d9f4;
                color: #285da3;
                background: #f4f8ff
            }

            .um-resource-actions .um-toggle-resource.btn-outline-danger {
                border-color: #f0c9c9;
                color: #ad4545;
                background: #fff7f7
            }

            .um-resource-actions .um-toggle-resource.btn-outline-success {
                border-color: #c5e6d2;
                color: #26734c;
                background: #f3fbf6
            }

            .um-resource-actions .um-manage-resource {
                border-color: #cbd8e7;
                color: #4a617c;
                background: #f8fafd
            }

        .um-resources-card .dataTables_info,
        .um-resources-card .dataTables_paginate {
            margin-top: 12px;
            color: #71839a !important;
            font-size: 11px
        }

        .um-resources-card .dataTables_paginate .paginate_button {
            margin-left: 3px !important;
            padding: 6px 10px !important;
            border: 1px solid transparent !important;
            border-radius: 7px !important;
            color: #49617c !important;
            background: transparent !important
        }

            .um-resources-card .dataTables_paginate .paginate_button.current,
            .um-resources-card .dataTables_paginate .paginate_button.current:hover {
                border-color: #c9dcef !important;
                color: #1b5e9f !important;
                background: #edf6ff !important
            }

            .um-resources-card .dataTables_paginate .paginate_button:hover {
                border-color: #d6e4f2 !important;
                color: #1d568e !important;
                background: #f4f8fd !important
            }

        .dataTables_wrapper .dataTables_filter input {
            margin-left: 6px
        }

        .um-table {
            min-width: 800px !important
        }

        @media(max-width:900px) {
            .um-grid {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }

            .um-mapping-grid {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }

            .um-hero {
                align-items: flex-start;
                flex-direction: column
            }

            .um-invoice-summary {
                grid-template-columns: 1fr;
                gap: 12px
            }

            .um-summary-heading {
                padding: 0 0 12px;
                border-right: 0;
                border-bottom: 1px solid #e1eaf4
            }
        }

        @media(max-width:600px) {
            .um-grid, .um-grid.two {
                grid-template-columns: 1fr
            }

            .um-user-form-heading,
            .um-user-table-heading {
                padding: 17px 16px 13px
            }

            .um-user-table-tag {
                display: none
            }

            .um-user-form-body {
                margin: 0 14px 15px;
                padding: 14px
            }

            .um-user-grid {
                grid-template-columns: 1fr;
                gap: 13px
            }

            .um-user-actions {
                align-items: stretch;
                flex-direction: column
            }

            .um-user-actions .btn-primary {
                width: 100%
            }

            .um-user-table-wrap {
                padding: 10px 14px 15px
            }

            .um-user-table-card .dataTables_filter {
                float: none;
                text-align: left
            }

            .um-user-table-card .dataTables_filter input {
                width: min(190px,52vw)
            }

            .um-mapping-heading {
                padding: 18px 16px 14px
            }

            .um-mapping-heading-tag {
                display: none
            }

            .um-mapping-callout {
                align-items: flex-start;
                margin: 0 16px 14px
            }

            .um-mapping-form {
                margin: 0 16px;
                padding: 14px
            }

            .um-mapping-grid {
                grid-template-columns: 1fr;
                gap: 13px
            }

            .um-mapping-period {
                grid-column: auto
            }

            .um-mapping-actions {
                align-items: stretch;
                flex-direction: column;
                padding: 14px 16px
            }

                .um-mapping-actions .btn {
                    width: 100%
                }

            .um-mapping-validation {
                margin-right: 16px;
                margin-left: 16px
            }

            .um-mapping-history {
                margin: 5px 16px 16px;
                padding: 13px 12px 9px
            }

            .um-resources-card {
                padding: 14px
            }

            .um-resources-card > .um-actions {
                align-items: stretch;
                flex-direction: column
            }

            .um-resources-card #um_resource_filter_project {
                width: 100%;
                max-width: none !important
            }

            .um-resources-card .dataTables_filter {
                float: none;
                justify-content: flex-start
            }

            .um-resources-card .dataTables_filter input {
                width: min(190px,52vw)
            }

            .um-field.full {
                grid-column: auto
            }

            .um-card {
                padding: 13px
            }

            .um-hero {
                padding: 17px
            }

            .um-invoice-summary {
                padding: 14px
            }

            .um-record-context {
                grid-template-columns: 1fr;
                gap: 9px
            }
        }
    </style>
    <script src="../Scripts/Functions/UserMapping.js?v=20261021-12"></script>
</asp:Content>
<asp:Content ID="UserMappingBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="um-page" id="um_page" data-header-id="<%= HeaderID %>" data-month="<%= System.Web.HttpUtility.HtmlAttributeEncode(Month) %>" data-year="<%= System.Web.HttpUtility.HtmlAttributeEncode(Year) %>">
        <header class="um-hero">
            <div>
                <h1><i class="fas fa-users-cog"></i>User Mapping Management</h1>
                <p class="um-context" id="um_context">Loading invoice and project details...</p>
            </div>
            <a class="um-back-link" href="InvoiceVerification.aspx"><i class="fas fa-arrow-left" aria-hidden="true"></i><span>Back to Invoice Verification</span></a>
        </header>

        <section class="um-invoice-summary" aria-label="Selected invoice details">
            <div class="um-summary-heading">
                <span class="um-summary-icon"><i class="fas fa-file-invoice"></i></span>
                <div>
                    <h2>Selected Invoice</h2>
                    <p>Details for this user mapping</p>
                </div>
            </div>
            <div class="um-record-context">
                <div><span><i class="fas fa-heading"></i>Header</span><strong id="um_invoice_header">-</strong></div>
                <div><span><i class="fas fa-globe"></i>Domain</span><strong id="um_invoice_domain">-</strong></div>
                <div><span><i class="fas fa-box-open"></i>Product Name</span><strong id="um_invoice_product">-</strong></div>
            </div>
        </section>

        <ul class="nav nav-tabs um-tabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#um_tab_users" role="tab">Add New User</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#um_tab_resources" role="tab">Non-Employee / Corporate Resources</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#um_tab_report" role="tab">Consolidated Report</a></li>
        </ul>
        <div class="tab-content">
            <section class="tab-pane fade show active" id="um_tab_users" role="tabpanel">
                <div class="um-card um-user-form-card">
                    <div class="um-user-form-heading">
                        <span class="um-user-title-icon"><i class="fas fa-user-plus" aria-hidden="true"></i></span>
                        <div class="um-user-heading-copy">
                            <h2>Add New User</h2>
                            <p>Add an employee to the selected invoice mapping.</p>
                        </div>
                    </div>
                    <div class="um-user-form-body">
                        <div class="um-user-grid">
                            <div class="um-field">
                                <label for="um_employee"><i class="fas fa-user" aria-hidden="true"></i>Employee <span class="um-required">*</span></label><select id="um_employee" class="form-control"><option value="">Loading employees...</option>
                                </select>
                            </div>
                            <div class="um-field" id="um_other_wrap" style="display: none">
                                <label for="um_other"><i class="fas fa-user-edit" aria-hidden="true"></i>Other user <span class="um-required">*</span></label><input id="um_other" class="form-control" maxlength="200" />
                            </div>
                            <div class="um-field">
                                <label for="um_user_from"><i class="far fa-calendar-check" aria-hidden="true"></i>Effective Date <span class="um-required">*</span></label><input type="date" id="um_user_from" class="form-control" />
                            </div>
                        </div>
                        <div class="um-user-actions">
                            <button id="um_add_user" type="button" class="btn btn-primary"><i class="fas fa-plus" aria-hidden="true"></i> Add User</button>
                            <span class="um-user-guidance"><i class="fas fa-info-circle" aria-hidden="true"></i>Existing duplicate and employee rules are applied by the invoice mapping procedure.</span>
                        </div>
                        <div class="um-validation um-user-validation" id="um_user_error"></div>
                    </div>
                </div>

                <div class="um-card um-user-table-card">
                    <div class="um-user-table-heading">
                        <div class="um-user-heading">
                            <span class="um-user-title-icon"><i class="fas fa-users" aria-hidden="true"></i></span>
                            <div class="um-user-heading-copy">
                                <h2>Invoice Users</h2>
                                <p>People currently associated with this invoice</p>
                            </div>
                        </div>
                        <span class="um-user-table-tag"><i class="fas fa-file-invoice" aria-hidden="true"></i> Invoice mappings</span>
                    </div>
                    <div class="um-table-wrap um-user-table-wrap">
                        <table id="um_users_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Sr.</th>
                                    <th>Number</th>
                                    <th>Cost</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Pseudoname</th>
                                    <th>Branch</th>
                                    <th>Domain</th>
                                    <th>Project</th>
                                    <th>Current Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="um_tab_resources" role="tabpanel">
                <div class="um-card">
                    <h2><i class="fas fa-building text-primary"></i>Corporate Resource</h2>
                    <input type="hidden" id="um_resource_id" value="0" />
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_resource_name">Resource Name <span class="um-required">*</span></label><input id="um_resource_name" class="form-control" maxlength="255" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_type">Resource Type <span class="um-required">*</span></label><select id="um_resource_type" class="form-control"><option value="">Select</option>
                                <option>Shared Mailbox</option>
                                <option>Microsoft Teams Resource</option>
                                <option>Departmental Account</option>
                                <option>Shared/Common Account</option>
                                <option>Service Account</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_account">Email / Account Identifier</label><input id="um_account" class="form-control" maxlength="255" />
                        </div>
                        <div class="um-field">
                            <label for="um_project">Project <span class="um-required">*</span></label>
                            <select id="um_project" class="form-control">
                                <option value="">Select project</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_domain">Department / Domain</label><%--<select id="um_domain" class="form-control"><option value="">Select</option>
                            </select>--%>
                            <input id="um_domain" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_from">Effective From <span class="um-required">*</span></label><input type="date" id="um_resource_from" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_to">Effective To</label><input type="date" id="um_resource_to" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_resource_status">Status</label><select id="um_resource_status" class="form-control"><option value="1">Active</option>
                                <option value="0">Deactivated</option>
                            </select>
                        </div>
                        <div class="um-field full">
                            <label for="um_description">Description / Purpose</label><textarea id="um_description" class="form-control" rows="2" maxlength="1000"></textarea>
                        </div>
                        <div class="um-field full">
                            <label for="um_remark">Remark</label><textarea id="um_remark" class="form-control" rows="2" maxlength="1000"></textarea>
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_save_resource" type="button" class="btn btn-primary"><i class="fas fa-save"></i>Save Resource</button>
                        <button id="um_clear_resource" type="button" class="btn btn-outline-secondary">Clear</button>
                    </div>
                    <div class="um-validation" id="um_resource_error"></div>
                </div>
                <div class="um-card um-mapping-card">
                    <div class="um-mapping-heading">
                        <span class="um-mapping-title-icon"><i class="fas fa-link" aria-hidden="true"></i></span>
                        <div class="um-mapping-heading-copy">
                            <h2>Employee Mapping</h2>
                            <p>Connect employees to corporate resources and manage their active periods.</p>
                        </div>
                        <span class="um-mapping-heading-tag"><i class="fas fa-shield-alt" aria-hidden="true"></i> Resource access</span>
                    </div>
                    <div class="um-mapping-callout"><i class="fas fa-info-circle" aria-hidden="true"></i><span>Each employee relationship keeps its own effective dates and history. Ending a mapping preserves the record.</span></div>
                    <div class="um-mapping-form">
                        <div class="um-mapping-grid">
                            <div class="um-field">
                                <label for="um_mapping_resource"><i class="fas fa-cube" aria-hidden="true"></i>Corporate Resource <span class="um-required">*</span></label><select id="um_mapping_resource" class="form-control"><option value="">Select a resource</option>
                                </select>
                            </div>
                            <div class="um-field">
                                <label for="um_mapping_employees"><i class="fas fa-users" aria-hidden="true"></i>Employees <span class="um-required">*</span></label><select id="um_mapping_employees" class="form-control" multiple size="5"></select><small class="um-muted">Use Ctrl/Cmd to select more than one employee.</small>
                            </div>
                            <div class="um-field">
                                <label for="um_mapping_from"><i class="far fa-calendar-check" aria-hidden="true"></i>Effective From <span class="um-required">*</span></label><input type="date" id="um_mapping_from" class="form-control" />
                            </div>
                            <div class="um-field">
                                <label for="um_mapping_to"><i class="far fa-calendar-alt" aria-hidden="true"></i>Effective To</label><input type="date" id="um_mapping_to" class="form-control" />
                            </div>
                        </div>
                        <div class="um-mapping-period"><i class="fas fa-clock" aria-hidden="true"></i><small id="um_mapping_period_note">Dates must fall within the selected resource's effective period.</small></div>
                    </div>
                    <div class="um-mapping-actions">
                        <button id="um_save_mapping" type="button" class="btn btn-primary"><i class="fas fa-user-plus"></i>Add Employee Mapping</button>
                        <button id="um_cancel_mapping_edit" type="button" class="btn btn-outline-secondary" style="display: none">Cancel Edit</button>
                        <button id="um_associate_billing" type="button" class="btn btn-outline-primary"><i class="fas fa-file-invoice-dollar"></i>Associate With This Billing Period</button>
                    </div>
                    <div class="um-validation um-mapping-validation" id="um_mapping_error"></div>
                    <div class="um-mapping-history">
                        <div class="um-mapping-history-heading">
                            <div><h3>Employee assignments</h3><p>Current status and effective dates for this resource</p></div>
                            <span class="um-mapping-history-tag"><i class="fas fa-history" aria-hidden="true"></i> Mapping history</span>
                        </div>
                        <div class="um-table-wrap">
                            <table id="um_mappings_table" class="table table-sm table-striped um-table">
                                <thead>
                                    <tr>
                                        <th>Employee</th>
                                        <th>Effective From</th>
                                        <th>Effective To</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="um-card um-resources-card">
                    <div class="um-actions justify-content-between">
                        <h2 class="mb-0"><i class="fas fa-table text-primary"></i>Corporate Resources</h2>
                        <select id="um_resource_filter_project" class="form-control" style="max-width: 280px"></select>
                    </div>
                    <div class="um-table-wrap um-resource-table-wrap mt-3">
                        <table id="um_resources_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Resource ID</th>
                                    <th>Resource Name</th>
                                    <th>Resource Type</th>
                                    <th>Email / Account</th>
                                    <th>Project</th>
                                    <th>Department / Domain</th>
                                    <th>Mapped Employees</th>
                                    <th>Effective From</th>
                                    <th>Effective To</th>
                                    <th>Status</th>
                                    <th>Remark</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="um_tab_report" role="tabpanel">
                <div class="um-card">
                    <h2><i class="fas fa-chart-bar text-primary"></i>Consolidated Report</h2>
                    <div class="um-grid">
                        <div class="um-field">
                            <label for="um_report_month">Billing Month</label><select id="um_report_month" class="form-control"><option value="">All</option>
                                <option>January</option>
                                <option>February</option>
                                <option>March</option>
                                <option>April</option>
                                <option>May</option>
                                <option>June</option>
                                <option>July</option>
                                <option>August</option>
                                <option>September</option>
                                <option>October</option>
                                <option>November</option>
                                <option>December</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_year">Billing Year</label><select id="um_report_year" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_type">Record Type</label><select id="um_report_type" class="form-control"><option value="">All</option>
                                <option>Employee</option>
                                <option>Corporate Resource</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_project">Project</label><select id="um_report_project" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_domain">Department / Domain</label><select id="um_report_domain" class="form-control"><option value="">All</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_resource_type">Resource Type</label><select id="um_report_resource_type" class="form-control"><option value="">All</option>
                                <option>Shared Mailbox</option>
                                <option>Microsoft Teams Resource</option>
                                <option>Departmental Account</option>
                                <option>Shared/Common Account</option>
                                <option>Service Account</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_status">Status</label><select id="um_report_status" class="form-control"><option value="">All</option>
                                <option value="1">Active</option>
                                <option value="0">Deactivated</option>
                            </select>
                        </div>
                        <div class="um-field">
                            <label for="um_report_from">Effective From</label><input type="date" id="um_report_from" class="form-control" />
                        </div>
                        <div class="um-field">
                            <label for="um_report_to">Effective To</label><input type="date" id="um_report_to" class="form-control" />
                        </div>
                    </div>
                    <div class="um-actions mt-3">
                        <button id="um_run_report" type="button" class="btn btn-primary"><i class="fas fa-search"></i>Run Report</button>
                    </div>
                </div>
                <div class="um-card">
                    <div class="um-table-wrap">
                        <table id="um_report_table" class="table table-striped table-hover um-table">
                            <thead>
                                <tr>
                                    <th>Record Type</th>
                                    <th>Employee / Resource</th>
                                    <th>Employee Code / Resource ID</th>
                                    <th>Resource Type</th>
                                    <th>Email / Account</th>
                                    <th>Project</th>
                                    <th>Department</th>
                                    <th>Domain</th>
                                    <th>Mapped Employees</th>
                                    <th>Billing Month</th>
                                    <th>Billing Year</th>
                                    <th>Billing Date</th>
                                    <th>Effective From</th>
                                    <th>Effective To</th>
                                    <th>Billing Amount</th>
                                    <th>Status</th>
                                    <th>Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <div class="um-loader" id="um_loader"><span><i class="fas fa-spinner fa-spin"></i>Please wait...</span></div>
    <div class="modal fade" id="um_message_modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="um_message_title" class="modal-title">Notice</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div id="um_message_body" class="modal-body"></div>
                <div class="modal-footer">
                    <button class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="um_confirm_modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm action</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div id="um_confirm_body" class="modal-body"></div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button id="um_confirm_yes" class="btn btn-primary">Confirm</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
