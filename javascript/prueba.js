//////Evaluamos  compatibilidad java
////var version = java.lang.System.getProperty("java.version");
////if (version.startsWith("1.8.0")) {
////    load("nashorn:mozilla_compat.js");
////}
//////VALIDA SI EXISTE EL CURSO Y GERENA SU HISTORICO
////var bolExiste = false;
////var idMaster = 0;
////var cursoOld = "";
////var cursoNew = "";
////var hora = Fecha.getHoraActual();
////var fecha = Fecha.getFechaActual();
////var usr = tabla.getVarSesiones().getIntNoUser();
////var strSql = "select * from cofide_catalogo_curso where CCU_ID_M = " + tabla.getFieldString("CCU_ID_M") + " ;";
////Rs = oConn.runQuery(strSql, true);
////try {
////    while (Rs.next()) {
////        if (tabla.getFieldString("CCU_CURSO") != Rs.getString("CCU_CURSO")) {
////            idMaster = Rs.getInt("CCU_ID_M");
////            cursoOld = Rs.getString("CCU_CURSO");
////            cursoNew = tabla.getFieldString("CCU_CURSO");
////            Clave = Rs.getString("CCU_CLAVE");
////            var SqlAdd = "INSERT INTO cofide_catalogo_curso_deta (CCU_ID_M, CUD_CURSO, CUD_CLAVE, CUD_CURSO_OLD, CUD_HORA, CUD_FECHA, CUD_USUARIO) VALUES " +
////                    "(" + idMaster + ", '" + cursoNew + "','" + Clave + "', '" + cursoOld + "', '" + hora + "', '" + fecha + "', " + usr + "); ";
////            oConn.runQueryLMD(SqlAdd);
////        }
////    }
////    Rs.close();
////} catch (err) {
////    var txt = "There was an error on this page.";
////    txt += "Error description: " + err.description + " ";
////    txt += "Click OK to continue5.";
////    print(txt);
////}
//
////Evaluamos  compatibilidad java
//var version = java.lang.System.getProperty("java.version");
//if (version.startsWith("1.8.0")) {
//    load("nashorn:mozilla_compat.js");
//}
////VALIDA SI EXISTE EL GIRO Y GENERA SU HISTORICO
//var bolExiste = false;
//var idMaster = 0;
//var giroOld = "";
//var giroNew = "";
//var hora = Fecha.getHoraActual();
//var fecha = Fecha.getFechaActual();
//var usr = tabla.getVarSesiones().getIntNoUser();
//var strSql = "select * from cofide_giro where CG_ID_M = " + tabla.getFieldString("CG_ID_M") + " ;";
//Rs = oConn.runQuery(strSql, true);
//try {
//    while (Rs.next()) {
//            if (tabla.getFieldString("CG_GIRO") != Rs.getString("CG_GIRO")) {
//                idMaster = Rs.getInt("CG_ID_M");
//                giroOld = Rs.getString("CG_GIRO");
//                giroNew = tabla.getFieldString("CG_GIRO");
//                var SqlAdd = "INSERT INTO cofide_giro_deta (CG_ID_M, CGD_GIRO, CGD_GIRO_OLD, CGD_HORA, CGD_FECHA, CGD_USUARIO) VALUES " +
//                        "(" + idMaster + ", '" + giroNew + "', '" + giroOld + "', '" + hora + "', '" + fecha + "', " + usr + "); ";
//                oConn.runQueryLMD(SqlAdd);
//            }
//    }
//    Rs.close();
//} catch (err) {
//    var txt = "There was an error on this page.";
//    txt += "Error description: " + err.description + " ";
//    txt += "Click OK to continue5.";
//    print(txt);
//}

////Evaluamos  compatibilidad java
//var version = java.lang.System.getProperty("java.version");
//if (version.startsWith("1.8.0")) {
//    load("nashorn:mozilla_compat.js");
//}
////VALIDA SI EXISTE EL ARE Y GENERA SU HISTORICO
//var bolExiste = false;
//var idMaster = 0;
//var areaOld = "";
//var areaNew = "";
//var hora = Fecha.getHoraActual();
//var fecha = Fecha.getFechaActual();
//var usr = tabla.getVarSesiones().getIntNoUser();
//var strSql = "select * from cofide_segmento where CS_ID_M = " + tabla.getFieldString("CS_ID_M") + " ;";
//Rs = oConn.runQuery(strSql, true);
//try {
//    while (Rs.next()) {
//        if (tabla.getFieldString("CS_AREA") != Rs.getString("CS_AREA")) {
//            idMaster = Rs.getInt("CS_ID_M");
//            areaOld = Rs.getString("CS_AREA");
//            areaNew = tabla.getFieldString("CS_AREA");
//            var SqlAdd = "INSERT INTO cofide_segmento_deta (CS_ID_M, CSD_AREA, CSD_AREA_OLD, CSD_HORA, CSD_FECHA, CSD_USUARIO) VALUES " +
//                    "(" + idMaster + ", '" + areaNew + "', '" + areaOld + "', '" + hora + "', '" + fecha + "', " + usr + "); ";
//            oConn.runQueryLMD(SqlAdd);
//        }
//    }
//    Rs.close();
//} catch (err) {
//    var txt = "There was an error on this page.";
//    txt += "Error description: " + err.description + " ";
//    txt += "Click OK to continue5.";
//    print(txt);
//}