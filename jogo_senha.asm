#------------------------------------------------------------------------------
# Programa jogo_senha: INCOMPLETO
#------------------------------------------------------------------------------
# Grupo: COMPLETAR COM NOME DOS ALUNOS
#------------------------------------------------------------------------------
# Para visualização do programa fonte:
#		Ir em Settings->Editor
#		Configurar Tab Size com 3
#------------------------------------------------------------------------------
# Atenção:
# Em todas as rotinas do programa:
#		Registradores $t* podem ser utilizados/modificados sem salvar/restaurar valores anteriores
#		Registradores $s* devem ser salvos/restaurados se forem modificados
#------------------------------------------------------------------------------
# Instruções para execução:
#		Após montar o programa, ir em Tools -> Bitmap display
#		Configurar display bitmap com:
#			Unit Width in Pixels: 16
#			Unit Height in Pixels: 16
#			Display Width in Pixels: 256
#			Display Height in Pixels: 512
#			Base address for display: ($gp)
#		Dar "Connect to MIPS"
#		Executar programa
#		Antes de executar de novo, dar "Reset"
#------------------------------------------------------------------------------
						.text										# Seção de código
#------------------------------------------------------------------------------
# PROGRAMA PRINCIPAL
# Algoritmo:
#		// Inicialização
#		Imprime mensagens iniciais
#		mostra_tabuleiro()
#		gera_senha()
#		n_tentativas = 0
#		// Laço para permitir várias tentativas
#		do
#		{
#			le_chute(n_tentativas)
#			mostra_chute(n_tentativas)
#			cor_certa_posicao_certa, cor_certa_posicao_errada = compara_chute_senha()
#			mostra_avaliacao(cor_certa_posicao_certa, cor_certa_posicao_errada)
#			n_tentativas ++
#		}
#		while (n_tentativas != max_tentativas) and (cor_certa_posicao_certa != tam_senha)
#		// Finalização
#		if cor_certa_posicao_certa == tam_senha
#			Imprime mensagem de acerto
#		else
#			Imprime mensagem de erro
#		mostra_senha()
#
# Uso dos registradores:
#		COMPLETAR
#		$a0: parâmetro para chamadas ao sistema
#		$v0: parâmetro para chamadas ao sistema

						# Inicialização
main:					addi	$v0, $zero, 4					# Chamada ao sistema para escrever string na tela
						la		$a0, msg1						# $a0 = endereço da string a ser escrita na tela
						syscall
						addi	$v0, $zero, 1					# Chamada ao sistema para escrever inteiro na tela
						lw		$a0, tam_senha					# $a0 = inteiro a ser escrito na tela (tam_senha)
						syscall
						addi	$v0, $zero, 4					# Chamadas ao sistema para escrever string na tela
						la		$a0, msg2						# $a0 = endereço da string a ser escrita na tela
						syscall
						la		$a0, msg3
						syscall
						la		$a0, msg4
						syscall
						la		$a0, msg5
						syscall
						la		$a0, msg6
						syscall
						la		$a0, msg7
						syscall
						addi	$v0, $zero, 1					# Chamada ao sistema para escrever inteiro na tela
						lw		$a0, max_tentativas			# $a0 = inteiro a ser escrito na tela (max_tentativas)
						syscall
						addi	$v0, $zero, 4					# Chamada ao sistema para escrever string na tela
						la		$a0, msg8						# $a0 = endereço da string a ser escrita na tela
						syscall
						jal	mostra_tabuleiro				# Desenha tabuleiro no display
						jal	gera_senha						# Gera senha aleatoreamente 
						addi $t7, $zero, 0					# inicializa parametro for das tentativas
						lw  $t8, max_tentativas ($zero)					
loop_main: 			slt  $t4, $t7, $t8         		# Se i < n então $t4 = 1 senão $t4 = 0
          			beq  $t4, $zero, fim_loop_main
          			jal le_chute 							# chama le chute
          			add $a0, $zero, $t7					# seta parametro usado no mostra_chute
          			jal mostra_chute                 # chama mostra chute
          														# seta parametro para chamada compara_chute_senha
          														# chama compara_chute_senha
          														# seta parametro mostra_avaliacao
          														# chama mostra avaliacao   
						addi $t7, $t7, 1 						# incrementa variavel utilizada no loop_main
						j loop_main
