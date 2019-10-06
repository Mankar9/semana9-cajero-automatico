import ejemplo.cajero.Cajero;

public aspect ListarOperaciones {
	// TODO Auto-generated aspect
	
	pointcut fin() : execution(public static void main(String[]));
	
	after() : fin() {
		Cajero.imprimirTransacciones();
	}
}
