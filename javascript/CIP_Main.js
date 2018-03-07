var _objSc = null;
function _GridProp() {
    this.lstselRows = new Array();
    this.idxSelRows = 0;
    this.getLastId = function getLastId(id) {
        return this.lstselRows[id];
    };
    this.AddGrid = function AddGrid() {
        this.idxSelRows++;
        return this.idxSelRows;
    };
    this.ClearGrid = function ClearGrid() {
        this.idxSelRows = 0;
        this.lstselRows = [];
        this.lstselRows.length = 0;
    };
}
function _Screen(opt, atr, dialog, cleanPanelRight, bolMain) {
    this.lstCmd = null;
    this.bolUsoGRID = false;
    this.uXmlAct = null;
    this.opnOperAct = "";
    this.strNameAct = opt;
    this.opnOptAct = opt;
    this.dialog = dialog;
    this.atr = atr;
    this.cleanPanelRight = cleanPanelRight;
    this.objGrid = new _GridProp();
    this.bolActivo = false;
    this.bolMain = bolMain;
    this.bolInit = false;
    this.objDataEdit = null;
    this.getDataAuto = true;
    this.idOperAct = 0;
    if (this.cleanPanelRight == null || this.cleanPanelRight == "undefined") {
        this.cleanPanelRight = true;
    }
    if (this.atr == null || this.atr == "undefined") {
        this.atr = "_ed";
    }
    this.initHotKeys = false;
    this.fUp = null;
    this.fDw = null;
    this.fNew = null;
    this.fEd = null;
    this.fDel = null;
    this.fFind = null;
    this.fPrint = null;
    this.fImport = null;
    this.fOk = null;
    this.fEsc = null;
    this.lstData = null;
    this.countTimeLoadJs = -1;
    this.dataPrint = null;
    this.withoutButtons = false;
    this.Draw = function Draw() {
        this.dataPrint = null;
        if (this.bolActivo == true) {
            if (this.dialog != null && this.dialog != "undefined") {
                $("#" + this.dialog).dialog("open");
            }
        } else {
            this.bolActivo = true;
            var objMe = this;
            if (this.bolInit) {
                if (objMe.cleanPanelRight) {
                    document.getElementById("rightPanel").innerHTML = "&nbsp;";
                }
                if (objMe.atr == "_ed") {
                    if (objMe.bolUsoGRID) {
                        objMe.CleanShortCuts();
                        objMe.bolUsoGRID = false;
                    }
                    MakeForm(objMe.uXmlAct, objMe.dialog, objMe);
                }
                if (objMe.atr == "grid") {
                    objMe.openOptGRID();
                    objMe.CreateShortCuts();
                }
            } else {
                $("#dialogWait").dialog("open");
                $.ajax({scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", url: URLScreen + "?Opt=" + this.opnOptAct + "&atr=" + this.atr, dataType: "xml", success: function (datos) {
                        objMe.bolInit = true;
                        if (objMe.cleanPanelRight) {
                            document.getElementById("rightPanel").innerHTML = "&nbsp;";
                        }
                        objMe.uXmlAct = datos;
                        objMe.LoadJs(objMe);
                    }, error: function (objeto, quepaso, otroobj) {}});
            }
        }
    };
    this.LoadJs = function LoadJs(objMe) {
        this.countTimeLoadJs++;
        var _objscCM = objMe.uXmlAct.getElementsByTagName("Screen")[0];
        var strfrm_libscript = _objscCM.getAttribute("frm_libscript");
        if (strfrm_libscript != "") {
            var strScript = "if(" + strfrm_libscript.replace(".js", "").replace("javascript/", "") + "){return true}else{return false}";
            var strFn = new Function(strScript);
            try {
                if (strFn()) {
                    try {
                        this.LoadScreen(objMe);
                    } catch (err) {
                        var txt = "There was an error when try to draw form.\n\n";
                        txt += "Error description: " + err + " \n\n";
                        txt += "Click OK to continue.\n\n";
                        alert(txt);
                    }
                }
            } catch (err) {
                if (this.countTimeLoadJs == 0) {
                    importa(strfrm_libscript);
                }
                var delay = 1;
                _objSc = objMe;
                setTimeout("_objSc.LoadJs(_objSc);", delay * 1000);
            }
        } else {
            this.LoadScreen(objMe);
        }
    };
    this.LoadScreen = function LoadScreen(objMe) {
        if (objMe == null) {
            objMe = _objSc;
        }
        if (objMe.atr == "_ed") {
            if (objMe.bolUsoGRID) {
                objMe.CleanShortCuts();
                objMe.bolUsoGRID = false;
            }
            MakeForm(objMe.uXmlAct, objMe.dialog, objMe);
        }
        if (objMe.atr == "grid") {
            objMe.openOptGRID();
            objMe.CreateShortCuts();
        }
        $("#dialogWait").dialog("close");
    };
    this.openOptGRID = function openOptGRID() {
        this.dataPrint = null;
        this.bolUsoGRID = true;
        var div = document.getElementById("MainPanel");
        var divRight = document.getElementById("rightPanel");
        if (this.dialog != null && this.dialog != "undefined") {
            var strHtmlDiv = "<table border='0'>";
            strHtmlDiv += '<tr><td><div  id="' + this.dialog + 'rightPanel" class="dialogCterRightPanel"></div></td></tr>';
            strHtmlDiv += '<tr><td><div  id="' + this.dialog + 'MainPanel"></div></td></tr>';
            strHtmlDiv += "</table>";
            document.getElementById(this.dialog + "_inside").innerHTML = strHtmlDiv;
            div = document.getElementById(this.dialog + "MainPanel");
            divRight = document.getElementById(this.dialog + "rightPanel");
        }
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var strtitle = _objscCM.getAttribute("frm_title");
        var strScript = _objscCM.getAttribute("frm_script");
        var strjavascript = _objscCM.getAttribute("frm_javascript");
        var strTitleButton = _objscCM.getAttribute("frm_titleButton");
        var strfrm_scriptCancel = _objscCM.getAttribute("frm_scriptCancel");
        var strfrm_urlgrid = _objscCM.getAttribute("frm_urlgrid");
        var strfrm_orden = _objscCM.getAttribute("frm_orden");
        var strfrm_urlNew = _objscCM.getAttribute("frm_urlNew");
        var strfrm_url_import = _objscCM.getAttribute("frm_url_import");
        var strfrm_urlEd = _objscCM.getAttribute("frm_urlEd");
        var strfrm_urlDel = _objscCM.getAttribute("frm_urlDel");
        var strfrm_urlDataPrint = _objscCM.getAttribute("frm_urlDataPrint");
        var strfrm_tipoorden = _objscCM.getAttribute("frm_tipoorden");
        var strfrm_scriptOpenDialog = _objscCM.getAttribute("frm_scriptOpenDialog");
        var strfrm_scriptCloseDialog = _objscCM.getAttribute("frm_scriptCloseDialog");
        var strfrm_scriptdblClickGrid = _objscCM.getAttribute("frm_scriptdblClickGrid");
        var strfrm_ongridComplete = _objscCM.getAttribute("frm_ongridComplete");
        var strfrm_ongridSelRow = _objscCM.getAttribute("frm_ongridSelRow");
        var strfrm_ongridSelectAll = _objscCM.getAttribute("frm_ongridSelectAll");
        var strfrm_ongridRightClickRow = _objscCM.getAttribute("frm_ongridRightClickRow");
        var intfrm_gridscroll = _objscCM.getAttribute("frm_gridscroll");
        var intfrm_gridrows = _objscCM.getAttribute("frm_gridrows");
        var intfrm_multikey = _objscCM.getAttribute("frm_multikey");
        var intfrm_grid_width = _objscCM.getAttribute("frm_grid_width");
        var intfrm_grid_height = _objscCM.getAttribute("frm_grid_height");
        var intfrm_IdMaster_2 = _objscCM.getAttribute("frm_id");
        var bolMultiKey = false;
        if (intfrm_multikey == 1) {
            bolMultiKey = true;
        }
        if (strTitleButton == "") {
            strTitleButton = "Procesar";
        }
        var _fdblClick = null;
        if (this.dialog != null && this.dialog != "undefined") {
            $("#" + this.dialog).dialog("option", "title", strtitle);
            if (strfrm_scriptOpenDialog.length > 0) {
                var _fOpen = new Function(strfrm_scriptOpenDialog);
                $("#" + this.dialog).bind("dialogopen", _fOpen);
            }
            if (strfrm_scriptCloseDialog.length > 0) {
                var _fClose = new Function("event", "ui", strfrm_scriptCloseDialog);
                $("#" + this.dialog).bind("dialogclose", _fClose);
            }
        }
        if (strfrm_scriptdblClickGrid.length > 0) {
            _fdblClick = new Function("id", strfrm_scriptdblClickGrid);
        } else {
            _fdblClick = new Function("id", "OpnEdit(document.getElementById('Ed" + this.strNameAct + "'));");
        }
        div.innerHTML = "<div id='tabsOpt" + this.strNameAct + "'>" + "<ul>" + "	<li><a href='#tabsOpt" + this.strNameAct + "-1'>" + strtitle + "</a></li>" + "	<li><a href='#tabsOpt" + this.strNameAct + "-2'><div id='VerDeta" + this.strNameAct + "'>&nbsp;...</div></a></li>" + "</ul>" + "<div id='tabsOpt" + this.strNameAct + "-1'>" + "<table id='" + this.strNameAct + "' class='scroll' ></table>" + "<div id='pager" + this.strNameAct + "' class='scroll' cellpadding='0' cellspacing='0' style='text-align:center;height:10%;'>&nbsp;</div>" + "</div>" + "<div id='tabsOpt" + this.strNameAct + "-2'><div id='screenOpt" + this.strNameAct + "'></div>" + "</div>" + "</div>";
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        var arrcolNames = new Array();
        var arrcolModel = new Array();
        var intNames = -1;
        for (var i = 0; i < _ctrlCM.length; i++) {
            var obj = _ctrlCM[i];
            if (obj.getAttribute("frmd_consulta") == "1") {
                var intfrmd_search = obj.getAttribute("frmd_search");
                var bolsearch = false;
                if (intfrmd_search == 1) {
                    bolsearch = true;
                }
                var bolHidden = false;
                intNames++;
                arrcolNames[intNames] = obj.getAttribute("frmd_titulo");
                if (obj.getAttribute("frmd_tipo") == "hidden") {
                    bolHidden = true;
                }
                var dblAncho = obj.getAttribute("frmd_ancho");
                if (dblAncho == 0) {
                    dblAncho = 40;
                }
                if (obj.getAttribute("frmd_val_num") == 1 && obj.getAttribute("frmd_dato") == "double") {
                    dblAncho = dblAncho * 3;
                    arrcolModel[intNames] = {name: obj.getAttribute("frmd_nombre"), index: obj.getAttribute("frmd_nombre"), width: dblAncho, edittype: "text", formatter: "number", sortable: bolsearch, search: bolsearch, hidden: bolHidden, align: "right"};
                } else {
                    if (obj.getAttribute("frmd_tipo") == "select" || obj.getAttribute("frmd_tipo") == "radio" || obj.getAttribute("frmd_tipo") == "PanelRadio") {
                        var strLst = ":SELECCIONE;";
                        var elements;
                        if (obj.getAttribute("frmd_tipo") == "select") {
                            elements = obj.getElementsByTagName("element");
                            for (var k = 0; k < elements.length; k++) {
                                var obj2 = elements[k];
                                var strPComa = "";
                                if (k + 1 < elements.length) {
                                    strPComa = ";";
                                }
                                strLst += obj2.getAttribute("send") + ":" + obj2.getAttribute("show") + strPComa;
                            }
                        } else {
                            if (obj.getAttribute("frmd_tipo") == "PanelRadio") {
                                elements = obj.getElementsByTagName("element");
                                for (var k = 0; k < elements.length; k++) {
                                    var obj2 = elements[k];
                                    var strPComa = "";
                                    if (k + 1 < elements.length) {
                                        strPComa = ";";
                                    }
                                    strLst += obj2.getAttribute("send") + ":" + obj2.getAttribute("show") + strPComa;
                                }
                            } else {
                                strLst = "999:SELECCIONE;0:N0;1:SI";
                            }
                        }
                        dblAncho = dblAncho * 2;
                        arrcolModel[intNames] = {name: obj.getAttribute("frmd_nombre"), index: obj.getAttribute("frmd_nombre"), width: dblAncho, hidden: bolHidden, align: "left", sortable: bolsearch, search: bolsearch, searchoptions: {value: strLst}, stype: "select"};
                    } else {
                        dblAncho = dblAncho * 2;
                        arrcolModel[intNames] = {name: obj.getAttribute("frmd_nombre"), index: obj.getAttribute("frmd_nombre"), width: dblAncho, hidden: bolHidden, align: "left", sortable: bolsearch, search: bolsearch};
                    }
                }
            }
        }
        try {
            $("#tabsOpt" + this.strNameAct).tabs({show: {effect: "slide", duration: 800}});
            $("#tabsOpt" + this.strNameAct).tabs("option", "active", 0);
            $("#tabsOpt" + this.strNameAct).tabs("disable", 1);
        } catch (error) {
            alert("tabs..." + error);
        }
        try {
            _DefineGrid(false, this.strNameAct, strfrm_urlgrid, this.opnOptAct, intfrm_gridscroll, arrcolNames, arrcolModel, strfrm_orden, strfrm_tipoorden, strtitle, _fdblClick, strfrm_ongridSelRow, "", strfrm_ongridComplete, "", strfrm_ongridRightClickRow, strfrm_ongridSelectAll, "", 0, intfrm_gridrows, bolMultiKey, intfrm_grid_width, intfrm_grid_height);
        } catch (error) {
            alert("grid." + error);
        }
        this.lstCmd = new Array();
        var intCount = -1;
        intCount++;
        this.lstCmd[intCount] = {enabled: false, name: "OK" + this.strNameAct, IsOK: true, IsCANCEL: false, UseOKCANCEL: false};
        intCount++;
        this.lstCmd[intCount] = {enabled: false, name: "CANCEL" + this.strNameAct, IsOK: false, IsCANCEL: true, UseOKCANCEL: false};
        var strTemplate = "<div id=\"toolbar-apply\" class=\"btn-group\"><button  class='btn_menu_enabled ui-state-disabled' id='[01]' onClick='[02]' [03]>[04]</button></div>";
        var strTemplateOKCancel = "<div id=\"toolbar-apply\" class=\"btn-group\"><button  class='btn_menu_enabled ui-state-disabled' id='[01]' onClick='[02]' [03]>[04]</button></div>";
        var strTemplate2 = "<div id=\"toolbar-apply\" class=\"btn-group\"><button class='btn_menu_disabled ui-state-default' id='[01]' onClick='[02]' [03]>[04]</button></div>";
        var strHtmlRight = "";
        strHtmlRight = '<div id="toolbar" class="btn-toolbar">';
        strHtmlRight += "";
        if (trim(strfrm_urlNew) != "") {
            intCount++;
            this.lstCmd[intCount] = {enabled: true, name: "New" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: true};
            strHtmlRight += strTemplate2.replace("[01]", "New" + this.strNameAct).replace("[02]", "OpnNew(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-plus'>&nbsp;<span class='menu_btn_main'>Nuevo</span></i>");
        }
        if (trim(strfrm_urlEd) != "") {
            intCount++;
            this.lstCmd[intCount] = {enabled: true, name: "Ed" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: true};
            strHtmlRight += strTemplate2.replace("[01]", "Ed" + this.strNameAct).replace("[02]", "OpnEdit(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-pencil'>&nbsp;<span class='menu_btn_main'>Editar</span></i>");
        }
        if (trim(strfrm_urlDel) != "") {
            intCount++;
            this.lstCmd[intCount] = {enabled: true, name: "Del" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: true};
            strHtmlRight += strTemplate2.replace("[01]", "Del" + this.strNameAct).replace("[02]", "OpnDel(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-remove'>&nbsp;<span class='menu_btn_main'>Borrar</span></i>");
        }
        if (trim(strfrm_urlDataPrint) != "") {
            intCount++;
            this.lstCmd[intCount] = {enabled: true, name: "Print" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: false};
            strHtmlRight += strTemplate2.replace("[01]", "Print" + this.strNameAct).replace("[02]", "OpnPrint(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-print'>&nbsp;<span class='menu_btn_main'>Imprimir</span></i>");
        }
        if (trim(strfrm_url_import) != "") {
            intCount++;
            this.lstCmd[intCount] = {enabled: true, name: "Importa" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: true};
            strHtmlRight += strTemplate2.replace("[01]", "Importa" + this.strNameAct).replace("[02]", "OpnImporta(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-file-excel-o'>&nbsp;<span class='menu_btn_main'>Importar</span></i>");
        }
        intCount++;
        this.lstCmd[intCount] = {enabled: true, name: "Filter" + this.strNameAct, IsOK: false, IsCANCEL: false, UseOKCANCEL: false};
        strHtmlRight += strTemplate2.replace("[01]", "Filter" + this.strNameAct).replace("[02]", "OpnFilter(this)").replace("[03]", "").replace("[04]", "<i class='fa fa-search'>&nbsp;<span class='menu_btn_main'>Filtrar</span></i>");
        var Menu = _objscCM.getElementsByTagName("Menu");
        if (Menu != null) {
            for (i = 0; i < Menu.length; i++) {
                obj = Menu[i];
                var Mtitle = obj.getAttribute("frmn_titulo");
                var Mlink = obj.getAttribute("frmn_link");
                var Micon = obj.getAttribute("frmn_icon");
                var Midtitle = obj.getAttribute("frmn_idtitle");
                var Menabled = obj.getAttribute("fmrn_enabled");
                if (Menabled == 1) {
                    strHtmlRight += strTemplate2.replace("[01]", Midtitle).replace("[02]", Mlink).replace("[03]", "").replace("[04]", "<i class='" + Micon + "'>&nbsp;<span class='menu_btn_main'>" + Mtitle + "</span></i>");
                } else {
                    strHtmlRight += strTemplate.replace("[01]", Midtitle).replace("[02]", Mlink).replace("[03]", " disabled ").replace("[04]", "<i class='" + Micon + "'>&nbsp;<span class='menu_btn_main'>" + Mtitle + "</span></i>");
                }
            }
        }
        strHtmlRight += "";
        strHtmlRight += strTemplateOKCancel.replace("[01]", "OK" + this.strNameAct).replace("[02]", "OpnOK(this)").replace("[03]", "disabled").replace("[04]", "<i class='fa fa-save'>&nbsp;<span class='menu_btn_main'>Guardar</span></i>");
        strHtmlRight += strTemplateOKCancel.replace("[01]", "CANCEL" + this.strNameAct).replace("[02]", "OpnCANCEL(this)").replace("[03]", "disabled").replace("[04]", "<i class='fa fa-reply'>&nbsp;<span class='menu_btn_main'>Cancelar</span></i>");
        strHtmlRight += "";
        //strHtmlRight += '&nbsp<div id="toolbar-apply" class="btn-group">' + "<button  class='btn_menu_disabled ui-state-default' id='HelpFastBtnW'" + intfrm_IdMaster_2 + "' onClick='ShowHelpFastBtn(" + intfrm_IdMaster_2 + ")' ><i class='fa fa-life-ring'><span class='menu_btn_main'>Ayuda</span></i></button> " + "<div>";
        strHtmlRight += "</div>";
        divRight.innerHTML = strHtmlRight;
        if (this.dialog != null) {
            $("#" + this.dialog).dialog("open");
        }
    };
    this.CleanShortCuts = function CleanShortCuts() {
        if (this.bolMain) {
            var fUp = this.fUp;
            var fDw = this.fDw;
            var fNew = this.fNew;
            var fEd = this.fEd;
            var fDel = this.fDel;
            var fFind = this.fFind;
            var fPrint = this.fPrint;
            var fImport = this.fImport;
            var fOk = this.fOk;
            var fEsc = this.fEsc;
        }
    };
    this.fInitHotKeys = function fInitHotKeys() {
        this.initHotKeys = true;
        var strFUp = "callUpGrid('" + this.strNameAct + "');" + " return false;";
        this.fUp = new Function(strFUp);
        var strFDw = "callDownGrid('" + this.strNameAct + "');" + " return false;";
        this.fDw = new Function(strFDw);
        var strFDNew = "OpnNew(document.getElementById('New" + this.strNameAct + "'));";
        this.fNew = new Function(strFDNew);
        var strfEd = "OpnEdit(document.getElementById('Ed" + this.strNameAct + "'));";
        this.fEd = new Function(strfEd);
        var strfDel = "OpnDel(document.getElementById('Del" + this.strNameAct + "'));";
        this.fDel = new Function(strfDel);
        var strfFilter = "OpnFilter(document.getElementById('Filter" + this.strNameAct + "'));";
        this.fFind = new Function(strfFilter);
        var strfPrint = "OpnPrint(document.getElementById('Print" + this.strNameAct + "'));";
        this.fPrint = new Function(strfPrint);
        var strfImport = "OpnImporta(document.getElementById('Importa" + this.strNameAct + "'));";
        this.fImport = new Function(strfImport);
        var strfOK = "OpnOK(document.getElementById('OK" + this.strNameAct + "'));";
        this.fOk = new Function(strfOK);
        var strfCANCEL = "OpnCANCEL(document.getElementById('CANCEL" + this.strNameAct + "'));";
        this.fEsc = new Function(strfCANCEL);
    };
    this.CreateShortCuts = function CreateShortCuts() {
        if (this.bolMain) {
            if (!this.initHotKeys) {
                this.fInitHotKeys();
            }
            var fUp = this.fUp;
            var fDw = this.fDw;
            var fNew = this.fNew;
            var fEd = this.fEd;
            var fDel = this.fDel;
            var fFind = this.fFind;
            var fPrint = this.fPrint;
            var fOk = this.fOk;
            var fEsc = this.fEsc;
        }
    };
    this.EnviaForm = function EnviaForm(formName, script, strNameForms, strTypeForms, strTipoReport) {
        if (this.OpnValida()) {
            var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
            var d = document;
            var bolUsaAjax = true;
            if (_objscCM.getAttribute("frm_usaAjax") == 0) {
                if (d.getElementById("XLS1") != null && d.getElementById("XLS1") != undefined) {
                    bolUsaAjax = !d.getElementById("XLS1").checked;
                } else {
                    bolUsaAjax = false;
                }
            }
            if (_objscCM.getAttribute("frm_esreporte") == 1) {
                if (strTipoReport == "XLS" || strTipoReport == "PDF") {
                    bolUsaAjax = false;
                }
                script += "&report=" + strTipoReport;
            }
            if (bolUsaAjax) {
                var str = (ObtenData(strNameForms, strTypeForms));
                $("#dialogWait").dialog("open");
                var objMe = this;
                $.ajax({type: "POST", data: str + "&opnOpt=" + this.opnOptAct, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: script, success: function (datos) {
                        $("#dialogWait").dialog("close");
                        var strHtml = "<div id='form' class='tabla'>";
                        strHtml += "<div class='form_head' id='head'>" + datos + "</div>";
                        strHtml += "</div>";
                        strHtml += "</div>";
                        if (objMe.bolMain) {
                            d.getElementById("MainPanel").innerHTML = strHtml;
                        }
                        objMe.opnOptAct = "";
                    }, error: function (objeto, quepaso, otroobj) {}});
            } else {
                var form = d.getElementById("form1");
                form.action = script;
                if (strTipoReport == "PDF") {
                    form.target = "_blank";
                }
                if (strTipoReport == "XLS") {
                    form.target = "_blank";
                }
                form.submit();
            }
        }
    };
    this.OpnValida = function OpnValida() {
        var bolValido = true;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        for (var i = 0; i < _ctrlCM.length; i++) {
            var obj = _ctrlCM[i];
            var SeValida = false;
            if (this.opnOperAct == "_new" && obj.getAttribute("frmd_nuevo") == 1) {
                SeValida = true;
            }
            if (this.opnOperAct == "_ed" && obj.getAttribute("frmd_modif") == 1) {
                SeValida = true;
            }
            if (this.opnOperAct == "_importa" && obj.getAttribute("frmd_importa") == 1) {
                SeValida = true;
            }
            if (this.opnOperAct == "" && obj.getAttribute("frmd_modif") == 1) {
                SeValida = true;
            }
            if (SeValida == true) {
                if (obj.getAttribute("frmd_tipo") != "radio") {
                    var objDivErr = document.getElementById("err_" + obj.getAttribute("frmd_nombre"));
                    if (objDivErr != null) {
                        objDivErr.innerHTML = "";
                        objDivErr.setAttribute("class", "");
                        objDivErr.setAttribute("className", "");
                    }
                    var objInput = document.getElementById(obj.getAttribute("frmd_nombre"));
                    if (obj.getAttribute("frmd_obligatorio") == 1 && objInput.parentNode.parentNode.style.display != "none") {
                        if (obj.getAttribute("frmd_dato") == "text") {
                            if (objInput.value == "") {
                                bolValido = false;
                                objDivErr.setAttribute("class", "");
                                objDivErr.setAttribute("class", "inError");
                                objDivErr.setAttribute("className", "inError");
                                objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsgVal7 + obj.getAttribute("frmd_titulo");
                                objInput.focus();
                                alert(strMsgVal7 + obj.getAttribute("frmd_titulo"));
                            }
                        } else {
                            if (objInput.value == "" || objInput.value == "0") {
                                if (objInput.value == "") {
                                    objInput.value = "0";
                                }
                                objDivErr.setAttribute("class", "inError");
                                objDivErr.setAttribute("className", "inError");
                                objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsgVal7 + obj.getAttribute("frmd_titulo");
                                bolValido = false;
                                objInput.focus();
                                alert(strMsgVal7 + obj.getAttribute("frmd_titulo"));
                            }
                        }
                    }
                    if (obj.getAttribute("frmd_val_mail") == 1) {
                    }
                    if (obj.getAttribute("frmd_expreg") != "" && objInput.value != "") {
                        var bolExpReg = valExpReg(objInput.value, obj.getAttribute("frmd_expreg"));
                        if (!bolExpReg) {
                            bolValido = false;
                            objDivErr.setAttribute("class", "");
                            objDivErr.setAttribute("class", "inError");
                            objDivErr.setAttribute("className", "inError");
                            objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + obj.getAttribute("frmd_msg_expreg") + obj.getAttribute("frmd_titulo");
                            objInput.focus();
                        }
                    }
                }
            }
        }
        return bolValido;
    };
    this.OpnValidaControl = function OpnValidaControl(strNomControl) {
        var bolValido = true;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        for (var i = 0; i < _ctrlCM.length; i++) {
            var obj = _ctrlCM[i];
            var SeValida = false;
            if (strNomControl == obj.getAttribute("frmd_nombre")) {
                if (this.opnOperAct == "_new" && obj.getAttribute("frmd_nuevo") == 1) {
                    SeValida = true;
                }
                if (this.opnOperAct == "_ed" && obj.getAttribute("frmd_modif") == 1) {
                    SeValida = true;
                }
                if (this.opnOperAct == "" && obj.getAttribute("frmd_modif") == 1) {
                    SeValida = true;
                }
                if (SeValida == true) {
                    if (obj.getAttribute("frmd_tipo") != "radio") {
                        var objDivErr = document.getElementById("err_" + obj.getAttribute("frmd_nombre"));
                        if (objDivErr != null) {
                            objDivErr.innerHTML = "";
                            objDivErr.setAttribute("class", "");
                            objDivErr.setAttribute("className", "");
                        }
                        var objInput = document.getElementById(obj.getAttribute("frmd_nombre"));
                        if (obj.getAttribute("frmd_obligatorio") == 1 && objInput.parentNode.parentNode.style.display != "none") {
                            if (obj.getAttribute("frmd_dato") == "text" || obj.getAttribute("frmd_dato") == "none") {
                                if (objInput.value == "") {
                                    bolValido = false;
                                    objDivErr.setAttribute("class", "");
                                    objDivErr.setAttribute("class", "inError");
                                    objDivErr.setAttribute("className", "inError");
                                    objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsgVal7 + obj.getAttribute("frmd_titulo");
                                    objInput.focus();
                                }
                            } else {
                                if (objInput.value == "" || objInput.value == "0") {
                                    if (objInput.value == "") {
                                        objInput.value = "0";
                                    }
                                    objDivErr.setAttribute("class", "inError");
                                    objDivErr.setAttribute("className", "inError");
                                    objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsgVal7 + obj.getAttribute("frmd_titulo");
                                    bolValido = false;
                                    objInput.focus();
                                }
                            }
                        }
                        if (obj.getAttribute("frmd_val_mail") == 1) {
                        }
                        if (obj.getAttribute("frmd_expreg") != "" && objInput.value != "") {
                            var bolExpReg = valExpReg(objInput.value, obj.getAttribute("frmd_expreg"));
                            if (!bolExpReg) {
                                bolValido = false;
                                objDivErr.setAttribute("class", "");
                                objDivErr.setAttribute("class", "inError");
                                objDivErr.setAttribute("className", "inError");
                                objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + obj.getAttribute("frmd_msg_expreg") + obj.getAttribute("frmd_titulo");
                                objInput.focus();
                            }
                        }
                    }
                }
            }
        }
        return bolValido;
    };
    this.OpnNew = function OpnNew() {
        var bolPasa = true;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        if (_ctrlCM.length == 0) {
            bolPasa = false;
            this.LoadXmlOnly(true, false, false);
        }
        if (bolPasa) {
            this.dataPrint = null;
            this.opnOperAct = "_new";
            this.objDataEdit = null;
            this.idOperAct = 0;
            $("#tabsOpt" + this.strNameAct).tabs("enable", 1);
            $("#tabsOpt" + this.strNameAct).tabs("option", "active", 1);
            $("#tabsOpt" + this.strNameAct).tabs("disable", 0);
            var div = document.getElementById("screenOpt" + this.strNameAct);
            var form1 = new Formulario("", "", this.uXmlAct, div, null, "_new", true, this);
            form1.makeForm();
            _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
            document.getElementById("VerDeta" + this.strNameAct).innerHTML = strTitleAltas + _objscCM.getAttribute("frm_title");
            this.ActiveButtons("New" + this.strNameAct);
        }
    };
    this.ActiveButtons = function ActiveButtons(strName) {
        var clAct = "btn_menu_enabled ui-state-default";
        var clNAct = "btn_menu_disabled ui-state-disabled";
        var obj = null;
        var objOk = null;
        var objCancel = null;
        for (var i = 0; i < this.lstCmd.length; i++) {
            if (this.lstCmd[i].name == strName) {
                obj = this.lstCmd[i];
            }
            if (this.lstCmd[i].name == "OK" + this.strNameAct) {
                objOk = this.lstCmd[i];
            }
            if (this.lstCmd[i].name == "CANCEL" + this.strNameAct) {
                objCancel = this.lstCmd[i];
            }
        }
        if (obj != null) {
            if (obj.IsOK || obj.IsCANCEL) {
                if (objOk != null) {
                    objOk.enabled = false;
                }
                if (objCancel != null) {
                    objCancel.enabled = false;
                }
                for (var j = 0; j < this.lstCmd.length; j++) {
                    if (this.lstCmd[j].name != "OK" + this.strNameAct && this.lstCmd[j].name != "CANCEL" + this.strNameAct) {
                        this.lstCmd[j].enabled = true;
                    }
                }
            } else {
                if (obj.UseOKCANCEL) {
                    if (objOk != null) {
                        objOk.enabled = true;
                    }
                    if (objCancel != null) {
                        objCancel.enabled = true;
                    }
                    for (var k = 0; k < this.lstCmd.length; k++) {
                        if (this.lstCmd[k].name != "OK" + this.strNameAct && this.lstCmd[k].name != "CANCEL" + this.strNameAct) {
                            this.lstCmd[k].enabled = false;
                        }
                    }
                }
            }
            for (var n = 0; n < this.lstCmd.length; n++) {
                var boton = document.getElementById(this.lstCmd[n].name);
                if (this.lstCmd[n].enabled) {
                    boton.disabled = false;
                    boton.className = clAct;
                } else {
                    boton.disabled = true;
                    boton.className = clNAct;
                }
            }
        }
    };
    this.OpnOK = function OpnOK() {
        if (this.opnOperAct == "_new" || this.opnOperAct == "_ed") {
            this.OpnSave();
        }
        if (this.opnOperAct == "_del") {
            this.OpnDelConfirm();
        }
        if (this.opnOperAct == "_importa") {
            this.OpnImportaConfirm();
        }
    };
    this.OpnCANCEL = function OpnCANCEL() {
        $("#tabsOpt" + this.strNameAct).tabs("enable", 0);
        $("#tabsOpt" + this.strNameAct).tabs("option", "active", 0);
        $("#tabsOpt" + this.strNameAct).tabs("disable", 1);
        document.getElementById("VerDeta" + this.strNameAct).innerHTML = "&nbsp;...";
        this.opnOperAct = "";
        document.getElementById("screenOpt" + this.strNameAct).innerHTML = "";
        this.ActiveButtons("CANCEL" + this.strNameAct);
    };
    this.OpnSave = function OpnSave() {
        var bolPasa = true;
        var _objscCMV = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCMV = _objscCMV.getElementsByTagName("ctrl");
        if (_ctrlCMV.length == 0) {
            bolPasa = false;
            this.LoadXmlOnly(false, false, true);
        }
        if (bolPasa) {
            if (this.OpnValida()) {
                var strPost = this.OpnPreparaPOST();
                var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
                var strfrm_urlNew = _objscCM.getAttribute("frm_urlNew");
                var strScript = "";
                if (this.opnOperAct != "_ed") {
                    strScript = _objscCM.getAttribute("frm_scriptEndAlta");
                    strfrm_urlNew = _objscCM.getAttribute("frm_urlNew");
                } else {
                    strScript = _objscCM.getAttribute("frm_scriptEndModi");
                    strfrm_urlNew = _objscCM.getAttribute("frm_urlEd");
                }
                $("#dialogWait").dialog("open");
                var objMe = this;
                $.ajax({type: "POST", data: strPost, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: strfrm_urlNew + "&opnOpt=" + objMe.opnOptAct, success: function (datos) {
                        $("#dialogWait").dialog("close");
                        if (datos.substr(0, 2) == "OK") {
                            objMe.lstData = datos;
                            if (strScript != "") {
                                _objSc = objMe;
                                strScript = strScript.replace("$idDatos", trim(datos));
                                var scriptFinal = new Function(strScript);
                                scriptFinal();
                            } else {
                                objMe.RestoreSave();
                            }
                            this.opnOperAct = "";
                        } else {
                            alert(datos);
                        }
                    }, error: function (objeto, quepaso, otroobj) {}});
            }
        }
    };
    this.RestoreSave = function RestoreSave() {
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var strtitle = _objscCM.getAttribute("frm_title");
        var intfrm_msgalta = _objscCM.getAttribute("frm_msgalta");
        var Tabs = $("#tabsOpt" + this.strNameAct);
        var Dialog = $("#dialog");
        document.getElementById("VerDeta" + this.strNameAct).innerHTML = "&nbsp;...";
        Tabs.tabs("enable", 0);
        Tabs.tabs("option", "active", 0);
        Tabs.tabs("disable", 1);
        if (this.opnOperAct != "_ed" && intfrm_msgalta == 1) {
            document.getElementById("dialog_inside").innerHTML = this.lstData.replace("OK", "");
            Dialog.dialog("option", "title", strtitle);
            Dialog.dialog("open");
        }
        this.opnOperAct = "";
        document.getElementById("screenOpt" + this.strNameAct).innerHTML = "";
        this.ActiveButtons("OK" + this.strNameAct);
        $("#" + this.strNameAct).trigger("reloadGrid");
        this.lstData = null;
    };
    this.OpnPreparaPOST = function OpnPreparaPOST() {
        var strPost = "";
        var intCon = -1;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        for (var i = 0; i < _ctrlCM.length; i++) {
            var obj = _ctrlCM[i];
            var SeEnvia = false;
            var strNombre = obj.getAttribute("frmd_nombre");
            if (this.opnOperAct == "_new" && obj.getAttribute("frmd_nuevo") == 1 && strNombre != "") {
                SeEnvia = true;
            }
            if (this.opnOperAct == "_ed" && obj.getAttribute("frmd_modif") == 1 && strNombre != "") {
                SeEnvia = true;
            }
            if (this.opnOperAct == "_importa" && obj.getAttribute("frmd_importa") == 1 && strNombre != "") {
                SeEnvia = true;
            }
            if (SeEnvia == true) {
                var strValue = "";
                intCon++;
                if (obj.getAttribute("frmd_tipo") != "radio" && obj.getAttribute("frmd_tipo") != "checkbox") {
                    if (obj.getAttribute("frmd_tipo") != "PanelCheck" && obj.getAttribute("frmd_tipo") != "PanelRadio") {
                        if (obj.getAttribute("frmd_mask") != "") {
                            strValue = document.getElementById(strNombre).value;
                            if (Right(strValue, 1) == obj.getAttribute("frmd_separator")) {
                                strValue = Left(strValue, strValue.length - 1);
                            }
                        } else {
                            if (obj.getAttribute("frmd_tipo") != "label") {
                                strValue = document.getElementById(strNombre).value;
                            }
                        }
                    } else {
                        if (obj.getAttribute("frmd_tipo") == "PanelCheck") {
                            for (var y = 0; y < document.getElementById(strNombre + "count").value; y++) {
                                var miobj = document.getElementById(strNombre + y);
                                if (miobj.checked) {
                                    strValue += miobj.value + ",";
                                }
                            }
                        } else {
                            for (var z = 0; z < document.getElementById(strNombre + "count").value; z++) {
                                var miobj2 = document.getElementById(strNombre + z);
                                if (miobj2.checked) {
                                    strValue += miobj2.value;
                                }
                            }
                        }
                    }
                } else {
                    if (obj.getAttribute("frmd_tipo") == "radio") {
                        if (document.getElementById(strNombre + "1").checked) {
                            strValue = "1";
                        } else {
                            strValue = "0";
                        }
                    } else {
                        if (document.getElementById(strNombre).checked) {
                            strValue = "1";
                        } else {
                            strValue = "0";
                        }
                    }
                }
                strValue = encodeURIComponent(strValue);
                if (intCon == 0) {
                    strPost += strNombre + "=" + strValue;
                } else {
                    strPost += "&" + strNombre + "=" + strValue;
                }
            }
        }
        return strPost;
    };
    this.OpnEdit = function OpnEdit() {
        this.dataPrint = null;
        var grid = jQuery("#" + this.strNameAct);
        if (grid.getGridParam("selrow") != null) {
            var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
            var bolPasa = true;
            if (_objscCM.getAttribute("frm_validaAnul") == 1) {
                var rowdata = grid.getRowData(grid.getGridParam("selrow"));
                if (rowdata[_objscCM.getAttribute("frm_campoAnul")] == 1) {
                    bolPasa = false;
                }
            }
            var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
            if (_ctrlCM.length == 0) {
                bolPasa = false;
                this.LoadXmlOnly(false, true, false);
            }
            if (bolPasa) {
                $("#dialogWait").dialog("open");
                this.opnOperAct = "_ed";
                this.getDataAuto = true;
                this.objDataEdit = null;
                this.idOperAct = grid.getGridParam("selrow");
                this.ActiveButtons("Ed" + this.strNameAct);
                $("#tabsOpt" + this.strNameAct).tabs("enable", 1);
                $("#tabsOpt" + this.strNameAct).tabs("option", "active", 1);
                $("#tabsOpt" + this.strNameAct).tabs("disable", 0);
                this.OpngetRowDataOnly(this.idOperAct, true);
            }
        }
    };
    this.LoadXmlOnly = function LoadXmlOnly(bolNew, bolEdit, bolSave) {
        var objMe = this;
        $("#dialogWait").dialog("open");
        $.ajax({scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", url: URLScreen + "?Opt=" + this.opnOptAct + "&atr=" + this.atr, dataType: "xml", success: function (datos) {
                objMe.uXmlAct = datos;
                $("#dialogWait").dialog("close");
                if (bolNew) {
                    objMe.OpnNew();
                } else {
                    if (bolEdit) {
                        objMe.OpnEdit();
                    } else {
                        if (bolSave) {
                            objMe.OpnSave();
                        }
                    }
                }
            }, error: function (objeto, quepaso, otroobj) {}});
    };
    this.OpnFillRowData = function OpnFillRowData(id) {
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        var strfrm_xmlNodoSec = _objscCM.getAttribute("frm_xmlNodoSec");
        var objData = this.objDataEdit;
        var objDataItem = objData.getElementsByTagName(strfrm_xmlNodoSec);
        for (var i = 0; i < _ctrlCM.length; i++) {
            var obj = _ctrlCM[i];
            var ESValido = false;
            if (obj.getAttribute("frmd_modif") == 1 && obj.getAttribute("frmd_nombre") != "" && obj.getAttribute("frmd_tipo") != "label" && obj.getAttribute("frmd_tipo") != "file" && obj.getAttribute("frmd_tipo") != "button") {
                ESValido = true;
            }
            if (ESValido) {
                var strNombre = obj.getAttribute("frmd_nombre");
                try {
                    if (obj.getAttribute("frmd_tipo") != "radio" && obj.getAttribute("frmd_tipo") != "checkbox") {
                        if (obj.getAttribute("frmd_tipo") != "PanelCheck" && obj.getAttribute("frmd_tipo") != "PanelRadio") {
                            if (obj.getAttribute("frmd_tipo") == "htmledit") {
                                $("." + strNombre).jqteVal(objDataItem[0].getAttribute(strNombre));
                            } else {
                                document.getElementById(strNombre).value = objDataItem[0].getAttribute(strNombre);
                            }
                        } else {
                            if (obj.getAttribute("frmd_tipo") == "PanelCheck") {
                                var strfrm_xmlNodoIniP = obj.getAttribute("frmd_xmlNodoIni");
                                var strfrm_xmlNodoSecP = obj.getAttribute("frmd_xmlNodoSec");
                                var Padres = objData.getElementsByTagName(strfrm_xmlNodoIniP)[0];
                                var Hijos = Padres.getElementsByTagName(strfrm_xmlNodoSecP);
                                var Count = document.getElementById(strNombre + "count").value;
                                for (var Y = 0; Y < Hijos.length; Y++) {
                                    for (var H = 0; H < Count; H++) {
                                        if (document.getElementById(strNombre + H).value == Hijos[Y].getAttribute("id")) {
                                            document.getElementById(strNombre + H).checked = true;
                                        }
                                    }
                                }
                            } else {
                                var Count2 = document.getElementById(strNombre + "count").value;
                                for (var H2 = 0; H2 < Count2; H2++) {
                                    if (document.getElementById(strNombre + H2).value == objDataItem[0].getAttribute(strNombre)) {
                                        document.getElementById(strNombre + H2).checked = true;
                                    }
                                }
                            }
                        }
                    } else {
                        if (obj.getAttribute("frmd_tipo") == "radio") {
                            if (objDataItem[0].getAttribute(strNombre) == "1") {
                                document.getElementById(strNombre + "1").checked = true;
                            } else {
                                document.getElementById(strNombre + "2").checked = true;
                            }
                        } else {
                            if (objDataItem[0].getAttribute(strNombre) == "1") {
                                document.getElementById(strNombre).checked = true;
                            } else {
                                document.getElementById(strNombre).checked = false;
                            }
                        }
                    }
                } catch (err) {
                    var txt = "There was an error on this page.\n\n";
                    txt += "Error description: " + err.description + " " + strNombre + "\n\n";
                    txt += "Click OK to continue5.\n\n";
                    alert(txt);
                }
            }
        }
        var strfrm_scriptBegin = _objscCM.getAttribute("frm_scriptBeginModi");
        if (strfrm_scriptBegin != "") {
            var scriptInicial = new Function(strfrm_scriptBegin);
            scriptInicial();
        }
        $("#dialogWait").dialog("close");
    };
    this.OpngetRowDataOnly = function OpngetRowDataOnly(id, bolMakeForm) {
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var strfrm_urlData = _objscCM.getAttribute("frm_urlData");
        var strfrm_key = _objscCM.getAttribute("frm_key");
        var strfrm_xmlNodoIni = _objscCM.getAttribute("frm_xmlNodoIni");
        var strfrm_xmlNodoSec = _objscCM.getAttribute("frm_xmlNodoSec");
        var objMe = this;
        $("#dialogWait").dialog("open");
        $.ajax({type: "POST", data: strfrm_key + "=" + id, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: strfrm_urlData + "&opnOpt=" + objMe.opnOptAct, success: function (datos) {
                var objData = datos.getElementsByTagName(strfrm_xmlNodoIni)[0];
                objMe.objDataEdit = objData;
                if (bolMakeForm) {
                    objMe.OpnDoFormEdit();
                } else {
                    $("#dialogWait").dialog("close");
                }
            }, error: function (err) {
                alert("there was an error with the XML parser\n\nError description: " + err.description + " \n\n");
                OpnCANCEL();
                $("#dialogWait").dialog("close");
            }});
    };
    this.OpnDoFormEdit = function OpnDoFormEdit() {
        var div = document.getElementById("screenOpt" + this.strNameAct);
        var form1 = new Formulario("", "", this.uXmlAct, div, null, "_ed", true, this);
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        form1.bolgetData = true;
        form1.makeForm();
        try {
            document.getElementById("VerDeta" + this.strNameAct).innerHTML = _objscCM.getAttribute("frm_title") + " " + this.idOperAct;
        } catch (err) {
            var txt = "There was an error when try to Edit form(1).\n\n";
            txt += "Error description: " + err.description + " \n\n";
            txt += "Click OK to continue.\n\n";
            alert(txt);
        }
    };
    this.OpngetRowData = function OpngetRowData(id) {
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        var strfrm_urlData = _objscCM.getAttribute("frm_urlData");
        var strfrm_key = _objscCM.getAttribute("frm_key");
        var strfrm_xmlNodoIni = _objscCM.getAttribute("frm_xmlNodoIni");
        var strfrm_xmlNodoSec = _objscCM.getAttribute("frm_xmlNodoSec");
        var objMe = this;
        $("#dialogWait").dialog("open");
        $.ajax({type: "POST", data: strfrm_key + "=" + id, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: strfrm_urlData + "&opnOpt=" + objMe.opnOptAct, success: function (datos) {
                var objData = datos.getElementsByTagName(strfrm_xmlNodoIni)[0];
                var objDataItem = objData.getElementsByTagName(strfrm_xmlNodoSec);
                objMe.objDataEdit = objData;
                for (var i = 0; i < _ctrlCM.length; i++) {
                    var obj = _ctrlCM[i];
                    var ESValido = false;
                    if (obj.getAttribute("frmd_modif") == 1 && obj.getAttribute("frmd_nombre") != "" && obj.getAttribute("frmd_tipo") != "label" && obj.getAttribute("frmd_tipo") != "file" && obj.getAttribute("frmd_tipo") != "button") {
                        ESValido = true;
                    }
                    if (ESValido) {
                        var strNombre = obj.getAttribute("frmd_nombre");
                        try {
                            if (obj.getAttribute("frmd_tipo") != "radio") {
                                if (obj.getAttribute("frmd_tipo") != "PanelCheck" && obj.getAttribute("frmd_tipo") != "PanelRadio") {
                                    document.getElementById(strNombre).value = objDataItem[0].getAttribute(strNombre);
                                } else {
                                    if (obj.getAttribute("frmd_tipo") == "PanelCheck") {
                                        var strfrm_xmlNodoIniP = obj.getAttribute("frmd_xmlNodoIni");
                                        var strfrm_xmlNodoSecP = obj.getAttribute("frmd_xmlNodoSec");
                                        var Padres = objData.getElementsByTagName(strfrm_xmlNodoIniP)[0];
                                        var Hijos = Padres.getElementsByTagName(strfrm_xmlNodoSecP);
                                        var Count = document.getElementById(strNombre + "count").value;
                                        for (var Y = 0; Y < Hijos.length; Y++) {
                                            for (var H = 0; H < Count; H++) {
                                                if (document.getElementById(strNombre + H).value == Hijos[Y].getAttribute("id")) {
                                                    document.getElementById(strNombre + H).checked = true;
                                                }
                                            }
                                        }
                                    } else {
                                        var Count = document.getElementById(strNombre + "count").value;
                                        for (var H = 0; H < Count; H++) {
                                            if (document.getElementById(strNombre + H).value == objDataItem[0].getAttribute(strNombre)) {
                                                document.getElementById(strNombre + H).checked = true;
                                            }
                                        }
                                    }
                                }
                            } else {
                                if (objDataItem[0].getAttribute(strNombre) == "1") {
                                    document.getElementById(strNombre + "1").checked = true;
                                } else {
                                    document.getElementById(strNombre + "2").checked = true;
                                }
                            }
                        } catch (err) {
                            var txt = "There was an error on this page.\n\n";
                            txt += "Error description: " + err.description + " " + strNombre + "\n\n";
                            txt += "Click OK to continue5.\n\n";
                            alert(txt);
                        }
                    }
                }
                var strfrm_scriptBegin = _objscCM.getAttribute("frm_scriptBeginModi");
                if (strfrm_scriptBegin != "") {
                    var scriptInicial = new Function(strfrm_scriptBegin);
                    scriptInicial();
                }
                $("#dialogWait").dialog("close");
            }, error: function (err) {
                alert("there was an error with the XML parser\n\nError description: " + err.description + " \n\n");
                OpnCANCEL();
                $("#dialogWait").dialog("close");
            }});
    };
    this.OpnDel = function OpnDel() {
        this.dataPrint = null;
        var grid = jQuery("#" + this.strNameAct);
        if (grid.getGridParam("selrow") != null) {
            var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
            var bolPasa = true;
            if (_objscCM.getAttribute("frm_validaAnul") == 1) {
                var rowdata = grid.getRowData(grid.getGridParam("selrow"));
                if (rowdata[_objscCM.getAttribute("frm_campoAnul")] == 1) {
                    bolPasa = false;
                }
            }
            if (bolPasa) {
                this.opnOperAct = "_del";
                var id = grid.getGridParam("selrow");
                var Tabs = $("#tabsOpt" + this.strNameAct);
                Tabs.tabs("enable", 1);
                Tabs.tabs("option", "active", 1);
                Tabs.tabs("disable", 0);
                var div = document.getElementById("screenOpt" + this.strNameAct);
                document.getElementById("VerDeta" + this.strNameAct).innerHTML = strTitleBajas + " " + _objscCM.getAttribute("frm_title") + " " + id;
                div.innerHTML = strMsgVal8 + _objscCM.getAttribute("frm_title") + strMsgVal9;
                var lstCell = grid.getRowData(id);
                var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
                for (var i = 0; i < _ctrlCM.length; i++) {
                    var obj = _ctrlCM[i];
                    if (obj.getAttribute("frmd_consulta") == "1") {
                        div.innerHTML += " <br>" + obj.getAttribute("frmd_titulo") + ":" + lstCell[obj.getAttribute("frmd_nombre")];
                    }
                }
                this.ActiveButtons("Del" + this.strNameAct);
            }
        }
    };
    this.OpnDelConfirm = function OpnDelConfirm() {
        var grid = jQuery("#" + this.strNameAct);
        var id = grid.getGridParam("selrow");
        var Tabs = $("#tabsOpt" + this.strNameAct);
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var strfrm_urlDel = _objscCM.getAttribute("frm_urlDel");
        var strfrm_key = _objscCM.getAttribute("frm_key");
        var objMe = this;
        $("#dialogWait").dialog("open");
        $.ajax({type: "POST", data: strfrm_key + "=" + id, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: strfrm_urlDel + "&opnOpt=" + objMe.opnOptAct, success: function (datos) {
                $("#dialogWait").dialog("close");
                if (datos.substr(0, 2) == "OK") {
                    Tabs.tabs("enable", 0);
                    Tabs.tabs("option", "active", 0);
                    Tabs.tabs("disable", 1);
                    document.getElementById("VerDeta" + objMe.strNameAct).innerHTML = "&nbsp;...";
                    objMe.opnOperAct = "";
                    objMe.ActiveButtons("OK" + objMe.strNameAct);
                    grid.trigger("reloadGrid");
                } else {
                    alert(datos);
                }
            }, error: function (objeto, quepaso, otroobj) {}});
    };
    this.OpnPrint = function OpnPrint() {
        this.dataPrint = null;
        var grid = jQuery("#" + this.strNameAct);
        var id = 0;
        if (grid.getGridParam("selrow") != null) {
            id = grid.getGridParam("selrow");
        }
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        var strfrm_urlDataPrint = _objscCM.getAttribute("frm_urlDataPrint");
        var strfrm_key = _objscCM.getAttribute("frm_key");
        var strfrm_xmlNodoIni = _objscCM.getAttribute("frm_xmlNodoIni");
        var strfrm_xmlNodoSec = _objscCM.getAttribute("frm_xmlNodoSec");
        var intfrm_PrintExt = _objscCM.getAttribute("frm_PrintExt");
        $("#dialogWait").dialog("open");
        if (intfrm_PrintExt == 1) {
            Abrir_Link(strfrm_urlDataPrint + "&opnOpt=" + this.opnOptAct + "&" + strfrm_key + "=" + id, "_new", 600, 700, 0, 0);
            $("#dialogWait").dialog("close");
        } else {
            var objMe = this;
            $.ajax({type: "POST", data: strfrm_key + "=" + id, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "xml", url: strfrm_urlDataPrint + "&opnOpt=" + objMe.opnOptAct, success: function (datos) {
                    objMe.dataPrint = datos;
                    var strHtml = "";
                    var div = document.getElementById("screenOpt" + objMe.strNameAct);
                    objMe.opnOperAct = "_print";
                    var objData = datos.getElementsByTagName(strfrm_xmlNodoIni)[0];
                    var objDataItem = objData.getElementsByTagName(strfrm_xmlNodoSec);
                    strHtml = "<div id='Imprime'>";
                    strHtml += "<table class='tabla'>";
                    var intColSpanHead = 0;
                    for (var i = 0; i < _ctrlCM.length; i++) {
                        var obj = _ctrlCM[i];
                        var ESValido2 = false;
                        if (obj.getAttribute("frmd_impresion") == 1) {
                            ESValido2 = true;
                        }
                        if (ESValido2) {
                            intColSpanHead++;
                        }
                    }
                    strHtml += "<tr>";
                    strHtml += "<td class='form_head' colspan='" + intColSpanHead + "'>" + strTitleImpresion + _objscCM.getAttribute("frm_title") + "</td>";
                    strHtml += "</tr>";
                    if (strRazonSocial != null) {
                        strHtml += "<tr>";
                        strHtml += "<td class='form_head' colspan='" + intColSpanHead + "'>" + strRazonSocial + "</td>";
                        strHtml += "</tr>";
                    }
                    strHtml += "<tr>";
                    for (var i = 0; i < _ctrlCM.length; i++) {
                        var obj = _ctrlCM[i];
                        var ESValido = false;
                        if (obj.getAttribute("frmd_impresion") == 1) {
                            ESValido = true;
                        }
                        if (ESValido) {
                            strHtml += "<td class='form_head'>" + obj.getAttribute("frmd_titcorto") + "</td>";
                        }
                    }
                    strHtml += "</tr>";
                    var bolGris = false;
                    for (var y = 0; y < objDataItem.length; y++) {
                        strHtml += "<tr>";
                        var strCss = "";
                        if (bolGris) {
                            strCss = "bgcolor='#C0C0C0'";
                        }
                        for (var i = 0; i < _ctrlCM.length; i++) {
                            var obj = _ctrlCM[i];
                            var ESValido = false;
                            if (obj.getAttribute("frmd_impresion") == 1) {
                                ESValido = true;
                            }
                            if (ESValido) {
                                var strNombre = obj.getAttribute("frmd_nombre");
                                if (obj.getAttribute("frmd_tipo") != "radio") {
                                    var strValS = objDataItem[y].getAttribute(strNombre);
                                    var elements = obj.getElementsByTagName("element");
                                    if (elements.length > 0) {
                                        for (var iEle = 0; iEle < elements.length; iEle++) {
                                            var obj2 = elements[iEle];
                                            if (strValS == obj2.getAttribute("send")) {
                                                strValS = obj2.getAttribute("show");
                                                break;
                                            }
                                        }
                                    }
                                    strHtml += "<td " + strCss + " NOWRAP>" + strValS + "</td>";
                                } else {
                                    if (objDataItem[y].getAttribute(strNombre) == "1") {
                                        strHtml += "<td " + strCss + ">SI</td>";
                                    } else {
                                        strHtml += "<td " + strCss + ">NO</td>";
                                    }
                                }
                            }
                        }
                        if (bolGris == false) {
                            bolGris = true;
                        } else {
                            bolGris = false;
                        }
                        strHtml += "</tr>";
                    }
                    strHtml += "</table>";
                    strHtml += "</div>";
                    strHtml += "<a href=\"javascript:imprSelec('Imprime')\" >" + strTitleImpresion2 + "</a>&nbsp;&nbsp;";
                    strHtml += "<a href=\"javascript:toExcelData('Imprime')\" >" + strTitleImpresion3 + "</a>";
                    strHtml += '<form action="CIP_Exporta' + stExt + '" method="post" enctype="application/x-www-form-urlencoded;charset=utf-8" accept-charset="utf-8" target="_blank" id="FormularioExportacion">';
                    strHtml += '<input type="hidden" id="datos_a_enviar" name="datos_a_enviar" />';
                    strHtml += '<input type="hidden" id="NomSCPrint" name="NomSCPrint" value="' + objMe.strNameAct + '" />';
                    strHtml += '<div id="form_values" />';
                    strHtml += "</form>";
                    div.innerHTML = strHtml;
                    $("#tabsOpt" + objMe.strNameAct).tabs("enable", 1);
                    $("#tabsOpt" + objMe.strNameAct).tabs("option", "active", 1);
                    document.getElementById("VerDeta" + objMe.strNameAct).innerHTML = strTitleImpresion + _objscCM.getAttribute("frm_title");
                    objMe.ActiveButtons("Print" + objMe.strNameAct);
                    $("#dialogWait").dialog("close");
                }, error: function (objeto, quepaso, otroobj) {}});
        }
    };
    this.OpnImporta = function OpnImporta() {
        var objMe = this;
        var bolPasa = true;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        if (_ctrlCM.length == 0) {
            bolPasa = false;
            this.LoadXmlOnly(true, false, false);
        }
        if (bolPasa) {
            this.dataPrint = null;
            this.opnOperAct = "_importa";
            this.objDataEdit = null;
            this.idOperAct = 0;
            var _tabsAct = $("#tabsOpt" + this.strNameAct);
            _tabsAct.tabs("enable", 1);
            _tabsAct.tabs("option", "active", 1);
            _tabsAct.tabs("disable", 0);
            document.getElementById("VerDeta" + objMe.strNameAct).innerHTML = strTitleImporta1 + _objscCM.getAttribute("frm_title");
            var div = document.getElementById("screenOpt" + objMe.strNameAct);
            var form1 = new Formulario("", "", this.uXmlAct, div, null, "_importa", true, this);
            form1.makeForm();
            var strHtmlImporta1_ = CreaFile(strTitleImporta2, "fileToUploadXLS", "", "", "left", 0, "", "", "", 0);
            strHtmlImporta1_ += CreaBoton("", "_descarga_layout", "Descargar Layout", "_generaXLS('" + objMe.opnOptAct + "')", "left", false, null, false, false, "", "", "");
            div.innerHTML += strHtmlImporta1_;
            _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
            this.ActiveButtons("Importa" + this.strNameAct);
        }
    };
    this.OpnImportaConfirm = function OpnImportaConfirm() {
        var objMe = this;
        var bolPasa = true;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
        if (_ctrlCM.length == 0) {
            bolPasa = false;
            this.LoadXmlOnly(true, false, false);
        }
        if (bolPasa) {
            if (this.OpnValida()) {
                var _file = document.getElementById("fileToUploadXLS");
                if (_file.value == "") {
                    alert(strTitleImporta3);
                    _file.focus();
                } else {
                    if (Right(_file.value.toUpperCase(), 3) == "XLS") {
                        $("#dialogWait").dialog("open");
                        this.OpnAjaxFileUpload();
                    } else {
                        alert(strTitleImporta4);
                        _file.focus();
                    }
                }
            }
        }
    };
    this.OpnAjaxFileUpload = function OpnAjaxFileUpload() {
        var grid = jQuery("#" + this.strNameAct);
        var objMe = this;
        var _objscCM = this.uXmlAct.getElementsByTagName("Screen")[0];
        var strfrm_url_import = _objscCM.getAttribute("frm_url_import");
        var strPost = this.OpnPreparaPOST();
        $("#dialogWait").dialog("open");
        $.ajaxFileUpload({url: strfrm_url_import + "&opnOpt=" + objMe.opnOptAct + "&" + strPost, secureuri: false, fileElementId: "fileToUploadXLS", dataType: "json", success: function (data, status) {
                if (typeof (data.error) != "undefined") {
                    if (data.error != "") {
                        alert(data.error);
                    } else {
                        alert(data.msg);
                        grid.trigger("reloadGrid");
                        objMe.OpnCANCEL();
                    }
                }
                $("#dialogWait").dialog("close");
            }, error: function (data, status, e) {
                alert(e);
                $("#dialogWait").dialog("close");
                $("#dialogWait").dialog("close");
            }});
        return false;
    };
}
function _MapScreen() {
    this.lstScreen = new Array();
    this.idxScreen = 0;
    this.ScreenAct = null;
    this.OpnOpt = function OpnOpt(opt, atr, dialog, cleanPanelRight, bolMain, withoutButtons) {
        var strNomMain = this.getNomMain();
        var bolCancelo = true;
        if (strNomMain != "" && (dialog == null || dialog == undefined)) {
            var objSc = this.getScreen(strNomMain);
            if (objSc.opnOperAct == "_new" || objSc.opnOperAct == "_ed") {
                if (confirm("Va a perder todos los cambios que no guardo, ¿desea proseguir?")) {
                    bolCancelo = true;
                } else {
                    bolCancelo = false;
                }
                if (bolCancelo) {
                    objSc.opnOperAct = "";
                }
            }
        }
        if (bolCancelo) {
            if (bolMain == null) {
                if (dialog != null && dialog != "undefined") {
                    bolMain = false;
                } else {
                    bolMain = true;
                }
            }
            var bolFound = false;
            var nvoMain = false;
            for (var i = 1; i < this.lstScreen.length; i++) {
                if (this.lstScreen[i].opnOptAct == opt) {
                    bolFound = true;
                    if (!this.lstScreen[i].bolMain && bolMain) {
                        nvoMain = true;
                        this.ScreenAct = this.lstScreen[i];
                    }
                }
            }
            if (withoutButtons == undefined || withoutButtons == null) {
                withoutButtons = false;
            }
            if (!bolFound && bolMain) {
                nvoMain = true;
            }
            if (nvoMain) {
                for (i = 1; i < this.lstScreen.length; i++) {
                    var strdialogAct = null;
                    if (this.lstScreen[i].opnOptAct != opt) {
                        if (bolMain) {
                            this.lstScreen[i].bolActivo = false;
                            this.lstScreen[i].bolMain = false;
                            strdialogAct = this.lstScreen[i].dialog;
                            if (strdialogAct != null && strdialogAct != "undefined" && strdialogAct != "") {
                                document.getElementById(this.lstScreen[i].dialog + "_inside").innerHTML = "";
                            }
                            this.lstScreen[i].dialog = null;
                        }
                    } else {
                        if (nvoMain) {
                            this.lstScreen[i].bolActivo = false;
                            this.lstScreen[i].bolMain = false;
                            strdialogAct = this.lstScreen[i].dialog;
                            if (strdialogAct != null && strdialogAct != "undefined" && strdialogAct != "") {
                                document.getElementById(this.lstScreen[i].dialog + "_inside").innerHTML = "";
                            }
                            this.lstScreen[i].dialog = null;
                        }
                    }
                }
            }
            if (bolFound) {
                for (i = 1; i < this.lstScreen.length; i++) {
                    if (this.lstScreen[i].opnOptAct == opt) {
                        if (bolMain) {
                            this.lstScreen[i].bolMain = true;
                            this.ScreenAct = this.lstScreen[i];
                        }
                        if (dialog != null && dialog != "undefined" && dialog != "") {
                            this.lstScreen[i].dialog = dialog;
                        }
                        this.lstScreen[i].cleanPanelRight = cleanPanelRight;
                        this.lstScreen[i].withoutButtons = withoutButtons;
                        this.lstScreen[i].Draw();
                    }
                }
            } else {
                this.idxScreen++;
                this.lstScreen[this.idxScreen] = new _Screen(opt, atr, dialog, cleanPanelRight, bolMain);
                this.lstScreen[this.idxScreen].withoutButtons = withoutButtons;
                this.lstScreen[this.idxScreen].Draw();
                if (bolMain) {
                    this.ScreenAct = this.lstScreen[this.idxScreen];
                }
            }
        }
    };
    this.ClearCache = function ClearCache() {
        this.idxScreen = 0;
        this.lstScreen = [];
        this.lstScreen.length = 0;
    };
    this.EnviaForm = function EnviaForm(formName, script, strNameForms, strTypeForms, strTipoReport, strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].EnviaForm(formName, script, strNameForms, strTypeForms, strTipoReport);
                break;
            }
        }
    };
    this.OpnNew = function OpnNew(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnNew();
                break;
            }
        }
    };
    this.OpnOK = function OpnOK(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnOK();
                break;
            }
        }
    };
    this.OpnCANCEL = function OpnCANCEL(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnCANCEL();
                break;
            }
        }
    };
    this.OpnEdit = function OpnEdit(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnEdit();
                break;
            }
        }
    };
    this.OpnDel = function OpnDel(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnDel();
                break;
            }
        }
    };
    this.OpnDelConfirm = function OpnDelConfirm(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnDelConfirm();
                break;
            }
        }
    };
    this.OpnPrint = function OpnPrint(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnPrint();
                break;
            }
        }
    };
    this.OpnImporta = function OpnImporta(strOptName) {
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                this.lstScreen[i].OpnImporta();
                break;
            }
        }
    };
    this.getXml = function getXml(strOptName) {
        var uXmlGet = null;
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                uXmlGet = this.lstScreen[i].uXmlAct;
                break;
            }
        }
        return uXmlGet;
    };
    this.getScreen = function getScreen(strOptName) {
        var objScreen = null;
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].opnOptAct == strOptName) {
                objScreen = this.lstScreen[i];
                break;
            }
        }
        return objScreen;
    };
    this.getHayActivo = function getHayActivo() {
        var bolHayActivo = false;
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].bolActivo && this.lstScreen[i].bolMain) {
                bolHayActivo = true;
                break;
            }
        }
        return bolHayActivo;
    };
    this.getNomMain = function getNomMain() {
        var strNomMain = "";
        for (var i = 1; i < this.lstScreen.length; i++) {
            if (this.lstScreen[i].bolActivo && this.lstScreen[i].bolMain) {
                strNomMain = this.lstScreen[i].opnOptAct;
                break;
            }
        }
        return strNomMain;
    };
}
var objMap = new _MapScreen();
function OpnOpt(opt, atr, dialog, cleanPanelRight, bolMain, withoutButtons) {
    objMap.OpnOpt(opt, atr, dialog, cleanPanelRight, bolMain, withoutButtons);
}
function MakeForm(xmlDoc, dialog, objScreen) {
    var div = document.getElementById("MainPanel");
    bolMuestraDiv = false;
    var form1 = new Formulario("", "", xmlDoc, div, dialog, "_ed", objScreen.withoutButtons, objScreen);
    form1.bolUseMod = true;
    form1.makeForm();
}
function ObtenData(strCtrl, strTypeForms) {
    var lstForm = strCtrl.split("|");
    var str = "";
    var lstFormType = strTypeForms.split("|");
    var d = document;
    for (var i = 0; i < lstForm.length; i++) {
        if (lstForm[i] != null && lstForm[i] != "") {
            if (lstFormType[i] != "radio") {
                if (lstFormType[i] != "PanelCheck") {
                    if (lstFormType[i] != "checkbox") {
                        if (lstFormType[i] != "PanelRadio") {
                            str += lstForm[i] + "=" + encodeURIComponent(d.getElementById(lstForm[i]).value) + "&";
                        } else {
                            for (var h = 0; h < d.getElementById(lstForm[i] + "count").value; h++) {
                                if (d.getElementById(lstForm[i] + h).checked) {
                                    str += lstForm[i] + "=" + encodeURIComponent(d.getElementById(lstForm[i] + h).value) + "&";
                                }
                            }
                        }
                    } else {
                        if (d.getElementById(lstForm[i]).checked) {
                            str += lstForm[i] + "=0&";
                        } else {
                            str += lstForm[i] + "=" + encodeURIComponent(d.getElementById(lstForm[i]).value) + "&";
                        }
                    }
                } else {
                    for (var h = 0; h < d.getElementById(lstForm[i] + "count").value; h++) {
                        if (d.getElementById(lstForm[i] + h).checked) {
                            str += lstForm[i] + "=" + encodeURIComponent(d.getElementById(lstForm[i] + h).value) + "&";
                        }
                    }
                }
            } else {
                if (d.getElementById(lstForm[i] + "1").checked) {
                    str += lstForm[i] + "=" + d.getElementById(lstForm[i] + "1").value + "&";
                }
                if (d.getElementById(lstForm[i] + "2").checked) {
                    str += lstForm[i] + "=" + d.getElementById(lstForm[i] + "2").value + "&";
                }
            }
        }
    }
    return str;
}
function EnviaForm(formName, script, strNameForms, strTypeForms, strTipoReport, strNameScreen) {
    objMap.EnviaForm(formName, script, strNameForms, strTypeForms, strTipoReport, strNameScreen);
}
function _DefineGrid(bolEdit, strName, strfrm_urlgrid, opnOptAct, intfrm_gridscroll, arrcolNames, arrcolModel, strfrm_orden, strfrm_tipoorden, strtitle, _fdblClick, strfrm_ongridSelRow, strfrm_ongridafterInsertRow, strfrm_ongridComplete, strfrm_ongridloadError, strfrm_ongridRightClickRow, strfrm_ongridSelectAll, strfrm_ongridSortCol, idxSelRows, intfrm_gridrows, bolMulti, intfrm_grid_width, intfrm_grid_height) {
    var strEditUrl = "";
    var _fSelectRow = null;
    var _fongridafterInsertRow = null;
    var _fongridComplete = null;
    var _fongridloadError = null;
    var _fongridRightClickRow = null;
    var _fongridSelectAll = null;
    var _fongridSortCol = null;
    var intNumRows = intfrm_gridrows;
    if (strfrm_ongridSelRow != null && strfrm_ongridSelRow != "") {
        _fSelectRow = new Function("rowid", "status", strfrm_ongridSelRow);
    } else {
        if (bolEdit) {
            var strFunctionRow = "" + " if(rowid !==lstselRows[" + idxSelRows + "]){" + " jQuery('#" + strName + "').restoreRow(lstselRows[" + idxSelRows + "]); " + " jQuery('#" + strName + "').editRow(rowid,false); " + " lstselRows[" + idxSelRows + "] = rowid; " + " }";
            _fSelectRow = new Function("rowid", "status", strFunctionRow);
        }
    }
    if (strfrm_ongridafterInsertRow != "") {
        _fongridafterInsertRow = new Function("rowid", "rowdata", "rowelem", strfrm_ongridafterInsertRow);
    }
    if (strfrm_ongridComplete != "") {
        _fongridComplete = new Function(strfrm_ongridComplete);
    }
    if (strfrm_ongridloadError != "") {
        _fongridloadError = new Function("xhr", "status", "error", strfrm_ongridloadError);
    }
    if (strfrm_ongridRightClickRow != "") {
        _fongridRightClickRow = new Function("rowid", "iRow", "iCol", "e", strfrm_ongridRightClickRow);
    }
    if (strfrm_ongridSelectAll != "") {
        _fongridSelectAll = new Function("aRowids", "status", strfrm_ongridSelectAll);
    }
    if (strfrm_ongridSortCol != "") {
        _fongridSortCol = new Function("index", "iCol", "sortorder", strfrm_ongridSortCol);
    }
    if (strfrm_urlgrid != "") {
        strfrm_urlgrid += "&opnOpt=" + opnOptAct;
    }
    var intScroll = 0;
    var bolRownumbers = false;
    var strheight = "auto";
    var strwidth = "auto";
    if (intfrm_gridscroll == 1) {
        intScroll = 1;
        bolRownumbers = true;
        strheight = 350;
        strwidth = 800;
    }
    if (intfrm_grid_width != 0) {
        strwidth = intfrm_grid_width;
    }
    if (intfrm_grid_height != 0) {
        strheight = intfrm_grid_height;
    }
    if (bolEdit) {
        strEditUrl = "_blank" + stExt;
        intNumRows = 0;
        jQuery("#" + strName).jqGrid({url: strfrm_urlgrid, datatype: "xml", mtype: "GET", height: strheight, width: strwidth, editurl: strEditUrl, colNames: arrcolNames, colModel: arrcolModel, sortname: strfrm_orden, sortorder: strfrm_tipoorden, viewrecords: true, caption: strtitle, footerrow: true, userDataOnFooter: true, ondblClickRow: _fdblClick, onSelectRow: _fSelectRow, afterInsertRow: _fongridafterInsertRow, gridComplete: _fongridComplete, loadError: _fongridloadError, onRightClickRow: _fongridRightClickRow, onSelectAll: _fongridSelectAll, onSortCol: _fongridSortCol, multiselect: bolMulti, multikey: "", scrollrows: true, shrinkToFit: true, imgpath: "jqGrid/themes/steel/images"});
    } else {
        jQuery("#" + strName).jqGrid({scroll: intScroll, url: strfrm_urlgrid, editurl: strEditUrl, datatype: "xml", mtype: "GET", height: strheight, width: strwidth, colNames: arrcolNames, colModel: arrcolModel, sortname: strfrm_orden, sortorder: strfrm_tipoorden, caption: strtitle, toolbar: [true, "top"], pager: "#pager" + strName, rowNum: intNumRows, rownumbers: bolRownumbers, rownumWidth: 40, gridview: true, viewrecords: true, userDataOnFooter: true, footerrow: true, ondblClickRow: _fdblClick, onSelectRow: _fSelectRow, afterInsertRow: _fongridafterInsertRow, gridComplete: _fongridComplete, loadError: _fongridloadError, onRightClickRow: _fongridRightClickRow, onSelectAll: _fongridSelectAll, onSortCol: _fongridSortCol, multiselect: bolMulti, multikey: "", scrollrows: true, shrinkToFit: true, imgpath: "jqGrid/themes/steel/images"}).navGrid("#pager" + strName, {edit: false, add: false, del: false});
    }
    $("#" + strName).navButtonAdd("#pager" + strName, {buttonicon: "ui-icon-calculator", title: "Seleccionar columnas", caption: "Columnas", position: "last", onClickButton: function () {
            jQuery("#" + strName).jqGrid("columnChooser");
        }});
    $("#t_" + strName).append("<input type='button' id='_selColumsHead' value='Columnas'      class='_selColumsHead'/>");
    $("input", "#t_" + strName).click(function () {
        if (this.value == "Columnas") {
            jQuery("#" + strName).jqGrid("columnChooser");
        }
    });
    jQuery("#" + strName).jqGrid("gridResize", {minWidth: 350, maxWidth: 2050, minHeight: 80, maxHeight: 1050});
}
function OpnNew(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("New", "");
        objMap.OpnNew(strNameSC);
    }
}
function OpnOK(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("OK", "");
        objMap.OpnOK(strNameSC);
    }
}
function OpnCANCEL(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("CANCEL", "");
        objMap.OpnCANCEL(strNameSC);
    }
}
function OpnEdit(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Ed", "");
        objMap.OpnEdit(strNameSC);
    }
}
function OpnDel(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Del", "");
        objMap.OpnDel(strNameSC);
    }
}
function OpnDelConfirm(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Del", "");
        objMap.OpnDelConfirm(strNameSC);
    }
}
function OpnFilter(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Filter", "");
        var grid = jQuery("#" + strNameSC);
        var dataXml = objMap.getXml(strNameSC);
        var _objscCM = dataXml.getElementsByTagName("Screen")[0];
        var intfrm_searchtype = _objscCM.getAttribute("frm_searchtype");
        if (intfrm_searchtype == 1) {
            grid.jqGrid("filterToolbar", {autosearch: true});
            objMe.disabled = true;
        } else {
            grid.searchGrid({modal: true, checkInput: true});
            grid.jqGrid("searchGrid", {multipleSearch: true});
        }
    }
}
function OpnPrint(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Print", "");
        objMap.OpnPrint(strNameSC);
    }
}
function OpnImporta(objMe) {
    if (objMe != null) {
        var strNameSC = objMe.id.replace("Importa", "");
        objMap.OpnImporta(strNameSC);
    }
}
function imprSelec(nombre) {
    var ficha = document.getElementById(nombre);
    var ventimp = window.open("_blank" + stExt, "popimpr");
    ventimp.document.write(ficha.innerHTML);
    ventimp.document.close();
    ventimp.print();
    ventimp.close();
}
function toExcelData(nombre) {
    var objDivform = document.getElementById("form_values");
    var strNomSCPrint = document.getElementById("NomSCPrint");
    var objScMain = objMap.getScreen(strNomSCPrint.value);
    var objDatos = objScMain.dataPrint;
    var _objscCM = objScMain.uXmlAct.getElementsByTagName("Screen")[0];
    var _ctrlCM = _objscCM.getElementsByTagName("ctrl");
    var strfrm_key = _objscCM.getAttribute("frm_key");
    var strfrm_xmlNodoIni = _objscCM.getAttribute("frm_xmlNodoIni");
    var strfrm_xmlNodoSec = _objscCM.getAttribute("frm_xmlNodoSec");
    var objData = objDatos.getElementsByTagName(strfrm_xmlNodoIni)[0];
    var objDataItem = objData.getElementsByTagName(strfrm_xmlNodoSec);
    var strEnviar = "";
    var intRows = 0;
    var intCols = -1;
    for (var i = 0; i < _ctrlCM.length; i++) {
        var obj = _ctrlCM[i];
        var ESValido = false;
        if (obj.getAttribute("frmd_impresion") == 1) {
            ESValido = true;
        }
        if (ESValido) {
            intCols++;
            strEnviar += '<input type="hidden" value="' + obj.getAttribute("frmd_titcorto") + '" name="Fila' + intRows + "td" + intCols + '">';
        }
    }
    for (var y = 0; y < objDataItem.length; y++) {
        intRows++;
        intCols = -1;
        for (var i = 0; i < _ctrlCM.length; i++) {
            obj = _ctrlCM[i];
            ESValido = false;
            if (obj.getAttribute("frmd_impresion") == 1) {
                ESValido = true;
            }
            if (ESValido) {
                intCols++;
                var strNombre = obj.getAttribute("frmd_nombre");
                if (obj.getAttribute("frmd_tipo") != "radio") {
                    var strValS = objDataItem[y].getAttribute(strNombre);
                    var elements = obj.getElementsByTagName("element");
                    if (elements.length > 0) {
                        for (var iEle = 0; iEle < elements.length; iEle++) {
                            var obj2 = elements[iEle];
                            if (strValS == obj2.getAttribute("send")) {
                                strValS = obj2.getAttribute("show");
                                break;
                            }
                        }
                    }
                    strEnviar += '<input type="hidden" value="' + trim(strValS) + '" name="Fila' + intRows + "td" + intCols + '">';
                } else {
                    if (objDataItem[y].getAttribute(strNombre) == "1") {
                        strEnviar += '<input type="hidden" value="SI" name="Fila' + intRows + "td" + intCols + '">';
                    } else {
                        strEnviar += '<input type="hidden" value="NO" name="Fila' + intRows + "td" + intCols + '">';
                    }
                }
            }
        }
    }
    strEnviar += '<input type="hidden" value="' + intCols + '" name="Cols">';
    strEnviar += '<input type="hidden" value="' + intRows + '" name="Rows">';
    objDivform.innerHTML = strEnviar;
    $("#FormularioExportacion").submit();
}
function callUpGrid(strNameGrid) {
    var grid = jQuery("#" + strNameGrid);
    var ids = grid.getGridParam("selrow");
    var lstIds = grid.getDataIDs();
    var intpage = grid.getGridParam("page");
    if (ids != null) {
        for (var i = lstIds.length - 1; i >= 0; i--) {
            if (ids == lstIds[i]) {
                if (i == 0) {
                    if (intpage > 1) {
                        intpage--;
                        grid.setGridParam({page: intpage});
                        grid.trigger("reloadGrid");
                    }
                } else {
                    grid.setSelection(lstIds[i - 1], true);
                }
                break;
            }
        }
    } else {
        try {
            for (var i = lstIds.length - 1; i >= 0; i--) {
                grid.setSelection(lstIds[i], true);
                break;
            }
        } catch (err) {
            var txt = "There was an error when callUpGrid.\n\n";
            txt += "Error description: " + err.description + " \n\n";
            txt += "Click OK to continue.\n\n";
            alert(txt);
        }
    }
    return false;
}
function callDownGrid(strNameGrid) {
    var grid = jQuery("#" + strNameGrid);
    var ids = grid.getGridParam("selrow");
    var lstIds = grid.getDataIDs();
    var intpage = grid.getGridParam("page");
    if (ids != null) {
        for (var i = 0; i < lstIds.length; i++) {
            if (ids == lstIds[i]) {
                if (i == lstIds.length - 1) {
                    intpage++;
                    grid.setGridParam({page: intpage});
                    grid.trigger("reloadGrid");
                } else {
                    grid.setSelection(lstIds[i + 1], true);
                }
                break;
            }
        }
    } else {
        for (var i = 0; i < lstIds.length; i++) {
            grid.setSelection(lstIds[i], true);
            break;
        }
    }
    return false;
}
function checker() {
    $.ajax({type: "POST", data: "x=1&" + strPOST_Check, scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", cache: false, dataType: "html", url: "CIP_CheckSesion" + stExt + "", success: function (datos) {
            if (datos == "DOWN") {
                window.location = "CIP_Salir" + stExt + "";
            }
        }, error: function (objeto, quepaso, otroobj) {}});
}
function Fecha() {
    this.monthNames = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    this.monthNamesShort = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    this.dayNames = ["Domingo", "Lunes", "Martes", "Mi&eacute;rcoles", "Jueves", "Viernes", "S&aacute;bado"];
    this.dayNamesShort = ["Dom", "Lun", "Mar", "Mi&eacute;", "Juv", "Vie", "S&aacute;b"];
    this.monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    this.DameNombreMes = function DameNombreMes(intMes) {
        if (intMes > 12) {
            intMes = 12;
        }
        if (intMes <= 0) {
            intMes = 1;
        }
        return this.monthNames[intMes - 1];
    };
    this.DameNumMes = function DameNumMes(strNomMes) {
        var intMes = 0;
        for (var k = 0; k < this.monthNames.length; k++) {
            if (this.monthNames[k] == strNomMes) {
                intMes = k + 1;
                break;
            }
        }
        if (intMes < 10) {
            intMes = "0" + intMes;
        }
        return intMes;
    };
    this.DameNombreMesCorto = function DameNombreMesCorto(intMes) {
        if (intMes > 12) {
            intMes = 12;
        }
        if (intMes <= 0) {
            intMes = 1;
        }
        return this.monthNamesShort[intMes - 1];
    };
    this.DameNombreDia = function DameNombreDia(intDia) {
        if (intDia > 7) {
            intDia = 7;
        }
        if (intDia <= 0) {
            intDia = 1;
        }
        return this.dayNames[intDia - 1];
    };
    this.DameNombreDiaCorto = function DameNombreDiaCorto(intDia) {
        if (intDia > 7) {
            intDia = 7;
        }
        if (intDia <= 0) {
            intDia = 1;
        }
        return this.dayNamesShort[intDia - 1];
    };
    this.DameMesDias = function DameMesDias(intAnio, intMes) {
        if (intMes > 12) {
            intMes = 12;
        }
        if (intMes <= 0) {
            intMes = 1;
        }
        if (intAnio % 4 == 0 && intMes == 2) {
            return 29;
        } else {
            return this.monthDays[intMes - 1];
        }
    };
}
function valExpReg(YourValue, YourExp) {
    var Template = new RegExp(YourExp);
    return(Template.test(YourValue)) ? 1 : 0;
}
function importa(src) {
    var d = new Date();
    var scriptElem = document.createElement("script");
    scriptElem.setAttribute("src", src + "?date=" + d.toString());
    scriptElem.setAttribute("type", "text/javascript");
    document.getElementsByTagName("head")[0].appendChild(scriptElem);
}
function ValidaClean(strNomField) {
    var objDivErr = document.getElementById("err_" + strNomField);
    if (objDivErr != null) {
        objDivErr.innerHTML = "";
        objDivErr.setAttribute("class", "");
        objDivErr.setAttribute("className", "");
    }
}
function ValidaShow(strNomField, strMsg) {
    var objDivErr = document.getElementById("err_" + strNomField);
    objDivErr.setAttribute("class", "");
    objDivErr.setAttribute("class", "inError");
    objDivErr.setAttribute("className", "inError");
    objDivErr.innerHTML = "<img src='images/layout/report3_del.gif' border='0'>&nbsp;" + strMsg;
}
function getAjaxError(e, xhr, settings, exception) {
    if (settings.url.substr(0, 6) != "_blank") {
        var strError = "";
        if (exception != null && exception != undefined) {
            strError = settings.url + " " + exception.description;
        } else {
            strError = settings.url;
        }
        var strHTML = "<table border=0>" + "<tr><td align=center>AL PARECER OCURRIO UN ERROR EN LA CONEXION</td></tr>" + "<tr><td align=center>INTENTAREMOS DETERMINAR EL MOTIVO</td></tr>" + "<tr><td align=center>FAVOR DE DARLE CLICK AL SIGUIENTE BOTON</td></tr>" + "<tr><td align=center><input type=button class='boton' name='testCon' value='Probar Conexion' onClick=\"TestConex('" + strError + "');\"></td></tr>" + "</table>";
        document.getElementById("dialog_inside").innerHTML = strHTML;
        $("#dialog").dialog("option", "title", "ASESOR DEL SISTEMA");
        $("#dialog").dialog("open");
    }
}
function TestConex(strError) {
    $("#dialogWait").dialog("open");
    $.ajax({scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", url: "_blank" + stExt, dataType: "html", success: function (datos) {
            if (trim(datos) == "null") {
                $.ajax({scriptCharset: "utf-8", contentType: "application/x-www-form-urlencoded;charset=utf-8", url: "CIP_CheckSesion" + stExt, dataType: "html", success: function (datos) {
                        alert("Favor de intentarlo nuevamente, si la falla persiste favor de reportarlo a su area de soporte anexando esta pantalla: " + strError);
                        $("#dialog").dialog("close");
                        $("#dialogWait").dialog("close");
                    }, error: function (objeto, quepaso, otroobj) {
                        alert("No se pudo determinar el fallo favor de reportarlo a su area de soporte anexando esta pantalla: " + strError);
                        $("#dialogWait").dialog("close");
                    }});
            } else {
                alert("No hay acceso a la red favor de revisar su conexion....");
                $("#dialogWait").dialog("close");
            }
        }, error: function (objeto, quepaso, otroobj) {
            alert("No hay acceso a la red favor de revisar su conexion....");
            $("#dialogWait").dialog("close");
        }});
}
function ajaxSendVal(e, xhr, settings, exception) {
    var lstAttrib = strPOST_Check.split("&");
    for (var hs = 0; hs < lstAttrib.length; hs++) {
        var lstIt2 = lstAttrib[hs].split("=");
        try {
            xhr.setRequestHeader(lstIt2[0], lstIt2[1]);
        } catch (err) {
        }
    }
}
function _generaXLS(opnOpt) {
    var strHtml = '<form action="CIP_TablaOp.jsp?ID=7&opnOpt=' + opnOpt + '" method="post" target="_blank" id="formSend">';
    strHtml += "</form>";
    document.getElementById("formHidden").innerHTML = strHtml;
    document.getElementById("formSend").submit();
}