fim_loop_main: 

						jal mostra_senha
								
						addi $v0, $zero,10					# Chamada ao sistema para encerrar programa
						syscall
#------------------------------------------------------------------------------
# ROTINA gera_senha
#		Gera senha de tam_senha posições e armazena no vetor senha na memória
#		Cada posição da senha é um inteiro, entre 0 e total_cores - 1, que representa uma cor
#		(0 = vermelho, 1 = verde, 2 = azul, 3 = amarelo, 4 = rosa)
#		Valor de cada posição da senha é gerado aleatoriamente e não pode se repetir
#		(isto é, uma mesma cor não pode aparecer mais de uma vez na senha)
#		Obs.: Usar syscall 42 para gerar número aleatório
# Algoritmo:
#		COMPLETAR
# Uso dos registradores:
#		COMPLETAR

gera_senha:	
						# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						la  $t0, senha						#$t0 = endereço da senha
						lw  $t1, tam_senha($zero) 		#$t1 = tamanho da senha
						add $t2, $zero, $zero 			#$t2 = 0 //contador de inclusão
						add $t3, $zero, $zero 			#$t3 = 0 //contador de verificacao
						#gerando random
						li $a1, 5 
						li $v0, 42							#a0 = random
randPwd: 				syscall
#verifica se o vetorSenha contem o valor
loopPwd:				slt $t4, $t3, $t2					
						beq $t4, $zero addPwd			#finalizar loop
						addi $t3, $t3 1					#incrementa contadorVerificacao
						lw $t5, senha($zero)				#t5 = senha[t1+t2]
						beq $t5, $a0 randPwd	
						j loopPwd
#Adiciona random gerado ao endereço
addPwd:				add $t3, $zero, $zero 			#$t3 = 0
						mul $t4, $t2, 4					
						add $t4, $t4, $t0	
						sw $a0, 0($t4)
						addi $t2, $t2, 1
						slt $t5, $t2, $t1 
						bne $t5, $zero randPwd		
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA le_chute
# Algoritmo:
#		Imprime mensagens iniciais
#		for (i = 0 ; i < tam_senha ; i ++)
#			chute[i] = número inteiro lido do teclado
# Parâmetros:
#		$a0: n_tentativas
# Uso dos registradores:
#		COMPLETAR

le_chute:			# COMPLETAR
						# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						la  $t1, chute # carrega em $t1 posicao inicial chute
						add $t2, $zero, 0
						lw  $t3, tam_senha ($zero)					
loop_le_chute: 	slt  $t4, $t2, $t3         # Se i < n então $t5 = 1 senão $t5 = 0
          			beq  $t4, $zero, fim_loop_le_chute
						addi $v0, $zero, 5 # le inteiro do teclado
						syscall
						sw   $v0, 0 ($t1)
						addi $t1, $t1, 4
						addi $t2, $t2, 1 
						j loop_le_chute
fim_loop_le_chute:
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA compara_chute_senha
#		Avalia chute comparando com senha e calcula:
#		cor_certa_posicao_certa: número de pinos do chute com cor certa e na posição certa
#		cor_certa_posicao_errada: número de pinos do chute com cor certa e na posição errada
# Algoritmo:
#		cor_certa_posicao_certa = 0
#		cor_certa_posicao_errada = 0
#		for (i = 0 ; i < tam_senha ; i ++)
#		{
#			if chute[i] == senha[i]
#				cor_certa_posicao_certa ++
#			else
#			{
#				for (j = 0 ; j < tam_senha ; j ++)
#				{
#					if chute[i] == senha[j]
#						cor_certa_posicao_errada ++
#				}
#			}
#		}
#		Retorna cor_certa_posicao_certa, cor_certa_posicao_errada
# Valores de retorno:
#		$v0: cor_certa_posicao_certa
#		$v1: cor_certa_posicao_errada
# Uso dos registradores:
#		COMPLETAR

compara_chute_senha:	# COMPLETAR
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA mostra_tabuleiro
#		Desenha tabuleiro no display
# Rotina tem chamada aninhada de rotinas:
#		Salva/restaura endereço de retorno ($ra) na/da pilha
# Uso dos registradores:
#		$a0: índice da linha do display
#		$a1: índice da coluna do display
#		$a2: cor do pixel a ser desenhado no display
#		$t0: max_tentativas
#		$t1: índice t da tentativa
#		$t2: número de colunas do chute
#		$t3: número de colunas da avaliação
#		$t4: número de colunas do tabuleiro

