**Funcionalidade:** Incluir função gratificada para um.
		*Como* CAP
		*Eu quero* atualizar as informações do do servidor
		*Para* poder manter atualizado seu histórico.
	
**Cenário:**  Incluir gratifição para servidor sem gratficação
		*Dado* que o servidor não tem nenhuma função gratificada no momento
		*E* reune todas as condições para assumir a função
		*Quando* o ela for incluída no SIAPE
		*Então* essa nova informação deve ser atualizada no NEGEPE
 	
**Cenário:** Incluir gratificação para servidor que já tem um gratificação
		# Um servidor não pode acumular funções. Logo que uma nova for atribuída a antiga deve ser encerrada
		*Dado* que o servidor já tem uma função
		*E* reune todas as condições para assumir a nova função
		*Quando* for informada a data da nova função
		*E* a antiga função for finalizada
		*Então* a nova função deve ser atribuída

  

