@istest(SeeAllData=false)
public class HE_Nuevo_EnvioTEST {
    static testMethod void test1() {
        
        Account  acc=new Account();
        acc.Name='1211';
        insert acc;
        
        Contact  cont=new Contact();
        cont.contrase_a__c='1111';
        cont.Email='test@test.cl';
        cont.AccountId=acc.id;
        cont.LastName='test';
        cont.FirstName='test';
        insert cont;
        
        Account  acc2=new Account();
        acc2.Name='1111111'; 
        acc2.Nombre_Fantasia__c='Hot Express';
        insert acc2;
        
        Pais__c p=new Pais__c();
        p.Name='ARGENTINA';
        p.Cod_Pais__c='AR';
        
        p.Nombre_Zonas__c='SUR AMERICA 1';
        p.Zona_DHL__c='Zona 1';
        p.Zona_Fedex__c='Zona 1';
        p.Zona_Hot__c='Zona 1';
        insert p;
        
        Direcciones__c d=new Direcciones__c();
        d.Name='direccion test';
        d.Cuenta__c=acc.id;
        d.Direccion__c='isidora goyenechea 3000';
        d.Ciudad__c='Buenos Aires';
        d.Estado_Provincia__c='Buenos Aires';
        d.Codigo_Postal__c='7550653';
        d.Pais__c=p.id;
        insert d;
        
        Guias_de_Exportacion__c ge=new Guias_de_Exportacion__c();
        ge.Agente__c='DHL';
        ge.Peso_Referencial__c=8;
        ge.Peso_Cliente__c=8;
        ge.Peso_Agente__c=8;
        ge.Embalaje_HOT__c='cajas'; 
        ge.Telefono_Destinatario__c='+5698765442';
        ge.Correo_Electronico__c='francisca@munoz.com';
        ge.Fecha_de_Envio__c=system.today();
        ge.Paquetes__c=3;
        ge.Largo__c=2;
        ge.Ancho__c=2;
        ge.Alto__c=2;
        ge.Peso_Total__c=8;
        ge.Unidad_de_Medida__c='kilogramo';
        ge.Divisa__c='USD - U.S. Dollar';
        ge.Proposito_del_Envio__c='Efectos Personales';
        ge.Tipo_Contenido__c='Mercancías';
        ge.Direccion_Destinatario__c=d.id;
        ge.Contacto_Destinatario__c='contacto test';
        ge.ID_Remitente__c=acc.id;
        ge.Validado_por_Area_de_Finanzas__c=true;
        /*   ge.Contacto__c,
ge.Tarifa_Cliente__c,
ge.Calle__c,
ge.Ciudad__c,
ge.Cod_Postal__c,
ge.Pais__c,
ge.Valor_Combustible__c,
ge.Estado__c,
ge.Tarifa_Agente__c,
ge.Valor_Agente__c*/
        insert ge;
        Contenido_Envio__c  con=new Contenido_Envio__c();
        con.Pickup__c=ge.id;
        con.Descripcion__c='vino';
        con.Pais_fab__c=p.id;
        con.Cantidad__c=1;
        con.Unidad_de_Medida__c='Unidades';
        con.Valor_Unitario__c=15;
        insert con;
        
        Costo__c c=new Costo__c();
        c.Name='comvustible';
        insert c;
        
        Costo_de_Exportacion__c cosex=new Costo_de_Exportacion__c();
        cosex.Costo__c=c.id;
        cosex.Valor__c=8;
        cosex.Guias_de_Exportacion__c=ge.Id;
        cosex.Estado__c= 'Pendiente de Facturar';
        insert cosex;
        string us=UserInfo.getUserId();
         string datog='{"remitente":"0015A000026wpWEQAY","idp":"0030v00000QLrOtAAL","OwnerId":"'+us+'","iddir_retiro":"a0J0v000002L0t5EAC","idcontacto":"0030v00000O1yzPAAR","iddireccion":"a0J0v000002L10AEAS","Nombre":"casa rancagua","direccion":"el bosque 123","tipo_contenido":"Mercancias","Proposito_envio":"Efectos PersonalesDeshacer","ciudad":"rancagua","Estado_Provincia":"rancagus","codigo_Postal":"123434","Pais":"CHILE","contacto":"1qweq","email":"ydsasa@mal.nr","telefono":"12123","productos":[{"id":"0","code":"0","Descripcion":"test","pais_Fabricacion":"a0M0v000003pk5jEAA","Cantidad":"1","Unidad_Medida":"Unidades","Valor_Unitario":"1"}],"alto":"1","ancho":"1","largo":"1","peso":"1","DDP":"NO","Embalaje":"Cajas","attachmentName":"tabstrip.html","N_paquete":"1"}';
        string datosd='{"nombre":"casa test","Ciudad":"test","codigo_Postal":"1241","Direccion":"test","Estado_Provincia":"test","Pais":"'+p.id+'","id":"'+acc.id+'","OwnerId":"'+us+'"}';
        string datosc='{"Idcuenta":"'+acc.id+'","Nombre": "test","Apellidos":"test","Correo":"test@test.cl","Telefono": "12344","Tipo_Cargo": "Otro"}';
        apexPages.Currentpage().getParameters().put('idp',cont.id);
        apexPages.Currentpage().getParameters().put('idc',acc.id);
        apexPages.Currentpage().getParameters().put('datos',datosd);
        HE_Nuevo_Envio  he=new   HE_Nuevo_Envio();
        he.datos();
        he.guardadirecion();
        apexPages.Currentpage().getParameters().put('datos',datosc);
        
        he.guardadrcontacto();
        
       // he.guardaGuia();
        
       
    
    }
    
