using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using WebPortal.App_Code.DAL;
namespace WebPortal.Assets.Classes{
 public sealed class AssetDbHelper{
  readonly string cs=SQLHelper.ConnectionString;
  public DataTable Query(string procedure,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var a=new SqlDataAdapter(procedure,c)){a.SelectCommand.CommandType=CommandType.StoredProcedure;if(p!=null)a.SelectCommand.Parameters.AddRange(p);var t=new DataTable();a.Fill(t);return t;}}
  public DataTable QueryText(string sql,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var a=new SqlDataAdapter(sql,c)){a.SelectCommand.CommandType=CommandType.Text;if(p!=null)a.SelectCommand.Parameters.AddRange(p);var t=new DataTable();a.Fill(t);return t;}}
  public DataSet QuerySet(string procedure,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var a=new SqlDataAdapter(procedure,c)){a.SelectCommand.CommandType=CommandType.StoredProcedure;if(p!=null)a.SelectCommand.Parameters.AddRange(p);var d=new DataSet();a.Fill(d);return d;}}
  public object Scalar(string procedure,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var cmd=new SqlCommand(procedure,c)){cmd.CommandType=CommandType.StoredProcedure;if(p!=null)cmd.Parameters.AddRange(p);c.Open();return cmd.ExecuteScalar();}}
  public void Exec(string procedure,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var cmd=new SqlCommand(procedure,c)){cmd.CommandType=CommandType.StoredProcedure;if(p!=null)cmd.Parameters.AddRange(p);c.Open();cmd.ExecuteNonQuery();}}
  public void ExecText(string sql,params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var cmd=new SqlCommand(sql,c)){cmd.CommandType=CommandType.Text;if(p!=null)cmd.Parameters.AddRange(p);c.Open();cmd.ExecuteNonQuery();}}
 }
}
