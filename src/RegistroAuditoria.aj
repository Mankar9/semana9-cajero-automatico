import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;

import ejemplo.cajero.modelo.Cuenta;

import java.text.SimpleDateFormat;

public aspect RegistroAuditoria {
	
	private final String LOG_TRANSACCIONES = "log_transacciones.txt";
	
	private HashMap<String, String> clases = new HashMap<String, String>();
	
	pointcut inicio() : execution(public static void main(String[]));
	
	before() : inicio() {
		
		clases.put("ejemplo.cajero.control.ComandoConsignar", "Consignacion");
		clases.put("ejemplo.cajero.control.ComandoRetirar", "Retiro");
		clases.put("ejemplo.cajero.control.ComandoTransferir", "Transferencia");
		
		try {
		    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(LOG_TRANSACCIONES, true)));
		    
		    SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss z");
		    Date date = new Date(System.currentTimeMillis());
		    out.println( formatter.format(date) + ": " + "Inicio de sesión usuario");
		    out.close();
		} catch (IOException e) {
		    e.printStackTrace();
		}
	}
		
	pointcut metodosQueGeneranRegistro() : call (* ejemplo.cajero.control.*.ejecutarComando(..) );
	
	after(): metodosQueGeneranRegistro() {
		try {
		    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(LOG_TRANSACCIONES, true)));
		    
		    SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss z");
		    Date date = new Date(System.currentTimeMillis());
		    
		    String operacion = clases.get(thisJoinPoint.getSignature().getDeclaringType().getName());
		    
		    out.print(formatter.format(date) + ": " + operacion + " - ");
		    
		    switch (operacion) {
		    case "Transferencia":
		    	String origen = ((Cuenta) thisJoinPoint.getArgs()[0]).getNumero();
		    	String destino = ((Cuenta) thisJoinPoint.getArgs()[1]).getNumero();
		    	
		    	out.print("Cuenta origen: " + origen + " - ");
		    	out.print("Cuenta destino: " + destino + " - ");
		    	
		    	out.print("Valor: " + thisJoinPoint.getArgs()[2]);
		    	break;
		    default:
		    	out.print("Cuenta: " + ((Cuenta) thisJoinPoint.getArgs()[0]).getNumero() + " - ");
		    	out.print("Valor: " + thisJoinPoint.getArgs()[1]);
		    }
		    out.println();
		    
		    out.close();
		} catch (IOException e) {
		    e.printStackTrace();
		}
  	}
	
	
}	
	
