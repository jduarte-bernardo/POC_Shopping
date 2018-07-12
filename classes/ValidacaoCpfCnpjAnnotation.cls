global class ValidacaoCpfCnpjAnnotation {
	@InvocableMethod
    public static List<String> validar_cpf_cnpj(List<String> cpfsCnpjs){
        //'valido' = cpf ou cnpj válido
        //'invalido' = cpf ou cnpj em formato inválido
        //'[Account Id]' = cpf ou cnpj já em uso com outra Account
        List<String> retornos = new List<String>();
       
        for(String cpfCnpj : cpfsCnpjs ){  
            String cpfCnpjOnlyNumbers = cpfCnpj.replaceAll('[^0-9]', '');
            
            if(cpfCnpjOnlyNumbers.length() == 11){
                retornos.add(ValidacaoCpfCnpjHandler.validar_cpf(cpfCnpjOnlyNumbers));
            }else if(cpfCnpjOnlyNumbers.length() == 14){
                retornos.add(ValidacaoCpfCnpjHandler.validar_cnpj(cpfCnpjOnlyNumbers));
            }else{
                retornos.add(Util.INVALIDO);
            }
        }
        
        return retornos;
    }
}