     static testMethod void test2() {
        
        Account  acc=new Account();
        acc.Name='1211';
        insert acc;
        
        Contact  cont=new Contact();
        cont.contrase_a__c='1111';
        cont.Email='test@test.cl';
        cont.AccountId=acc.id;
        cont.LastName='test';
        cont.FirstName='test';
        insert cont;
        
        Account  acc2=new Account();
        acc2.Name='1111111'; 
        acc2.Nombre_Fantasia__c='Hot Express';
        insert acc2;
        
        Pais__c p=new Pais__c();
        p.Name='ARGENTINA';
        p.Cod_Pais__c='AR';
        
        p.Nombre_Zonas__c='SUR AMERICA 1';
        p.Zona_DHL__c='Zona 1';
        p.Zona_Fedex__c='Zona 1';
        p.Zona_Hot__c='Zona 1';
        insert p;
        
        Direcciones__c d=new Direcciones__c();
        d.Name='direccion test';
        d.Cuenta__c=acc.id;
        d.Direccion__c='isidora goyenechea 3000';
        d.Ciudad__c='Buenos Aires';
        d.Estado_Provincia__c='Buenos Aires';
        d.Codigo_Postal__c='7550653';
        d.Pais__c=p.id;
        insert d;
        
        Guias_de_Exportacion__c ge=new Guias_de_Exportacion__c();
        ge.Agente__c='DHL';
        ge.Peso_Referencial__c=8;
        ge.Peso_Cliente__c=8;
        ge.Peso_Agente__c=8;
        ge.Embalaje_HOT__c='cajas'; 
        ge.Telefono_Destinatario__c='+5698765442';
        ge.Correo_Electronico__c='francisca@munoz.com';
        ge.Fecha_de_Envio__c=system.today();
        ge.Paquetes__c=3;
        ge.Largo__c=2;
        ge.Ancho__c=2;
        ge.Alto__c=2;
        ge.Peso_Total__c=8;
        ge.Unidad_de_Medida__c='kilogramo';
        ge.Divisa__c='USD - U.S. Dollar';
        ge.Proposito_del_Envio__c='Efectos Personales';
        ge.Tipo_Contenido__c='Mercancías';
        ge.Direccion_Destinatario__c=d.id;
        ge.Contacto_Destinatario__c='contacto test';
        ge.ID_Remitente__c=acc.id;
        ge.Validado_por_Area_de_Finanzas__c=true;
        /*   ge.Contacto__c,
ge.Tarifa_Cliente__c,
ge.Calle__c,
ge.Ciudad__c,
ge.Cod_Postal__c,
ge.Pais__c,
ge.Valor_Combustible__c,
ge.Estado__c,
ge.Tarifa_Agente__c,
ge.Valor_Agente__c*/
        insert ge;
        Contenido_Envio__c  con=new Contenido_Envio__c();
        con.Pickup__c=ge.id;
        con.Descripcion__c='vino';
        con.Pais_fab__c=p.id;
        con.Cantidad__c=1;
        con.Unidad_de_Medida__c='Unidades';
        con.Valor_Unitario__c=15;
        insert con;
        
        Costo__c c=new Costo__c();
        c.Name='comvustible';
        insert c;
        
        Costo_de_Exportacion__c cosex=new Costo_de_Exportacion__c();
        cosex.Costo__c=c.id;
        cosex.Valor__c=8;
        cosex.Guias_de_Exportacion__c=ge.Id;
        cosex.Estado__c= 'Pendiente de Facturar';
        insert cosex;
        string us=UserInfo.getUserId();
         string datog='{"remitente":"'+acc.id+'","idp":"'+cont.id+'","OwnerId":"'+us+'","iddir_retiro":"'+d.id+'","idcontacto":"'+cont.id+'","iddireccion":"'+d.id+'","Nombre":"casa rancagua","direccion":"el bosque 123","tipo_contenido":"Mercancias","Proposito_envio":"Efectos PersonalesDeshacer","ciudad":"rancagua","Estado_Provincia":"rancagus","codigo_Postal":"123434","Pais":"CHILE","contacto":"1qweq","email":"ydsasa@mal.nr","telefono":"12123","productos":[{"id":"0","code":"0","Descripcion":"test","pais_Fabricacion":"'+p.id+'","Cantidad":"1","Unidad_Medida":"Unidades","Valor_Unitario":"1"}],"alto":"1","ancho":"1","largo":"1","peso":"1","DDP":"NO","Embalaje":"Cajas","attachmentName":"tabstrip.html","N_paquete":"1"}';
        string datosd='{"nombre":"casa test","Ciudad":"test","codigo_Postal":"1241","Direccion":"test","Estado_Provincia":"test","Pais":"'+p.id+'","id":"'+acc.id+'","OwnerId":"'+us+'"}';
        apexPages.Currentpage().getParameters().put('idp',cont.id);
        apexPages.Currentpage().getParameters().put('idc',acc.id);
        apexPages.Currentpage().getParameters().put('datos',datog);
        HE_Nuevo_Envio  he=new   HE_Nuevo_Envio();
        he.datos();
          he.guardaGuia();
        
       
    
    }
}