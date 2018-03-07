//Esta funcion quita los espacios y saltos de linea de una cadena
function trim(cadena)
{
   if (cadena == null) {
      console.log(cadena)
      cadena = "";
   }
   for (i = 0; i < cadena.length; )
   {
      if (cadena.charAt(i) == " " || cadena.charCodeAt(i) == 10 || cadena.charCodeAt(i) == 13)
         cadena = cadena.substring(i + 1, cadena.length);
      else
         break;
   }
   for (i = cadena.length - 1; i >= 0; i = cadena.length - 1)
   {
      if (cadena.charAt(i) == " " || cadena.charCodeAt(i) == 10 || cadena.charCodeAt(i) == 13)
         cadena = cadena.substring(0, i);
      else
         break;
   }
   return cadena;
}
function startsWith(str, s) {
   var reg = new RegExp("^" + s);
   return reg.test(str);
}

var vbCr = "\r";
var vbLf = "\n";
var vbCrLf = vbCr + vbLf;
var vbTab = "\t";
function Left(s, n) {
   // Devuelve los n primeros caracteres de la cadena
   if (n > s.length)
      n = s.length;
   return s.substring(0, n);
}
function Right(s, n) {
   // Devuelve los n ˙ltimos caracteres de la cadena
   var t = s.length;
   if (n > t)
      n = t;
   return s.substring(t - n, t);
}
function Mid(s, n, c) {
   // Devuelve una cadena desde la posiciÛn n, con c caracteres
   // Si c = 0 devolver toda la cadena desde la posicion
   var numargs = Mid.arguments.length;
   if (numargs < 3)
      c = s.length - n + 1;
   if (c < 1)
      c = s.length - n + 1;
   if (n + c > s.length)
      c = s.length - n + 1;
   if (n > s.length)
      return "";
   return s.substring(n - 1, n + c - 1);
}
function FormatNumber(num, decimalNum, bolLeadingZero, bolParens, bolCommas, boltruncate)
        /**********************************************************************
         IN:
         NUM - the number to format
         decimalNum - the number of decimal places to format the number to
         bolLeadingZero - true / false - display a leading zero for
         numbers between -1 and 1
         bolParens - true / false - use parenthesis around negative numbers
         bolCommas - put commas as number separators.
         boltruncate- truncate instead o round
         RETVAL:
         The formatted number!
         **********************************************************************/
        {
           if (isNaN(parseInt(num)))
              return "NaN";
           var tmpNum = num;
           var iSign = num < 0 ? -1 : 1;// Get sign of number
           // Adjust number so only the specified number of numbers after
           // the decimal point are shown.
           tmpNum *= Math.pow(10, decimalNum);
           //if  not truncate round the number
           if (boltruncate == false || boltruncate == null)
              tmpNum = Math.round(Math.abs(tmpNum));
           else
              tmpNum = Math.floor(Math.abs(tmpNum));

           tmpNum /= Math.pow(10, decimalNum);
           tmpNum *= iSign;// Readjust for sign
           // Create a string object to do our formatting on
           var tmpNumStr = new String(tmpNum);
           // See if we need to strip out the leading zero or not.
           if (!bolLeadingZero && num < 1 && num > -1 && num != 0)
              if (num > 0)
                 tmpNumStr = tmpNumStr.substring(1, tmpNumStr.length);
              else
                 tmpNumStr = "-" + tmpNumStr.substring(2, tmpNumStr.length);
           // See if we need to put in the commas
           if (bolCommas && (num >= 1000 || num <= -1000)) {
              var iStart = tmpNumStr.indexOf(".");
              if (iStart < 0)
                 iStart = tmpNumStr.length;
              iStart -= 3;
              while (iStart >= 1) {
                 tmpNumStr = tmpNumStr.substring(0, iStart) + "," + tmpNumStr.substring(iStart, tmpNumStr.length)
                 iStart -= 3;
              }
           }
           // See if we need to use parenthesis
           if (bolParens && num < 0)
              tmpNumStr = "(" + tmpNumStr.substring(1, tmpNumStr.length) + ")";
           //See if we need to complete 0
           var iStartZero = tmpNumStr.indexOf(".");
           if (iStartZero < 0) {
              if (decimalNum > 0) {
                 tmpNumStr += ".";
                 for (var i = 0; i < decimalNum; i++) {
                    tmpNumStr += "0";
                 }
              }
           } else {
           }
           return tmpNumStr;// Return our formatted string!
        }
function UCase(s) {
   return s.toUpperCase();
}
//-->
function replaceCaracter(valor, caracter) {
   do {
      valor = valor.replace(caracter, "");
   } while (valor.indexOf(caracter) >= 0);
   return valor;
}
function ObtenFecha(strFecha) {
   var strFecha2 = "";
   strFecha2 = strFecha.substring(6, 8) + "/" + strFecha.substring(4, 6) + "/" + strFecha.substring(0, 4)
   return strFecha2;
}