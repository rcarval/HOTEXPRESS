global class WS_Servicios_Externos {
    
    
    global class RespuestaRegiones{
        
        webservice list<region> region;
        
    }
    
    global class region{
        
        webservice String Identificador;
        webservice String Nombre;
        
    }
    
    webservice static RespuestaRegiones ListarRegion(){
       EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='RegionesyComunas' limit 1 ];
        string  usuario = ep.usuario__c;
        string contrasena = ep.contrase_a__c;
        RegionesyComunas.ServicioExternoRegionYComunasSoap  lisreg=new RegionesyComunas.ServicioExternoRegionYComunasSoap();
        RegionesyComunas.ArrayOfRegionTO   lisresp =new   RegionesyComunas.ArrayOfRegionTO();
        if(!test.isRunningTest()){
            lisresp=lisreg.listarTodasLasRegiones( usuario, contrasena);
        }else{
            RegionesyComunas.RegionTO RT=new RegionesyComunas.RegionTO();
            rt.Identificador='123';
            rt.Nombre='test';
            rt.ExtensionData=null;
            list<RegionesyComunas.RegionTO> Ri=new  list<RegionesyComunas.RegionTO>();
            Ri.add(rt);
            RegionesyComunas.ArrayOfRegionTO ra=new RegionesyComunas.ArrayOfRegionTO();
            ra.RegionTO=Ri;
            
            
            lisresp=ra;
        }
        system.debug('lisresp'+lisresp);
        RespuestaRegiones  res=new  RespuestaRegiones();
        
        system.debug('lisresp.RegionTO.size()'+lisresp.RegionTO.size());
        res.region =new list<region>();
        for (integer i=0;i<lisresp.RegionTO.size();i++){
            region  reg=new  region();
            reg.Identificador=lisresp.RegionTO.get(i).Identificador;
            reg.Nombre=lisresp.RegionTO.get(i).Nombre;
            
            res.region.add(reg);
        }
        
        //response_map_x=lisresp;
        return res; 
    }
    
    global class RespuestaComunas{
        
        webservice String mensaje;
        webservice Integer codigo;
        webservice list<comunas> comunas;
        
    }
    
    global class comunas{
        
        webservice String Auxiliar1;
        webservice String Auxiliar2;
        webservice String Auxiliar3;
        webservice String Iata;
        webservice String NombreComuna;
        webservice String Region;
    }
    
    webservice static RespuestaComunas ListarComunas(){
         EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='RegionesyComunas' limit 1 ];
        string  usuario = ep.usuario__c;
        string contrasena = ep.contrase_a__c;
        RegionesyComunas.ServicioExternoRegionYComunasSoap  liscom=new RegionesyComunas.ServicioExternoRegionYComunasSoap();
        RegionesyComunas.ArrayOfComunaTO   lisresp =new   RegionesyComunas.ArrayOfComunaTO();
        if(!test.isRunningTest()){
            lisresp=liscom.listarTodasLasComunas(usuario,contrasena);
        }else{
            RegionesyComunas.ComunaTO CTO=new RegionesyComunas.ComunaTO();
            CTO.ExtensionData=null;
            CTO.Auxiliar1='';
            CTO.Auxiliar2='';
            CTO.Auxiliar3='';
            CTO.Iata='123';
            CTO.NombreComuna='test';
            CTO.Region='test';
            list<RegionesyComunas.ComunaTO> CTOs=new list<RegionesyComunas.ComunaTO>(); 
            CTOs.add(CTO);
            RegionesyComunas.ArrayOfComunaTO lTCt=new RegionesyComunas.ArrayOfComunaTO();
            lTCt.ComunaTO=CTOs;
            lisresp=lTCt;
        }
        system.debug('lisresp'+lisresp);
        RespuestaComunas   res=new RespuestaComunas();
        res.comunas =new list<comunas>();
        for (integer i=0;i<lisresp.ComunaTO.size();i++){
            comunas  com=new  comunas();
            com.Iata=lisresp.ComunaTO.get(i).Iata;
            com.NombreComuna=lisresp.ComunaTO.get(i).NombreComuna;
            com.Region=lisresp.ComunaTO.get(i).Region;
            
            res.comunas.add(com);
        }
        return res; 
    }
    
    global class comunasregion{
        webservice String codigoRegion;
        
    }
    
    webservice static RespuestaComunas ListarComunassegunregion(comunasregion comunasregion){
         EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='RegionesyComunas' limit 1 ];
        string  usuario = ep.usuario__c;
        string contrasena = ep.contrase_a__c;
        string  codigoRegion=comunasregion.codigoRegion;
        RegionesyComunas.ServicioExternoRegionYComunasSoap  liscom=new RegionesyComunas.ServicioExternoRegionYComunasSoap();
        RegionesyComunas.ArrayOfComunaTO   lisresp =new   RegionesyComunas.ArrayOfComunaTO();
        if(!test.isRunningTest()){
            lisresp=liscom.listarComunasSegunRegion( usuario, contrasena, codigoRegion);
        }else{
            RegionesyComunas.ComunaTO CTO=new RegionesyComunas.ComunaTO();
            CTO.ExtensionData=null;
            CTO.Auxiliar1='';
            CTO.Auxiliar2='';
            CTO.Auxiliar3='';
            CTO.Iata='123';
            CTO.NombreComuna='test';
            CTO.Region='test';
            list<RegionesyComunas.ComunaTO> CTOs=new list<RegionesyComunas.ComunaTO>(); 
            CTOs.add(CTO);
            RegionesyComunas.ArrayOfComunaTO lTCt=new RegionesyComunas.ArrayOfComunaTO();
            lTCt.ComunaTO=CTOs;
            lisresp=lTCt;
        }
        system.debug('lisresp'+lisresp);
        RespuestaComunas   res=new RespuestaComunas();
        res.comunas =new list<comunas>();
        for (integer i=0;i<lisresp.ComunaTO.size();i++){
            comunas  com=new  comunas();
            com.Iata=lisresp.ComunaTO.get(i).Iata;
            com.NombreComuna=lisresp.ComunaTO.get(i).NombreComuna;
            com.Region=lisresp.ComunaTO.get(i).Region;
            
            res.comunas.add(com);
        }
        return res; 
    }
    global class AdmisionTO{
        webservice String CodigoAdmision;
        //webservice String ClienteRemitente;
        webservice String CentroRemitente;
        webservice String NombreRemitente;
        webservice String DireccionRemitente;
        webservice String PaisRemitente;
        webservice String CodigoPostalRemitente;
        webservice String ComunaRemitente;
        webservice String RutRemitente;
        webservice String PersonaContactoRemitente;
        webservice String TelefonoContactoRemitente;
        webservice String ClienteDestinatario;
        webservice String CentroDestinatario;
        webservice String NombreDestinatario;
        webservice String DireccionDestinatario;
        webservice String PaisDestinatario;
        webservice String CodigoPostalDestinatario;
        webservice String ComunaDestinatario;
        webservice String RutDestinatario;
        webservice String PersonaContactoDestinatario;
        webservice String TelefonoContactoDestinatario;
        webservice String CodigoServicio;
        webservice Integer NumeroTotalPiezas;
        webservice Double Kilos;
        webservice Double Volumen;
        webservice String NumeroReferencia;
        webservice Long ImporteReembolso;
        webservice Long ImporteValorDeclarado;
        webservice String TipoPortes;
        webservice String Observaciones;
        webservice String Observaciones2;
        webservice String EmailDestino;
        webservice String TipoMercancia;
        webservice String DevolucionConforme;
        webservice Long NumeroDocumentos;
        webservice String PagoSeguro;
        
    }
    global class RespuestaadmicionCEP{
        
        webservice String CodigoSucursal;
        webservice String NombreSucursal;
        webservice String Cuartel;
        webservice String Sector;
        webservice String SDP;
        webservice String Movil;
        webservice String AbreviaturaCentro;
        webservice String CodigoDelegacionDestino;
        webservice String NombreDelegacionDestino;
        webservice String DireccionDestino;
        webservice String CodigoEncaminamiento;
        webservice String GrabarEnvio;
        webservice String NumeroEnvio;
        webservice String ComunaDestino;
        webservice String AbreviaturaServicio;
        webservice String IdTransaccional;
        webservice String CodigoAdmision;
        
    }
    
    webservice static RespuestaadmicionCEP admicionCEP( AdmisionTO Admision){
        
        EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='admicionCEP' limit 1 ];
        string  usuario = ep.usuario__c;
        string contrasena = ep.contrase_a__c;
        admicionCEP.AdmisionTO admisionTo =new admicionCEP.AdmisionTO();
        admisionTo.CodigoAdmision=Admision.CodigoAdmision;
        admisionTo.ClienteRemitente=ep.Codigo_Cliente__c;
        admisionTo.CentroRemitente=Admision.CentroRemitente;
        admisionTo.NombreRemitente=Admision.NombreRemitente;
        admisionTo.DireccionRemitente=Admision.DireccionRemitente;
        admisionTo.PaisRemitente=Admision.PaisRemitente;
        admisionTo.CodigoPostalRemitente=Admision.CodigoPostalRemitente;
        admisionTo.ComunaRemitente=Admision.ComunaRemitente;
        admisionTo.RutRemitente=Admision.RutRemitente;
        admisionTo.PersonaContactoRemitente=Admision.PersonaContactoRemitente;
        admisionTo.TelefonoContactoRemitente=Admision.TelefonoContactoRemitente;
        admisionTo.ClienteDestinatario=Admision.ClienteDestinatario;
        admisionTo.CentroDestinatario=Admision.CentroDestinatario;
        admisionTo.NombreDestinatario=Admision.NombreDestinatario;
        admisionTo.DireccionDestinatario=Admision.DireccionDestinatario;
        admisionTo.PaisDestinatario=Admision.PaisDestinatario;
        admisionTo.CodigoPostalDestinatario=Admision.CodigoPostalDestinatario;
        admisionTo.ComunaDestinatario=Admision.ComunaDestinatario;
        admisionTo.RutDestinatario=Admision.RutDestinatario;
        admisionTo.PersonaContactoDestinatario=Admision.PersonaContactoDestinatario;
        admisionTo.TelefonoContactoDestinatario=Admision.TelefonoContactoDestinatario;
        admisionTo.CodigoServicio=Admision.CodigoServicio;
        admisionTo.NumeroTotalPiezas=Admision.NumeroTotalPiezas;
        admisionTo.Kilos=Admision.Kilos;
        admisionTo.Volumen=Admision.Volumen;
        admisionTo.NumeroReferencia=Admision.NumeroReferencia;
        admisionTo.ImporteReembolso=Admision.ImporteReembolso;
        admisionTo.ImporteValorDeclarado=Admision.ImporteValorDeclarado;
        admisionTo.TipoPortes=Admision.TipoPortes;
        admisionTo.Observaciones=Admision.Observaciones;
        admisionTo.Observaciones2=Admision.Observaciones2;
        admisionTo.EmailDestino=Admision.EmailDestino;
        admisionTo.TipoMercancia=Admision.TipoMercancia;
        admisionTo.DevolucionConforme=Admision.DevolucionConforme;
        admisionTo.NumeroDocumentos=Admision.NumeroDocumentos;
        admisionTo.PagoSeguro=Admision.PagoSeguro;
        admicionCEP.ServicioExternoAdmisionCEPSoap   lisadm =new   admicionCEP.ServicioExternoAdmisionCEPSoap();
        admicionCEP.RespuestaAdmisionTO   lisresp =new   admicionCEP.RespuestaAdmisionTO();
        if(!test.isRunningTest()){
            lisresp=lisadm.admitirEnvio( usuario, contrasena, admisionTo);
        }else{
            admicionCEP.RespuestaAdmisionTO   RTO=new   admicionCEP.RespuestaAdmisionTO();
            RTO.ExtensionData=null;
            RTO.CodigoSucursal='TEST';
            RTO.NombreSucursal='TEST';
            RTO.Cuartel='TEST';
            RTO.Sector='TEST';
            RTO.SDP='TEST';
            RTO.Movil='TEST';
            RTO.AbreviaturaCentro='TEST';
            RTO.CodigoDelegacionDestino='TEST';
            RTO.NombreDelegacionDestino='TEST';
            RTO.DireccionDestino='TEST';
            RTO.CodigoEncaminamiento='TEST';
            RTO.GrabarEnvio='TEST';
            RTO.NumeroEnvio='TEST';
            RTO.ComunaDestino='TEST';
            RTO.AbreviaturaServicio='TEST';
            RTO.IdTransaccional='TEST';
            RTO.CodigoAdmision='TEST';   
        }
        system.debug('lisresp'+lisresp);
        RespuestaadmicionCEP respcep=new RespuestaadmicionCEP();
        respcep.CodigoSucursal= lisresp.CodigoSucursal;
        respcep.NombreSucursal= lisresp.NombreSucursal;
        respcep.Cuartel= lisresp.Cuartel;
        respcep.Sector= lisresp.Sector;
        respcep.SDP= lisresp.SDP;
        respcep.Movil= lisresp.Movil;
        respcep.AbreviaturaCentro= lisresp.AbreviaturaCentro;
        respcep.CodigoDelegacionDestino= lisresp.CodigoDelegacionDestino;
        respcep.NombreDelegacionDestino= lisresp.NombreDelegacionDestino;
        respcep.DireccionDestino= lisresp.DireccionDestino;
        respcep.CodigoEncaminamiento= lisresp.CodigoEncaminamiento;
        respcep.GrabarEnvio= lisresp.GrabarEnvio;
        respcep.NumeroEnvio= lisresp.NumeroEnvio;
        respcep.ComunaDestino= lisresp.ComunaDestino;
        respcep.AbreviaturaServicio= lisresp.AbreviaturaServicio;
        respcep.IdTransaccional= lisresp.IdTransaccional;
        respcep.CodigoAdmision= lisresp.CodigoAdmision;
        
        return respcep; 
    }    
}