mostra_tabuleiro:	# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						lw		$t0, max_tentativas			# $t0 = max_tentativas
						add	$t1, $zero, $zero				# t = 0
						add	$a0, $zero, $zero				# linha = 0
						lw		$t2, tam_senha					# número de colunas do chute = tamanho da senha * 2
						sll	$t2, $t2, 1
						lw		$t3, tam_senha					# número de colunas da avaliação = tamanho da senha
						add	$t4, $t2, $t3					# número de colunas do tabuleiro = número de colunas do chute + número de colunas da avaliação + 3 (divisórias)
						addi	$t4, $t4, 3
						lw		$a2, branco						# Cor das divisórias: branco
						# Laço para desenhar max_tentativas espaços de chute
loop_tentativa2:	# Desenha divisória horizontal em branco
						add	$a1, $zero, $zero				# coluna = 0
loop_coluna1:		jal	mostra_pixel					# Laço para desenhar pixels da divisória horizontal em branco
						addi	$a1, $a1, 1						# coluna ++
						bne	$a1, $t4, loop_coluna1
						addi	$a0, $a0, 1						# linha ++
						# Desenha espaço do chute vazio com divisórias verticais
						add	$a1, $zero, $zero				# coluna = 0
						jal	mostra_pixel
						addi	$a1, $a1, 1						# coluna ++
						add	$a1, $a1, $t2					# coluna = coluna + número de colunas do chute
						jal	mostra_pixel			
						addi	$a1, $a1, 1						# coluna ++
						add	$a1, $a1, $t3					# coluna = coluna + número de colunas da avaliação
						jal	mostra_pixel			
						addi	$a0, $a0, 1						# linha ++
						add	$a1, $zero, $zero				# coluna = 0
						jal	mostra_pixel
						addi	$a1, $a1, 1						# coluna ++
						add	$a1, $a1, $t2					# coluna = coluna + número de colunas do chute
						jal	mostra_pixel			
						addi	$a1, $a1, 1						# coluna ++
						add	$a1, $a1, $t3					# coluna = coluna + número de colunas da avaliação
						jal	mostra_pixel			
						addi	$a0, $a0, 1						# linha ++
						addi	$t1, $t1, 1						# t ++
						bne	$t1, $t0, loop_tentativa2
						# Fim do laço para desenhar max_tentativas espaços de chute			
						# Desenha divisória horizontal em branco
						add	$a1, $zero, $zero				# coluna = 0
loop_coluna2:		jal	mostra_pixel					# Laço para desenhar pixels da divisória horizontal em branco
						addi	$a1, $a1, 1						# coluna ++
						bne	$a1, $t4, loop_coluna2
						addi	$a0, $a0, 1						# linha ++
						# Desenha espaço da senha
						# Desenha divisória horizontal em branco
						add	$a1, $zero, $zero				# coluna = 0
loop_coluna3:		jal	mostra_pixel					# Laço para desenhar pixels da divisória horizontal em branco
						addi	$a1, $a1, 1						# coluna ++
						bne	$a1, $t4, loop_coluna3
						addi	$a0, $a0, 1						# linha ++
						# Desenha divisória horizontal em branco
						add	$a1, $zero, $zero				# coluna = 0
loop_coluna4:		jal	mostra_pixel					# Laço para desenhar pixels da divisória horizontal em branco
						addi	$a1, $a1, 1						# coluna ++
						bne	$a1, $t4, loop_coluna4
						addi	$a0, $a0, 1						# linha ++
						# Desenha divisória horizontal em branco
						add	$a1, $zero, $zero				# coluna = 0
loop_coluna5:		jal	mostra_pixel					# Laço para desenhar pixels da divisória horizontal em branco
						addi	$a1, $a1, 1						# coluna ++
						bne	$a1, $t4, loop_coluna5
						# Desenha senha escondida
						add	$t1, $zero, $zero				# i = 0
						sll	$a0, $t0, 1						# linha = 3 * max_tentativas + 1
						add	$a0, $a0, $t0
						addi	$a0, $a0, 1
						addi	$a1, $t1, 1						# coluna inicial = i + 1
						lw		$a2, cinza						# Cor da senha escondida: cinza
