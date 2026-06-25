<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewBirthdayMessages.aspx.cs" Inherits="WebPortal.Admin.ViewBirthdayMessages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .bd-loader {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(255,255,255,.75);
            z-index: 99999;
            align-items: center;
            justify-content: center;
        }

        .bd-loader-box {
            background: #fff;
            padding: 22px 28px;
            border-radius: 16px;
            box-shadow: 0 10px 35px rgba(0,0,0,.12);
            text-align: center;
            font-size: 13px;
            font-weight: 600;
        }

        .bd-page {
            padding: 18px;
        }


        .remark-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 55%, #f97316 120%);
            border-radius: 22px;
            padding: 24px 28px;
            margin-bottom: 18px;
            box-shadow: var(--remark-shadow);
        }

            .remark-hero:after {
                content: "";
                position: absolute;
                width: 280px;
                height: 280px;
                right: -80px;
                top: -110px;
                background: rgba(255, 255, 255, .16);
                border-radius: 50%;
            }

            .remark-hero h4,
            .remark-hero p,
            .remark-hero .btn {
                position: relative;
                z-index: 1;
            }

            .remark-hero h4 {
                margin: 0;
                font-weight: 800;
                letter-spacing: .2px;
            }

            .remark-hero p {
                margin: 7px 0 0;
                color: rgba(255, 255, 255, .86);
            }

            .remark-hero .btn {
                border-radius: 999px;
                font-weight: 700;
                box-shadow: none;
            }

        /*.birthday-header {*/
        /*   background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 48%, #22c1dc 100%);*/
        /*background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 55%, #22c1dc 120%);
            color: #fff;
            border-radius: 16px;
            padding: 22px 26px;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(255, 118, 140, .25);
        }

            .birthday-header h4 {
                margin: 0;
                font-weight: 700;
            }

            .birthday-header p {
                margin: 6px 0 0;
                opacity: .9;
            }*/

        /*
        .bd-header {
            background: linear-gradient(135deg, #fff4f8, #eef6ff);
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
            box-shadow: 0 8px 28px rgba(0,0,0,.06);
            display: flex;
            justify-content: space-between;
            gap: 15px;
            align-items: center;
        }

        .bd-title {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            color: #1f2937;
        }

        .bd-subtitle {
            margin-top: 6px;
            color: #6b7280;
            font-size: 14px;
        }

        .bd-back-btn {
            border: 0;
            background: #fff;
            color: #374151;
            padding: 10px 16px;
            border-radius: 12px;
            font-weight: 700;
            box-shadow: 0 4px 14px rgba(0,0,0,.08);
        }
*/
        .bd-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,.08);
            overflow: hidden;
        }

        .bd-card-header {
            padding: 18px 22px;
            border-bottom: 1px solid #eef2f7;
            background: #fff;
        }

            .bd-card-header h2 {
                margin: 0;
                font-size: 18px;
                font-weight: 800;
                color: #111827;
            }

            .bd-card-header p {
                margin: 5px 0 0;
                color: #6b7280;
                font-size: 13px;
            }

        .bd-input-wrap {
            padding: 20px 22px;
            background: #fafafa;
        }

        .bd-wish-box {
            display: flex;
            gap: 10px;
        }

        .bd-wish-input {
            height: 46px;
            border-radius: 12px !important;
            border: 1px solid #dbe3ef;
            font-size: 14px;
        }

        .bd-send-btn {
            border: 0;
            border-radius: 12px;
            padding: 0 22px;
            font-weight: 700;
            background: #2563eb;
            color: #fff;
            white-space: nowrap;
        }

        .bd-messages {
            padding: 20px 22px;
            min-height: 180px;
        }

        @media (max-width: 768px) {
            .bd-page {
                padding: 12px;
            }

            .bd-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .bd-title {
                font-size: 20px;
            }

            .bd-back-btn {
                width: 100%;
            }

            .bd-wish-box {
                flex-direction: column;
            }

            .bd-send-btn {
                height: 44px;
                width: 100%;
            }
        }
    </style>
    <style>
        .bank-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            min-height: 96px;
            margin-bottom: 28px;
            padding: 22px 30px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #2457e6 0%, #2e73e9 46%, #35c6d7 100%);
            box-shadow: 0 18px 42px rgba(36, 87, 230, .22);
        }

            .bank-hero::before,
            .bank-hero::after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .16);
                pointer-events: none;
            }

            .bank-hero::before {
                width: 220px;
                height: 220px;
                right: 72px;
                top: -118px;
            }

            .bank-hero::after {
                width: 132px;
                height: 132px;
                right: -22px;
                bottom: -52px;
            }

        .bank-hero-left {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .bank-hero-icon {
            width: 56px;
            height: 56px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .15);
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .20);
            flex-shrink: 0;
        }

            .bank-hero-icon i {
                font-size: 24px;
                color: #fff;
            }

        .bank-hero h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .bank-hero p {
            margin: 6px 0 0;
            font-size: 13px;
            font-weight: 600;
            color: rgba(255, 255, 255, .88);
        }

        .bank-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            color: white!important;
            font-size: 12px;
            font-weight: 800;
            background: linear-gradient(120deg, #2457e6 0%, #2e73e9 46%, #35c6d7 100%);
            border: 1px solid rgba(255, 255, 255, .28);
            white-space: nowrap;
        }
    </style>

    <script>

        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            let EmpID = urlParams.get('EmployeeID') || 0;

            BD_BindAllBirthdayMessages(EmpID);
        });

    </script>

    <style>
        .birthday-message-timeline .timeline-header {
            font-size: 13px !important;
            font-weight: 600;
        }

        .birthday-message-timeline .timeline-body h5 {
            font-size: 14px !important;
            margin: 0;
            color: #444;
        }

        .bg-pink {
            background: #ff758c !important;
            color: #fff;
        }

        .birthday-empty-message {
            text-align: center;
            padding: 35px 20px;
            background: #fff5f8;
            border: 1px dashed #ff9bb0;
            border-radius: 14px;
            color: #555;
        }

            .birthday-empty-message i {
                font-size: 36px;
                color: #ff758c;
                margin-bottom: 10px;
            }

            .birthday-empty-message h5 {
                font-weight: 700;
                margin-bottom: 8px;
            }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="bank-hero">
        <div class="bank-hero-left">
            <div class="bank-hero-icon">
                <i class="fas fa-gift"></i>
            </div>
            <div>
                <h1>Birthday Wishes</h1>
                <p>Warm wishes and heartfelt messages from your colleagues.</p>
            </div>
        </div>
        <div class="bank-chip">
            <a href="ViewBirthdays.aspx" style="color:white;"><i class="fas fa-arrow-left"></i>&nbsp;Back</a>
        </div>
    </div>

    <div class="col-lg-12">
    <div class="birthday-wish-card">
        <div class="birthday-wish-header">
            <div class="birthday-wish-icon">
                <i class="fas fa-gift"></i>
            </div>
            <div>
                <h5>Send Birthday Wish</h5>
                <p>Share a warm birthday message with your colleague.</p>
            </div>
        </div>

        <div class="birthday-wish-box">
            <i class="fas fa-pen"></i>

            <input type="text"
                   id="txtWish"
                   placeholder="Write your birthday wish here..." />

            <button type="button" onclick="SendWish()">
                <i class="fas fa-paper-plane"></i>
                Send
            </button>
        </div>

        <div id="dvMessages" class="birthday-messages"></div>
    </div>
