@istest(SeeAllData=false)
public class HE_ServiciosTEST {
 static testMethod void test1() {
        
        
        HE_Servicios  he=new HE_Servicios();   
       he.callOutconsultaZPL(null);
       he.callOutConvenioEmpresa(null);
        
    
    } 
}