loop_coluna6:		jal	mostra_pixel					#
						addi	$a0, $a0, 1						# linha ++
						jal	mostra_pixel					#
						addi	$a0, $a0, -1					# linha --
						addi	$t1, $t1, 1						# i ++
						addi	$a1, $a1, 1						# coluna ++
						bne	$t1, $t2, loop_coluna6		# Se i = número de colunas da senha, sai do loop_coluna6
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA mostra_chute
#		Desenha chute no display
# Rotina tem chamada aninhada de rotinas:
#		Salva/restaura endereço de retorno ($ra) na/da pilha
# Parâmetros:
#		$a0: n_tentativas
# Uso dos registradores:
#		$a0: índice da linha do display
#		$a1: índice da coluna do display
#		$a2: cor do pixel a ser desenhado no display
#		$t0: tam_senha
#		$t1: i (índice do chute, de 0 a tam_senha - 1)
#		$t2: n_tentativas

mostra_chute:		# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						add	$t2, $a0, $zero				# $t2 = n_tentativas
						# Laço para mostrar cores do chute
						add	$t1, $zero, $zero				# i = 0
						lw		$t0, tam_senha					# $t0 = tam_senha
loop_chute3:													# Obtém cor do chute[i] (valor RGB da cor)
						sll	$a2, $t1, 2						# $a2 = 4 * i
						lw		$a2, chute ($a2)				# $a2 = chute[i] (cor de 0 a total_cores - 1)
						sll	$a2, $a2, 2						# $a2 = 4 * chute[i]
						lw		$a2, cor ($a2)					# $a2 = cor[chute[i]]
						# Calcula linha e coluna dos 4 pixels do chute[i] no display e desenha
						sll	$a0, $t2, 1						# linha = 3 * n_tentativas + 1
						add	$a0, $a0, $t2
						addi	$a0, $a0, 1
						sll	$a1, $t1, 1						# coluna = 2 * i + 1
						addi	$a1, $a1, 1
						jal	mostra_pixel					# Desenha pixel [3 * n_tentativas + 1, 2 * i + 1]
						addi	$a1, $a1, 1						# coluna ++
						jal	mostra_pixel					# Desenha pixel [3 * n_tentativas + 1, 2 * i + 2]
						addi	$a0, $a0, 1						# linha ++
						addi	$a1, $a1, -1					# coluna --
						jal	mostra_pixel					# Desenha pixel [3 * n_tentativas + 2, 2 * i + 1]
						addi	$a1, $a1, 1						# coluna ++
						jal	mostra_pixel					# Desenha pixel [3 * n_tentativas + 2, 2 * i + 2]
						addi	$t1, $t1, 1						# i ++
						bne	$t1, $t0, loop_chute3		# Se i = tam_senha, sai do loop_chute3
						# Fim do laço para mostrar cores do chute
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA mostra_avaliacao
#		Desenha avaliacao no display
# Rotina tem chamada aninhada de rotinas:
#		Salva/restaura endereço de retorno ($ra) na/da pilha
# Parâmetros:
#		$a0: n_tentativas
#		$a1: cor_certa_posicao_certa
#		$a2: cor_certa_posicao_errada
# Uso dos registradores:
#		$a0: índice da linha do display
#		$a1: índice da coluna do display
#		$a2: cor do pixel a ser desenhado no display
#		$t0: limites dos laços
#		$t1: i
#		$t2: n_tentativas
#		$t3: cor_certa_posicao_certa
#		$t4: cor_certa_posicao_errada
#		$t5: linha inicial da avaliação no display
#		$t6: coluna inicial da avaliação no display

mostra_avaliacao:	# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						add	$t2, $a0, $zero				# $t2 = n_tentativas
						add	$t3, $a1, $zero				# $t3 = cor_certa_posicao_certa
						add	$t4, $a2, $zero				# $t4 = cor_certa_posicao_errada
						# Posição inicial da avaliação no tabuleiro
						sll	$t5, $t2, 1						# linha_inicial = 3 * n_tentativas + 1
						add	$t5, $t5, $t2
						addi	$t5, $t5, 1
						lw		$t6, tam_senha					# coluna_inicial = n_colunas_chute + 2
						sll	$t6, $t6, 1						#                = (tamanho da senha * 2) + 2
						addi	$t6, $t6, 2
						# Laço para mostrar avaliação de cor certa na posição certa
						add	$t1, $zero, $zero				# i = 0
						add	$t0, $t3, $zero				# $t0 = limite do laço = cor_certa_posicao_certa
						lw		$a2, ciano						# Cor da avaliação cor certa na posição certa: ciano																	