</div>

    <style>
        .birthday-wish-card {
    background: #ffffff;
    border-radius: 18px;
    padding: 24px;
    box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
    border: 1px solid #eef2f7;
}

.birthday-wish-header {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 22px;
}

.birthday-wish-icon {
    width: 52px;
    height: 52px;
    border-radius: 16px;
    background: linear-gradient(135deg, #ff7eb3, #ff758c);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
}

.birthday-wish-header h5 {
    margin: 0;
    font-size: 18px;
    font-weight: 700;
    color: #1f2937;
}

.birthday-wish-header p {
    margin: 4px 0 0;
    font-size: 13px;
    color: #6b7280;
}

.birthday-wish-box {
    display: flex;
    align-items: center;
    gap: 12px;
    background: #f8fafc;
    border: 1px solid #e5e7eb;
    border-radius: 16px;
    padding: 10px 12px;
}

.birthday-wish-box > i {
    color: #ec4899;
    font-size: 16px;
}

.birthday-wish-box input {
    flex: 1;
    border: none;
    outline: none;
    background: transparent;
    font-size: 14px;
    color: #111827;
}

.birthday-wish-box button {
    border: none;
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: #fff;
    padding: 10px 18px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
}

.birthday-wish-box button:hover {
    box-shadow: 0 8px 18px rgba(37, 99, 235, 0.25);
    transform: translateY(-1px);
}

.birthday-messages {
    margin-top: 16px;
}

@media (max-width: 576px) {
    .birthday-wish-box {
        flex-wrap: wrap;
    }

    .birthday-wish-box button {
        width: 100%;
    }
}
    </style>
 <%--   <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <div class="input-group mb-3">

                    <input type="text"
                        id="txtWish"
                        class="form-control"
                        placeholder="Write your birthday wish here..." />

                    <button class="btn btn-primary"
                        type="button"
                        onclick="SendWish()">
                        Send Wish
               
                    </button>

                </div>
                <div id="dvMessages"></div>

            </div>
        </div>
    </div>--%>
</asp:Content>
