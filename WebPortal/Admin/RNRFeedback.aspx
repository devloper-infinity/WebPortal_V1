<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RNRFeedback.aspx.cs" Inherits="WebPortal.Admin.RNRFeedback" %>

<!doctype html>
<html>
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>RNR Feedback</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,600,700&display=fallback">
    <style>
        body {
            margin: 0;
            background: #f4f6f9;
            font-family: 'Source Sans Pro',Arial,sans-serif;
            color: #343a40
        }

        .wrap {
            max-width: 760px;
            margin: 28px auto;
            padding: 0 14px
        }

        .card {
            background: #fff;
            border: 1px solid rgba(0,0,0,.125);
            border-radius: .25rem;
            padding: 22px;
            margin: 16px 0;
            box-shadow: 0 0 1px rgba(0,0,0,.125),0 1px 3px rgba(0,0,0,.2)
        }

        .hero {
            border-top: 3px solid #007bff
        }

            .hero h1 {
                font-size: 1.8rem;
                font-weight: 400;
                margin-top: 0
            }

        .period {
            display: inline-block;
            background: #e9f3ff;
            color: #0069d9;
            padding: 6px 10px;
            border-radius: .25rem;
            font-weight: 600
        }

        .q {
            font-weight: 600;
            font-size: 1.05rem
        }

        .req {
            color: #dc3545
        }

        .choice {
            display: block;
            padding: 7px
        }

            .choice input {
                margin-right: 9px
            }

        textarea {
            width: 100%;
            min-height: 100px;
            box-sizing: border-box;
            padding: .5rem .75rem;
            border: 1px solid #ced4da;
            border-radius: .25rem
        }

        button {
            background: #007bff;
            color: #fff;
            border: 1px solid #007bff;
            border-radius: .25rem;
            padding: .5rem 1rem;
            font-weight: 600
        }

            button:hover {
                background: #0069d9
            }

        .logout {
            float: right;
            color: #007bff
        }

        .error {
            color: #dc3545
        }
    </style>
</head>
<body>
    <div class="wrap"><a class="logout" href="../Logout.aspx">Logout</a><div id="form"></div>
    </div>
    <script>
let assignment=0,questions=[];async function call(n,a){let r=await fetch('RNRFeedback.aspx/'+n,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(a||{})});let x=await r.json();if(!r.ok)throw Error(x.Message||'Request failed');return x.d}function e(s){return String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
async function init(){let x=await call('Load');if(!x){window.location.replace('../Login.aspx');return}assignment=x.Header.AssignmentID;questions=x.Questions;let h=`<div class="card hero"><h1>${e(x.Header.Title)}</h1><p>${e(x.Header.Description)}</p><p class="period">${e(x.Header.SurveyYear)} · ${e(x.Header.Quarter)}</p></div>`;questions.forEach(q=>{let opts=x.Options.filter(o=>o.QuestionID===q.QuestionID);h+=`<div class="card" data-id="${q.QuestionID}" data-type="${q.QuestionType}" data-required="${q.IsRequired}"><div class="q">${e(q.QuestionText)} ${q.IsRequired?'<span class="req">*</span>':''}</div>`;if(q.QuestionType==='Text')h+='<textarea></textarea>';else if(q.QuestionType==='Rating'){for(let i=q.RatingMin;i<=q.RatingMax;i++)h+=`<label class="choice"><input type="radio" name="q${q.QuestionID}" value="${i}">${i}</label>`}else{if(q.QuestionType==='YesNo')opts=[{OptionID:-1,OptionText:'Yes'},{OptionID:-2,OptionText:'No'}];opts.forEach(o=>h+=`<label class="choice"><input type="${q.QuestionType==='MultipleChoice'?'checkbox':'radio'}" name="q${q.QuestionID}" value="${o.OptionID}">${e(o.OptionText)}</label>`)}h+='</div>'});h+='<div class="card"><div id="error" class="error"></div><button onclick="submitForm()">Submit feedback</button></div>';document.getElementById('form').innerHTML=h}
async function submitForm(){let answers=[],bad=false;document.querySelectorAll('[data-id]').forEach(d=>{let type=d.dataset.type,a={QuestionID:+d.dataset.id,OptionIDs:[]};if(type==='Text')a.Text=d.querySelector('textarea').value.trim();else if(type==='Rating'){let c=d.querySelector(':checked');if(c)a.Rating=+c.value}else if(type==='YesNo'){let c=d.querySelector(':checked');if(c)a.Text=c.value==='-1'?'Yes':'No'}else a.OptionIDs=[...d.querySelectorAll(':checked')].map(x=>+x.value);let supplied=a.Text||a.Rating||a.OptionIDs.length;if(d.dataset.required==='true'&&!supplied){d.style.border='1px solid #dc2626';bad=true}else d.style.border='';answers.push(a)});if(bad){document.getElementById('error').textContent='Please answer every required question.';return}try{await call('Submit',{assignmentId:assignment,answers:answers});window.location.reload()}catch(ex){document.getElementById('error').textContent=ex.message}}
init();</script>
</body>
</html>