loop_aval1:			beq	$t1, $t0, fim_loop_aval1	# Se i == cor_certa_posicao_certa, sai do loop_aval1
						rem	$a0, $t1, 2						# linha = linha_inicial + (i mod 2)
						add	$a0, $t5, $a0					#
						add	$a1, $t6, $t1					# coluna = coluna_inicial + i
						jal	mostra_pixel					# Desenha pixel
						addi	$t1, $t1, 1						# i ++
						j		loop_aval1
fim_loop_aval1:	# Fim do laço para mostrar avaliação de cor certa na posição certa
						# Laço para mostrar avaliação de cor certa na posição errada
						add	$t1, $t3, $zero				# i = cor_certa_posicao_certa
						add	$t0, $t3, $t4					# $t0 = limite do laço = cor_certa_posicao_certa + cor_certa_posicao_errada
						lw		$a2, roxo						# Cor da avaliação cor certa na posição errada: roxo																	
loop_aval2:			beq	$t1, $t0, fim_loop_aval2	# Se i == cor_certa_posicao_certa + cor_certa_posicao_errada, sai do loop_aval2
						rem	$a0, $t1, 2						# linha = linha_inicial + (i mod 2)
						add	$a0, $t5, $a0					#
						add	$a1, $t6, $t1					# coluna = coluna_inicial + i
						jal	mostra_pixel					# Desenha pixel
						addi	$t1, $t1, 1						# i ++
						j		loop_aval2
fim_loop_aval2:	# Fim do laço para mostrar avaliação de cor certa na posição errada
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA mostra_senha
#		Desenha senha no display
# Rotina tem chamada aninhada de rotinas:
#		Salva/restaura endereço de retorno ($ra) na/da pilha
# Uso dos registradores:
#		$a0: índice da linha do display
#		$a1: índice da coluna do display
#		$a2: cor do pixel a ser desenhado no display
#		$t0: tam_senha
#		$t1: i (índice da senha, de 0 a tam_senha - 1)
#		$t2: max_tentativas

mostra_senha:		# Prólogo
						addi	$sp, $sp, -4					# Aloca espaço para uma palavra na pilha
						sw		$ra, 0 ($sp)					# Salva $ra (endereço de retorno da rotina) na pilha
						# Inicialização
						lw		$t2, max_tentativas			# $t2 = max_tentativas
						# Laço para mostrar cores da senha
						add	$t1, $zero, $zero				# i = 0
						lw		$t0, tam_senha					# $t0 = tam_senha
loop_senha3:													# Obtém cor de senha[i] (valor RGB da cor)
						sll	$a2, $t1, 2						# $a2 = 4 * i
						lw		$a2, senha ($a2)				# $a2 = senha[i] (cor de 0 a total_cores - 1)
						sll	$a2, $a2, 2						# $a2 = 4 * senha[i]
						lw		$a2, cor ($a2)					# $a2 = cor[senha[i]]
						# Calcula linha e coluna dos 4 pixels de senha[i] no display e desenha
						sll	$a0, $t2, 1						# linha = 3 * max_tentativas + 1
						add	$a0, $a0, $t2
						addi	$a0, $a0, 1
						sll	$a1, $t1, 1						# coluna = 2 * i + 1
						addi	$a1, $a1, 1
						jal	mostra_pixel					# Desenha pixel [3 * max_tentativas + 1, 2 * i + 1]
						addi	$a1, $a1, 1						# coluna ++
						jal	mostra_pixel					# Desenha pixel [3 * max_tentativas + 1, 2 * i + 2]
						addi	$a0, $a0, 1						# linha ++
						addi	$a1, $a1, -1					# coluna --
						jal	mostra_pixel					# Desenha pixel [3 * max_tentativas + 2, 2 * i + 1]
						addi	$a1, $a1, 1						# coluna ++
						jal	mostra_pixel					# Desenha pixel [3 * max_tentativas + 2, 2 * i + 2]
						addi	$t1, $t1, 1						# i ++
						bne	$t1, $t0, loop_senha3		# Se i = tam_senha, sai do loop_senha3
						# Fim do laço para mostrar cores da senha
						# Epílogo
						lw		$ra, 0 ($sp)					# Restaura $ra (endereço de retorno da rotina) da pilha
						addi	$sp, $sp, 4						# Libera espaço de uma palavra na pilha	
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
# ROTINA mostra_pixel
# Algoritmo:
#		Calcula endereço do pixel (linha,coluna) no display
#		endereço = endereço base do display + ((linha * número de colunas do display) + coluna) * 4
#		Escreve cor do pixel nessa posição
# Parâmetros:
#		$a0: índice da linha do display
#		$a1: índice da coluna do display
#		$a2: cor do pixel a ser desenhado no display
# Uso dos registradores:
#		$t9: endereço do pixel (linha,coluna) no display
#		$gp: endereço base do display

