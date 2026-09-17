$ErrorActionPreference = 'Stop'
$source = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot '../WebPortal/Search/OrderEntry.aspx.cs')
$start = $source.IndexOf('        private static bool CanDeleteOrders()')
$end = $source.IndexOf('        [WebMethod]', $source.IndexOf('return bllOst.DeleteInfinityOrder(OrderID);', $start))
$methods = $source.Substring($start, $end - $start)
$harness = @'
using System;
using System.IO;
using System.Data;
using System.Linq;
using System.Collections.Generic;
using System.Security.Principal;
using System.Web;
using System.Web.Hosting;
using System.Web.Services;
using System.Web.SessionState;
namespace WebPortal {
 public class MenuService {
  public class MenuItem { public string Url; public List<MenuItem> Children; }
  public static bool Allowed=true;
  public static List<MenuItem> LoadMenu(){return new List<MenuItem>{new MenuItem{Url=Allowed?"~/Search/OrderEntry.aspx?mode=entry":"~/Search/Other.aspx"}};}
 }
}
public class bllOST {
 public static bool Exists=true,Visible=true; public static int Calls=0,LastId=0,Result=1;
 public DataTable GetOrderByID(int id){var d=new DataTable();d.Columns.Add("ProjectID",typeof(int));if(Exists)d.Rows.Add(90);return d;}
 public DataTable GetAllInfinityOrderByProjectAndUser(int user,int project){if(user!=7||project!=90)throw new Exception("Wrong authorization scope");var d=new DataTable();d.Columns.Add("OrderID",typeof(int));if(Visible)d.Rows.Add(123);return d;}
 public int DeleteInfinityOrder(int id){Calls++;LastId=id;return Result;}
}
public class Worker : SimpleWorkerRequest {
 public Worker():base("/",System.IO.Path.GetTempPath(),"OrderEntry.aspx","",new StringWriter()){}
 public override string[][] GetUnknownRequestHeaders(){return new[]{new[]{"X-Order-Delete-Token","test-token"}};}
}
public class Subject {
/*METHODS*/
}
public class Program {
 static void Reset(){
  var context=new HttpContext(new Worker());HttpContext.Current=context;
  context.User=new GenericPrincipal(new GenericIdentity("7","test"),new string[0]);
  var state=new HttpSessionStateContainer("test",new SessionStateItemCollection(),new HttpStaticObjectsCollection(),20,true,HttpCookieMode.UseCookies,SessionStateMode.InProc,false);
  SessionStateUtility.AddHttpSessionStateToContext(context,state);context.Session["OrderEntry.DeleteToken"]="test-token";
  WebPortal.MenuService.Allowed=true;bllOST.Exists=true;bllOST.Visible=true;bllOST.Calls=0;bllOST.Result=1;
 }
 static void Denied(int id,int status){try{Subject.DeleteOrder(id);throw new Exception("Request unexpectedly accepted");}catch(HttpException e){if(e.GetHttpCode()!=status)throw;}if(bllOST.Calls!=0)throw new Exception("BLL called for rejected request");}
 public static void Main(){
  Reset();Denied(0,400);Reset();Denied(-1,400);
  Reset();HttpContext.Current.User=new GenericPrincipal(new GenericIdentity(""),new string[0]);Denied(123,403);
  Reset();WebPortal.MenuService.Allowed=false;Denied(123,403);
  Reset();HttpContext.Current.Session["OrderEntry.DeleteToken"]="wrong";Denied(123,403);
  Reset();bllOST.Exists=false;Denied(123,404);
  Reset();bllOST.Visible=false;Denied(123,403);
  Reset();if(Subject.DeleteOrder(123)!=1||bllOST.LastId!=123||bllOST.Calls!=1)throw new Exception("Incorrect BLL invocation");
  Reset();bllOST.Result=0;if(Subject.DeleteOrder(123)!=0)throw new Exception("Failure return changed");
  Console.WriteLine("PASS: server invalid IDs, unauthenticated user, menu rights, CSRF, nonexistent order, user/project scope, exact BLL ID, and failure return.");
 }
}
'@
$harness = $harness.Replace('/*METHODS*/', $methods)
$testDirectory = Join-Path ([IO.Path]::GetTempPath()) ('order-delete-test-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $testDirectory | Out-Null
$testSource = Join-Path $testDirectory 'DeleteTests.cs'
$testExecutable = Join-Path $testDirectory 'DeleteTests.exe'
Set-Content -LiteralPath $testSource -Value $harness
& "$env:WINDIR/Microsoft.NET/Framework64/v4.0.30319/csc.exe" /nologo /r:System.Web.dll /r:System.Web.Services.dll /r:System.Data.dll /r:System.Data.DataSetExtensions.dll "/out:$testExecutable" $testSource
if ($LASTEXITCODE -ne 0) { throw 'Server test compilation failed' }
& $testExecutable
if ($LASTEXITCODE -ne 0) { throw 'Server checks failed' }

