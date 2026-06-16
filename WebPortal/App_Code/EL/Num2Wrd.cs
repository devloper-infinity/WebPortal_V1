using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebPortal.App_Code.EL
{
    public class Num2Wrd
    {
        public string ConvertMyword(int number)
        {
            int flag = 0;
            int lflag = 0;
            string words = String.Empty;
            string[] places = { "Ones", "Ten", "Hundred", "Thousand", "Ten Thousand", "Lakh", "Tenlakhs", "Crore", "Tencrore", "Billon" };
            string rawnumber = number.ToString();
            char[] a = rawnumber.ToCharArray();
            Array.Reverse(a);
            if (a.Length >= 2)
            {
                for (int i = a.Length - 1; i >= 0; i--)
                {
                    if (i % 2 == 0 && i > 2)
                    {
                        if (int.Parse(a[i].ToString()) > 1)
                        {
                            if (int.Parse(a[i - 1].ToString()) == 0)
                            {
                                words = words + getNumberStringty(int.Parse(a[i].ToString())) + " " + places[i - 1] + " ";
                            }
                            else
                            {
                                words = words + getNumberStringty(int.Parse(a[i].ToString())) + " ";
                            }
                        }
                        else if (int.Parse(a[i].ToString()) == 1)
                        {
                            if (int.Parse(a[i - 1].ToString()) == 0)
                            {
                                words = words + "Ten" + " ";
                            }
                            else
                            {
                                words = words + getNumberStringteen(int.Parse(a[i - 1].ToString())) + " ";
                            }
                            flag = 1;
                        }
                    }
                    else
                    {
                        if (i == 1 || i == 0)
                        {
                            if (int.Parse(a[i].ToString()) > 1)
                            {
                                words = words + getNumberStringty(int.Parse(a[i].ToString())) + " " + getNumberString(int.Parse(a[0].ToString())) + " ";
                                break;
                            }
                            else if (int.Parse(a[i].ToString()) == 1)
                            {
                                if (int.Parse(a[i - 1].ToString()) == 0)
                                {
                                    words = words + "Ten" + " ";
                                }
                                else
                                {
                                    words = words + getNumberStringteen(int.Parse(a[i - 1].ToString())) + " ";
                                }

                                break;
                            }
                            else if (int.Parse(a[i - 1].ToString()) != 0)
                            {
                                words = words + getNumberString(int.Parse(a[i - 1].ToString())) + " ";
                                break;
                            }
                            else
                            {
                                break;
                            }
                        }
                        else
                        {
                            if (flag == 0)
                            {
                                for (int l = i; l >= 0; l--)
                                {
                                    if (int.Parse(a[l].ToString()) != 0)
                                    {
                                        lflag = 1;
                                    }
                                }
                                if (lflag == 1 && int.Parse(a[i].ToString()) != 0)
                                {

                                    words = words + getNumberString(int.Parse(a[i].ToString())) + " " + places[i] + " ";
                                    lflag = 0;


                                }
                                else if (lflag == 0)
                                {

                                    lflag = 0;
                                    break;
                                }

                            }
                            else
                            {
                                words = words + " " + places[i] + " ";
                                flag = 0;
                            }

                        }
                    }
                }
            }
            else
            {
                words = getNumberString(int.Parse(a[0].ToString()));
            }
            return words;
        }
        static string getNumberString(int num)
        {
            string Word = String.Empty;
            switch (num)
            {
                case 1:
                    Word = "One";
                    break;
                case 2:
                    Word = "Two";
                    break;

                case 3:
                    Word = "Three";
                    break;

                case 4:
                    Word = "Four";
                    break;

                case 5:
                    Word = "Five";
                    break;

                case 6:
                    Word = "Six";
                    break;
                case 7:
                    Word = "Seven";
                    break;

                case 8:
                    Word = "Eight";
                    break;

                case 9:
                    Word = "Nine";
                    break;


            }
            return Word;
        }
        static string getNumberStringty(int num)
        {
            string Word = String.Empty;
            switch (num)
            {

                case 2:
                    Word = "Twenty";
                    break;

                case 3:
                    Word = "Thirty";
                    break;

                case 4:
                    Word = "Forty";
                    break;

                case 5:
                    Word = "Fifty";
                    break;

                case 6:
                    Word = "Sixty";
                    break;
                case 7:
                    Word = "Seventy";
                    break;

                case 8:
                    Word = "Eighty";
                    break;

                case 9:
                    Word = "Ninty";
                    break;


            }
            return Word;
        }
        static string getNumberStringteen(int num)
        {
            string Word = String.Empty;
            switch (num)
            {
                case 1:
                    Word = "Eleven";
                    break;
                case 2:
                    Word = "Tewlve";
                    break;

                case 3:
                    Word = "Thirteen";
                    break;

                case 4:
                    Word = "Fourteen";
                    break;

                case 5:
                    Word = "Fifteen";
                    break;

                case 6:
                    Word = "Sixteen";
                    break;
                case 7:
                    Word = "Seventeen";
                    break;

                case 8:
                    Word = "Eighteen";
                    break;

                case 9:
                    Word = "Ninteen";
                    break;


            }
            return Word;
        }
    }
}