mostra_pixel:		lw		$t9, n_colunas_display		# $t9 = número de colunas do display
						mul	$t9, $a0, $t9					# $t9 = linha * número de colunas do display
						add	$t9, $t9, $a1					# $t9 = (linha * num. colunas do display) + coluna
						sll	$t9, $t9, 2						# $t9 = ((linha * num. colunas do display) + coluna) * 4
						add	$t9, $gp, $t9					# $t9 = endereço base do display bitmap + ((linha * num. colunas do display) + coluna) * 4
						sw		$a2, 0 ($t9)					# Escreve cor do pixel na área de memória do display: pixel é mostrado no display
						jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
						.data										# Seção de dados
#------------------------------------------------------------------------------
						# Variáveis e estruturas de dados do programa
						# COMPLETAR, SE NECESS�?RIO
max_tentativas:	.word 9									# Número máximo de tentativas
tam_senha:			.word 3									# Número de posições na senha e no chute
total_cores:		.word 5									# Número total de cores disponíveis para escolha da senha e do chute
senha:				.word 0 0 0								# Senha: vetor de inteiros, com tam_senha posições
chute:				.word 0 0 0								# Chute: vetor de inteiros, com tam_senha posições
																	# Cada posição da senha e do chute possui um valor, entre 0 e total_cores - 1,
																	# que representa uma cor (0 = vermelho, 1 = verde, 2 = azul, 3 = amarelo, 4 = rosa)
						# Strings para impressão de mensagens
msg1:					.asciiz "Jogo Senha: Tente adivinhar as cores dos "
msg2:					.asciiz " pinos da senha, na ordem correta.\n"
msg3:					.asciiz "Cada pino possui uma cor diferente: 0 = vermelho, 1 = verde, 2 = azul, 3 = amarelo, 4 = rosa\n"
msg4:					.asciiz "A avaliação indica: - número de pinos do chute com cor certa na posição certa (em ciano)\n"
msg5:					.asciiz "                    - número de pinos do chute com cor certa na posição errada (em roxo)\n"
msg6:					.asciiz "A ordem dos pontos da avaliação NÃO corresponde à ordem dos pinos no chute.\n"
msg7:					.asciiz "Número máximo de tentativas: "
msg8:					.asciiz "\n"
msg9:					.asciiz "\nTentativa "
msg10:				.asciiz ": digite "
msg11:				.asciiz " números, dando enter após cada um (0 = vermelho, 1 = verde, 2 = azul, 3 = amarelo, 4 = rosa).\n"
msg12:				.asciiz "\nVocê acertou a senha. Veja no display.\n"
msg13:				.asciiz "\nVocê não acertou a senha. Veja no display.\n"
						# Variáveis e estruturas de dados para uso do display: NÃO MODIFICAR
n_colunas_display:.word 16									# Número de pixels em uma linha do display = Display Width in Pixels / Unit Width in Pixels = 256/8 = 32
cor:					.word 0x00FF0000 0x0000FF00 0x000000FF 0x00FFFF00 0x00FF0090	# cor: vetor de inteiros com total_cores posições,
																											# com cores disponíveis para senha e chutes -
																											# vermelho, verde, azul, amarelo, rosa (em RGB)
branco:				.word 0x00FFFFFF						# Cor branco (em RGB)
cinza:				.word 0x00808080						# Cor cinza (em RGB)
ciano:				.word 0x0000FFFF						# Cor ciano (em RGB)
roxo:					.word 0x009000FF						# Cor roxo (em RGB)

#------------------------------------------------------------------------------
