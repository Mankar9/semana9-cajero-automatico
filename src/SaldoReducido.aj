import ejemplo.cajero.modelo.Cuenta;

public aspect SaldoReducido {
	
	private final int SALDO_MINIMO = 200000;

	pointcut retiroCuenta() : call (* ejemplo.cajero.modelo.Cuenta.retirar(..) throws * );
	
	before() throws Exception : retiroCuenta() { 
		
		long valor = (long) thisJoinPoint.getArgs()[0];
		Cuenta cuenta = (Cuenta) thisJoinPoint.getTarget();

		if (cuenta.getSaldo() - valor <= SALDO_MINIMO) {
			throw new Exception("Este cajero no permite cuentas con saldo menor al mínimo (" + SALDO_MINIMO + ")");
		}
	
	}
	
}
