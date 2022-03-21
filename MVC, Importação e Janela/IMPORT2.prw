#include 'Protheus.ch'
#include 'FWMBROWSE.ch'
#include 'FWMVCDEF.ch'
#include "topconn.ch"
#include "totvs.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function IMPORT2()      *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que Importa os dados     *******************************|
    |******************************* para o protheus                  *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

	User Function IMPORT2() 

		//Variavel que ira amarzenar o diretório cGetFile
		Local cDiret    
        //Variavel que ira participar da quebra do CSV tirando com o limitador ";"
		Local cLinha  := ""      
        //Variavel do tipo logico que sera utilizada para verificar a primeira linha da Phanilha
		Local lPrimlin   := .T.      
        //Variavel que grava os campos (O cabeçario)
		Local aCampos := {}       
	    //Variavel que grava as linas  (As informaçoes)
		Local aDados  := {}    
		//Variavel de contagem 
		Local i
		//Variavel de contagem 
		Local j 
		//Variavel de contagem 
		Local _k

		//Função - Interface com o Usuário
		if !isblind()                                                                                                                             
			PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SZ8'
		ENDIF 


			Private aErro := {}

			    //Função cGetFile (Responsável por puxar o arquivo)                                        
				cDiret :=  cGetFile('Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //Nome do Arquivo  
						'Selecao de Arquivos',;                                                 //Nome da janela aberta  
							0,;                                                                 //Indica o número da Máscara  
						'C:\Teste de importação',;                                              //Diretório automático  
						.F.,;                                                                   //Indica se é um "save dialog" ou um "open dialog".
						nOR(GETF_LOCALHARD,  GETF_NETWORKDRIVE, ) ,;                            // GETF_LOCALHARD Apresenta a unidade do disco local - GETF_NETWORKDRIVE Apresenta as unidades da rede (mapeamento). 
						.T.,;
						.T.)                                                                    //Indica se, verdadeiro (.T.), apresenta o árvore do servidor; caso contrário, falso (.F.).


				//Régua de procesamento 
				//Abre e fecha um arquivo texto 
				FT_FUSE(cDiret)       
				//A função ProcRegua() é utilizada para definir o valor máximo da régua de progressão criada através da função Processa(). FT_FLASTREC Lê e retorna o número total de linhas do arquivo texto aberto pela função FT_FUse()    
				ProcRegua(FT_FLASTREC())  
				//Posiciona no início (primeiro caracter da primeira linha) do arquivo texto aberto pela função
				FT_FGOTOP()                        
			//Laço que lê todo o arquivo/ a função !FT_FEOF Indica se o ponteiro está posicionado no fim do arquivo texto.
			While !FT_FEOF() 
            //Valores na régua de progressão
			IncProc("Lendo arquivo texto...")   
			//Lê e retorna uma linha de texto do arquivo aberto pela função FT_FUse(). As linhas do texto, são delimitadas pela sequência de caracteres CRLF
			cLinha := FT_FREADLN()                                   
			//A variavel lPrimlin é verificada uma unica vez, para indentificar a primeira linha do arquivo que é a linha de cabeçario 
			If lPrimlin   
            //Se for .T. ele Alimentara o "Array aCampos" com a primeira linha do CSV
			aCampos := Separa(cLinha,";",.T.)  
			//E logo em sequencia voltara .F. as proximas linhas não entrara nessa condição
			lPrimlin := .F.      
			Else
			//Prenenchimento do "Array aDados"
			AADD(aDados,Separa(cLinha,";",.T.)) 
			EndIf
			FT_FSKIP()
			EndDo
	
			//Substitui a primeira linha ou seja o cabeçario com os titulos da planilha para os nomes dos campos do dicionario de dados 

			//Utilizada para definir o valor máximo da régua de progressão
			ProcRegua(Len(aCampos))       
			//Define a área de trabalho especificada como ativa. Todas as operações subsequentes serão realizadas nesta área de trabalho
			For _K:=1 to Len(aCampos) 
			//Esta ordem é responsável sequência lógica dos registros da tabela corrente.   
			dbSetOrder(1)      
			dbGoTop()

	    //independente da posição dos campos, as colunas vão ser posicionadas de acordo com a ordem abaixo:
				If aCampos[_k] == "Ação"
				aCampos[_k]:='Z8_ACAO'

				elseif aCampos[_k] == "Segmento de Listagem"
					aCampos[_k]:=  'Z8_SEGMEN'

				elseif aCampos[_k] == "Setores"
					aCampos[_k]:=  'Z8_SETORES'

				elseif aCampos[_k] == "Aprovado para Estudo?"
					aCampos[_k]:=  'Z8_ESTUDO'

				elseif aCampos[_k] == "Preço"
					aCampos[_k]:=  'Z8_PRECO''

				elseif aCampos[_k] == "Valor Intrínsico de Graham"
					aCampos[_k]:=  'Z8_VLINTRI''

				elseif aCampos[_k] == "Margem de Segurança de Graham"
					aCampos[_k]:=  'Z8_MARSEG'

				elseif aCampos[_k] == "Dividendos Últimos 12 Meses"
					aCampos[_k]:=  'Z8_DIVIDEN'

				elseif aCampos[_k] == "Dividend Yield"
					aCampos[_k]:=  'Z8_DIVYIEL'

				elseif aCampos[_k] == "Payout"
					aCampos[_k]:= 'Z8_PAYOUT'

				elseif aCampos[_k] == "P/L"
					aCampos[_k]:= 'Z8_PL'

				elseif aCampos[_k] == "LPA"
					aCampos[_k]:= 'Z8_LPA'

				elseif aCampos[_k] == "P/VP"
					aCampos[_k]:= 'Z8_PVP'

				elseif aCampos[_k] == "VPA"
					aCampos[_k]:= 'Z8_VPA'

				elseif aCampos[_k] == "ROE"
					aCampos[_k]:= 'Z8_ROE' 

				elseif aCampos[_k] == "ROA"
					aCampos[_k]:= 'Z8_ROA'

				elseif aCampos[_k] == "ROIC"
					aCampos[_k]:= 'Z8_ROIC'

				elseif aCampos[_k] == "Margem Bruta"
					aCampos[_k]:= 'Z8_MARBRUT'

				elseif aCampos[_k] == "Margem Líquida"
					aCampos[_k]:= 'Z8_MRGLIQ'

				elseif aCampos[_k] == "EV / EBIT"
					aCampos[_k]:= 'Z8_EVEBIT'

				elseif aCampos[_k] == "Dívida Líquida/Patrimônio Líquido"
					aCampos[_k]:= 'Z8_DLPL'

				elseif aCampos[_k] == "PSR"
					aCampos[_k]:= 'Z8_PSR'

				elseif aCampos[_k] == "Liquidez Corrente"
					aCampos[_k]:= 'Z8_LIQCORR'

				elseif aCampos[_k] == "CAGR Lucro 5 anos"
					aCampos[_k]:= 'Z8_CAGR'

				elseif aCampos[_k] == "PEG Ratio"
					aCampos[_k]:= 'Z8_PEGRATI'

				else 
					aCampos[_k]:= 'Z8_MOVDIA'
				
				EndIf
			NEXT _K
	
				FT_FUSE()


			Begin Transaction
			    //Utilizada para definir o valor máximo da régua de progressão
				ProcRegua(Len(aDados))    
				//Ultilzando a variavel "i" para percorrrer do primeiro ao última linha do Array "aDados"  
				For i:=1 to Len(aDados)                                                                           

				//Começa a importar os dados 
				//Utilizada para incrementar valores na régua de progressão
				IncProc("Importando Registros...")  
			    //Seleciona a tabela de Ações 
                //Define a área de trabalho especificada como ativa. Todas as operações subsequentes serão realizadas nesta área de trabalho
				dbSelectArea("SZ8")                 
					//Seleciona a ordem ativa da área de trabalho.
					//Esta ordem é responsável sequência lógica dos registros da tabela corrente.
				dbSetOrder(1)                                        
					//Move o cursor da área de trabalho ativa para o primeiro registro lógico do arquivo de dados.  Portanto, o arquivo de dados é posicionado no início.
				dbGoTop()

                    //Pesquisa a área de trabalho ativa para encontrar um determinado registro, de acordo com a chave de pesquisa utilizada.
					If !dbSeek(xFilial("SZ8")+aDados[i,1]+aDados[i,2])                                                   
						Reclock("SZ8",.T.) 
							SZ8->Z8_FILIAL := xFilial("SZ8")

					For j:=1 to Len(aCampos)
                    //Pega o Array de cabeçario e para cada coluna ira inserir uma informação 
						cCampo  := "SZ8->" + aCampos[j]  
                    //Se for referente a "Z8_ACAO,Z8_SEGMEN,Z8_SETORES,Z8_ESTUDO" irar gravar os dados Caracteres
					IF aCampos[j] $ "Z8_ACAO,Z8_SEGMEN,Z8_SETORES,Z8_ESTUDO"   
						&cCampo := ((aDados[i,j]))  
					ELSE
					//Ele converte um número incluído em uma expressão numérica em um valor numérico.
						&cCampo := Val(StrTran(AllTrim(StrTran(aDados[i,j],"R$-","")),",","."))  
					Endif
					Next j
					//Distrava o Arquivo
						SZ8->(MsUnlock())    
					EndIf
					Next i
						Conout("Processamento concluido")                         
			End Transaction
		
		if !isblind()
		RESET ENVIRONMENT 
		Endif

    Return
