/**********************************************************************************
Desarrollado por: Nectia / SEIDOR Chile.
Autor: Jorge Carvajal (JC)
Proyecto:  
Modificado por: Rodrigo López (RL)
Descripción:  
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 19-06-2020            JC                   Creación de la Clase.
1.1 05-06-2023            RL                   Se agrega método "test02" para cubrir función "facturarV2"
***********************************************************************************/

@istest(SeeAllData=false)
public class HE_listado_clientesTEST {
    static testMethod void test1() {
        Account  acc=new Account();
        acc.Name='1211';
        acc.Giro__c='SERVICIOS FUNERARIOS';
        
        insert acc;
        
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
        /*ge.Contacto__c,
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
        
        //  apexPages.Currentpage().getParameters().put('id',dm.Master__c);
        //  ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        
        apexPages.Currentpage().getParameters().put('FI','01-06-2019');
        apexPages.Currentpage().getParameters().put('FN','01-06-2025');
        apexPages.Currentpage().getParameters().put('V','600');
        apexPages.Currentpage().getParameters().put('td','1');
        apexPages.Currentpage().getParameters().put('tc','');
        apexPages.Currentpage().getParameters().put('ida',acc.id);
        apexPages.Currentpage().getParameters().put('idcon','');
        apexPages.Currentpage().getParameters().put('ps','');
        apexPages.Currentpage().getParameters().put('zon','');
        apexPages.Currentpage().getParameters().put('ta','1');
        HE_listado_clientes  he=new HE_listado_clientes();   
        he.Obtenerclientes();
        string  datos='[{"id":"'+acc.Id+'","name":"MUNDO DEL VINO ISIDORA","giro":"SERVICIOS FUNERARIOS","fechafacturacion":"30-04-2021","RUT":"96856980-5","comuna":"santiago","direccion":"isidora goyenechea  3000","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000019","pais_destino":"ARGENTINA","tipo":"Mercancías","fecha":"2020-06-17","montoUSD":"297.60","montoCLP":"59520"}]},{"id":"0015A000026wpaNQAQ","name":"VINOS RAVANAL LTDA.","giro":"SERVICIOS FUNERARIOS","RUT":"76242685-4","fechafacturacion":"30-04-2021","comuna":"San Fernando","direccion":"OSCAR GAJARDO S/N Placilla","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000025","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"100.00","montoCLP":"20000"},{"idguia":"'+ge.id+'","idproducto":"GE-0000000022","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"137.22","montoCLP":"27444"}]}]';
        apexPages.Currentpage().getParameters().put('datos',datos);
        he.facrturar();
        he.consultarCostosguia();
    } 
    
    static testMethod void test02() {
        Account  acc=new Account();
        acc.Name='1211';
        acc.Giro__c='SERVICIOS FUNERARIOS';
        
        insert acc;
        
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

        Test.setMock(HttpCalloutMock.class, new HE_ServicioBsoftMock());
        Test.startTest();
            apexPages.Currentpage().getParameters().put('FI','01-06-2019');
            apexPages.Currentpage().getParameters().put('FN','01-06-2025');
            apexPages.Currentpage().getParameters().put('V','600');
            apexPages.Currentpage().getParameters().put('td','1');
            apexPages.Currentpage().getParameters().put('tc','');
            apexPages.Currentpage().getParameters().put('ida',acc.id);
            apexPages.Currentpage().getParameters().put('idcon','');
            apexPages.Currentpage().getParameters().put('ps','');
            apexPages.Currentpage().getParameters().put('zon','');
            apexPages.Currentpage().getParameters().put('ta','1');
            HE_listado_clientes  he=new HE_listado_clientes();   
            he.Obtenerclientes();
            string  datos='[{"id":"'+acc.Id+'","name":"MUNDO DEL VINO ISIDORA","giro":"SERVICIOS FUNERARIOS","fechafacturacion":"30-04-2021","RUT":"96856980-5","comuna":"santiago","direccion":"isidora goyenechea  3000","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000019","pais_destino":"ARGENTINA","tipo":"Mercancías","fecha":"2020-06-17","montoUSD":"297.60","montoCLP":"59520"}]},{"id":"0015A000026wpaNQAQ","name":"VINOS RAVANAL LTDA.","giro":"SERVICIOS FUNERARIOS","RUT":"76242685-4","fechafacturacion":"30-04-2021","comuna":"San Fernando","direccion":"OSCAR GAJARDO S/N Placilla","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000025","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"100.00","montoCLP":"20000"},{"idguia":"'+ge.id+'","idproducto":"GE-0000000022","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"137.22","montoCLP":"27444"}]}]';
            apexPages.Currentpage().getParameters().put('datos',datos);
            he.facturarV2();
            he.consultarCostosguia();
        Test.stopTest();
    }
    
    
}