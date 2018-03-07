<%-- 
    Document   : MLM_process
    Created on : 17/03/2012, 05:52:32 AM
    Author     : zeus
Esta pagina se encarga de ejecutar todos los procesos del multinivel, tales como comisiones, armado de arbol etc
--%>
<%@page import="com.mx.siweb.mlm.compensacion.jonfilu.CalculoComision"%>
<%@page import="com.mx.siweb.mlm.utilerias.VistaRed"%>
<%@page import="com.mx.siweb.mlm.utilerias.Redes"%>
<%@ page import="comSIWeb.ContextoApt.VariableSession" %>
<%@ page import="comSIWeb.ContextoApt.atrJSP" %>
<%@ page import="comSIWeb.ContextoApt.Seguridad" %>
<%@ page import="comSIWeb.Operaciones.CIP_Form" %>
<%@ page import="comSIWeb.Operaciones.Bitacora" %>
<%@ page import="comSIWeb.Operaciones.CIP_Tabla" %>
<%@ page import="Tablas.Usuarios" %>
<%@ page import="comSIWeb.Operaciones.Conexion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
   /*Obtenemos las variables de sesion*/
   VariableSession varSesiones = new VariableSession(request);
   varSesiones.getVars();
   //Abrimos la conexion
   Conexion oConn = new Conexion(varSesiones.getStrUser(), this.getServletContext());
   oConn.open();
   //Instanciamos objeto de seguridad para no permitir el acceso externo a ver los XML
   Seguridad seg = new Seguridad();//Valida que la peticion se halla hecho desde el mismo sitio
   if (varSesiones.getIntNoUser() != 0 && seg.ValidaURL(request)) {
      /*Definimos parametros de la aplicacion*/
      String strid = request.getParameter("id");
      if (strid == null) {
         strid = "0";
      }
      // <editor-fold defaultstate="collapsed" desc="Armado del arbol">
      if (strid.equals("1")) {
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         Redes red = new Redes();
         boolean bolArmo = red.armarArbol("vta_cliente", "CT_ID", "CT_UPLINE", 1, "CT_", "", " ORDER BY CT_ID", false, true, oConn);
         String strRes = "Se ha generado correctamente la red.";
         if (bolArmo) {
            strRes = "ERROR:" + red.getStrError();
         }
         out.println(strRes);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Reporte de treegrid">
      if (strid.equals("2")) {
         int intNodoId = 0;
         if (request.getParameter("NodoId") != null) {
            try {
               intNodoId = Integer.valueOf(request.getParameter("NodoId"));
            } catch (NumberFormatException ex) {
            }
         }
         if (request.getParameter("nodeid") != null) {
            try {
               intNodoId = Integer.valueOf(request.getParameter("nodeid"));
            } catch (NumberFormatException ex) {
            }
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
         VistaRed vistaRed = new VistaRed(oConn);
         String strXML = vistaRed.doXMLtreeGrid(intNodoId);
         out.println(strXML);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Reporte de Json">
      if (strid.equals("8")) {
         int intNodoId = 0;
         if (request.getParameter("NodoId") != null) {
            try {
               intNodoId = Integer.valueOf(request.getParameter("NodoId"));
            } catch (NumberFormatException ex) {
            }
         }
         if (request.getParameter("nodeid") != null) {
            try {
               intNodoId = Integer.valueOf(request.getParameter("nodeid"));
            } catch (NumberFormatException ex) {
            }
         }
         out.clearBuffer();//Limpiamos buffer
         atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
         VistaRed vistaRed = new VistaRed(oConn);
         String strJson = vistaRed.doJsonJit(intNodoId);
         out.println(strJson);//Pintamos el resultado
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones JONFILU">
      if (strid.equals("3")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         System.out.println("comision jonfilu...");
         com.mx.siweb.mlm.compensacion.jonfilu.CalculoComision comis = new com.mx.siweb.mlm.compensacion.jonfilu.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  //System.out.println("Concluyeron las comisiones....");
               } else {
                  //System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               //System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            //System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones TASAREL">
      if (strid.equals("31")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("MPE_TIPOBON") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("MPE_TIPOBON"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.tasarel.CalculoComision comis = new com.mx.siweb.mlm.compensacion.tasarel.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  //System.out.println("Concluyeron las comisiones....");
               } else {
                  //System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               //System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            //System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }

      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones PROSEFI">
      if (strid.equals("32")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("MPE_TIPOBON") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("MPE_TIPOBON"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.prosefi.CalculoComision comis = new com.mx.siweb.mlm.compensacion.prosefi.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(4) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               //System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            //System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }

      }
      //Plan de comisiones mensuales
      if (strid.equals("33")) {
         int intPeriodo = 0;
         if (request.getParameter("MPEM_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPEM_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("MPE_TIPOBON") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("MPE_TIPOBON"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.prosefi.CalculaComisionMensual comis
            = new com.mx.siweb.mlm.compensacion.prosefi.CalculaComisionMensual(oConn, 1, false);
         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(4) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }

      }
      // </editor-fold>

      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones CASA JOSEFA">
      if (strid.equals("38")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         System.out.println("comision Casa Josefa...");
         com.mx.siweb.mlm.compensacion.casajosefa.CalculoComision comis = new com.mx.siweb.mlm.compensacion.casajosefa.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  //System.out.println("Concluyeron las comisiones....");
               } else {
                  //System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               //System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            //System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>

      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones XocoBenefit">
      if (strid.equals("40")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.xocobenefit.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.xocobenefit.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  System.out.println("Concluyeron las comisiones....");
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>

      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones Moriah Vasti">
      if (strid.equals("42")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.moriahvasti.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.moriahvasti.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones We Now">
      if (strid.equals("44")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.wenow.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.wenow.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.doFase1();
         comis.setEsCorridaDefinitiva(booDefinitivas);
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones Klensy">
      if (strid.equals("46")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.klensy.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.klensy.CalculoComision(oConn, intPeriodo, booDefinitivas);

         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones Klensy">
      if (strid.equals("46")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.klensy.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.klensy.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.setEsCorridaDefinitiva(booDefinitivas);
         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones Epoints">
      if (strid.equals("47")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.epoints.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.epoints.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.setEsCorridaDefinitiva(booDefinitivas);
         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones Capitalia">
      if (strid.equals("48")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("DEFINITIVAS") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("DEFINITIVAS"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.capitalia.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.capitalia.CalculoComision(oConn, 1, false);
         comis.setEsCorridaDefinitiva(booDefinitivas);
         comis.doFase1();
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
      }
      // </editor-fold>

      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones mensuales GoOnLife">
      if (strid.equals("49")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intPeriodoSemanal = 0;
         if (request.getParameter("MSE_ID") != null) {
            try {
               intPeriodoSemanal = Integer.valueOf(request.getParameter("MSE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("MPE_TIPOBON") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("MPE_TIPOBON"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         //Objeto para la corrida
         com.mx.siweb.mlm.compensacion.goonlife.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.goonlife.CalculoComision(oConn, intPeriodo, false);
         System.out.println("intDefinitivas " + intDefinitivas);
         if (intDefinitivas == 3) {
            System.out.println("Comisiones semanales goGonLife");
            comis.doComisionSemanal(intPeriodoSemanal);
            if (comis.getStrResultLast().equals("OK")) {
               out.println("Proceso terminado exitosamente....");//Pintamos el resultado
            } else {
               out.println(comis.getStrResultLast());//Pintamos el resultado
            }
         } else {
            System.out.println("Comisiones mensuales goGonLife");
            comis.setEsCorridaDefinitiva(booDefinitivas);
            comis.doFase1();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase2();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase3();
                  if (comis.getStrResultLast().equals("OK")) {
                     comis.doFase4();
                     if (comis.getStrResultLast().equals("OK")) {
                        System.out.println("Concluyeron las comisiones....");
                     } else {
                        System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                     }
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
            }
            if (comis.getStrResultLast().equals("OK")) {
               out.println("Proceso terminado exitosamente....");//Pintamos el resultado
            } else {
               out.println(comis.getStrResultLast());//Pintamos el resultado
            }
         }

      }
      // </editor-fold>
      // <editor-fold defaultstate="collapsed" desc="Calculo de comisiones mensuales Prosperidad">
      if (strid.equals("52")) {
         int intPeriodo = 0;
         if (request.getParameter("MPE_ID") != null) {
            try {
               intPeriodo = Integer.valueOf(request.getParameter("MPE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intPeriodoSemanal = 0;
         if (request.getParameter("MSE_ID") != null) {
            try {
               intPeriodoSemanal = Integer.valueOf(request.getParameter("MSE_ID"));
            } catch (NumberFormatException ex) {
            }
         }
         int intDefinitivas = 0;
         if (request.getParameter("MPE_TIPOBON") != null) {
            try {
               intDefinitivas = Integer.valueOf(request.getParameter("MPE_TIPOBON"));
            } catch (NumberFormatException ex) {
            }
         }
         boolean booDefinitivas = false;
         if (intDefinitivas == 1) {
            booDefinitivas = true;
         }
         com.mx.siweb.mlm.compensacion.prosperidad.CalculoComision comis
            = new com.mx.siweb.mlm.compensacion.prosperidad.CalculoComision(oConn, intPeriodo, booDefinitivas);
         comis.setIntIdPeriodoSemanal(intPeriodoSemanal);
         comis.doFase1();
         System.out.println("Resultado de fases " + comis.getStrResultLast());
         if (comis.getStrResultLast().equals("OK")) {
            comis.doFase2();
            if (comis.getStrResultLast().equals("OK")) {
               comis.doFase3();
               if (comis.getStrResultLast().equals("OK")) {
                  comis.doFase4();
                  if (comis.getStrResultLast().equals("OK")) {
                     System.out.println("Concluyeron las comisiones....");
                  } else {
                     System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
                  }
               } else {
                  System.out.println("ERROR AL CALCULAR COMISIONES(3) : " + comis.getStrResultLast());
               }
            } else {
               System.out.println("ERROR AL CALCULAR COMISIONES (2): " + comis.getStrResultLast());
            }
         } else {
            System.out.println("ERROR AL CALCULAR COMISIONES(1): " + comis.getStrResultLast());
         }
         if (comis.getStrResultLast().equals("OK")) {
            out.println("Proceso terminado exitosamente....");//Pintamos el resultado
         } else {
            out.println(comis.getStrResultLast());//Pintamos el resultado
         }
      }
      // </editor-fold>

   } else //Validamos si se acabo la sesion del usuario
    if (varSesiones.getIntNoUser() == 0) {
         String strid = request.getParameter("ID");
         if (strid == null) {
            strid = "0";
         }
         if (!strid.equals("0")) {
            out.clearBuffer();//Limpiamos buffer
            if (strid.equals("2") || strid.equals("4") || strid.equals("5")) {
               //respuesta en xml
               String strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
               strXML += "<ERROR>" + "";
               strXML += "<msg>LOST_SESSION</msg>";
               strXML += "<ERROR>";
               atrJSP.atrJSP(request, response, true, true);//Definimos atributos para el XML
               out.println(strXML);//Pintamos el resultado
            } else {
               //respuesta en txt
               atrJSP.atrJSP(request, response, true, false);//Definimos atributos para el XML
               out.println("LOST_SESSION");//Pintamos el resultado
            }
         }
      }
   oConn.close();
%>