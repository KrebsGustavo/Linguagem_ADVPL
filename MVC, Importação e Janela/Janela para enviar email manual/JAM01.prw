#include "totvs.ch"
#INCLUDE "protheus.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "topconn.ch"
#include "tbiconn.ch"

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function JAM01()        *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que cria uma janela      *******************************|
    |******************************* onde o usuario preeenche com o   *******************************|
	|******************************* e-mail do destinatario.          *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/
   User function JAM01()
   
     //Mostra uma dialog Modal
     Local oDlg         := FwDialogModal():New()          
	 // Space() Fornece uma cadeia de caracteres formada por um número especificado de espaços em branco.                                                                           
     Private cGet01     := Space(200) 
     Private cGet02     := Space(200)
        
     
         oDlg:SetTitle('Dados E-mail')
         oDlg:SetSize(150,250) // Define o tamanho da célula, em pixel ou número de caracteres
         oDlg:CreateDialog()  /*Método responsável por criar a janela e montar os paineis.
         Esse método não ativa a classe, ele apenas cria os componentes.
         Para ativar a classe é necessário usar o método activate.*/

         oPnl := oDlg:GetPanelMain()/*Método responsável por retornar o painel principal da janela.
		 Esse painel é o painel onde devem ser colocados os componentes que
		 se deseja mostra na janela.*/

         //Método construtor da classe.
         oFolder := TFolder():New( 015,005,{"&Destinatário", "&Rementente"}, {}, oPnl,,,, .T., .F., 238, 095)

         @ 005,005 GROUP oGroup1 TO 070, 233 PROMPT "Informe o Destinatário" OF oFolder:aDialogs[1] PIXEL 
         @ 020,020 SAY "cTo: "    SIZE 150,007 OF oFolder:aDialogs[1] PIXEL  
         @ 017,040 MSGET oGet01 VAR cGet01 SIZE 150,010 OF oFolder:aDialogs[1]PIXEL


         //Esta mensagem será apresentada quando o ponteiro do mouse estiver posicionado sobre o shape.
         oGet01:cTooltip := "Digite o email do destinatário"
         @ 005,005 GROUP oGroup1 TO 070, 233 PROMPT "Informe o Remetente" OF oFolder:aDialogs[2] PIXEL 
         //Distancia do topo| Distancia da lateral esquerda|SAY um label| ZIZE define o tamanho |Pixel de altura e de largura |Onde o objeto será criado
         @ 020,020 SAY "cCC: "    SIZE 150,007 OF oFolder:aDialogs[2] PIXEL  
         //MSGET um campo para receber dados
         @ 017,040 MSGET oGet02 VAR cGet02 SIZE 150,010 OF oFolder:aDialogs[2]PIXEL

         oGet02:cTooltip := "Digite o email do Remetente"

		

         //botão para enviar o e-mail (Chama a função EVAMP5())
         oDlg:AddButton('Enviar',{||EVAMP5(),;
		 MSGINFO("Email enviado com sucesso"),oDlg:OOWNER:END()})
		 //Botão para fechar a janela 
         oDlg:addCloseButton({||oDlg:OOWNER:END()} ) 

   oDlg:Activate()
   Return
      
    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function EVAMP3()       *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que envia o email,       *******************************|
    |*******************************                                  *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

         STATIC function EVAMP5()
					 Local cCabec := ""
					 Local cBody  := ""
					 Local cFinal := ""


					cCabec += ' <style>                       '
					cCabec += '	.demo {                       '
					cCabec += '		border:1px sólido #87CEFA;'
					cCabec += '		border-collapse:colapso;  '
					cCabec += '		padding:5px;              '
					cCabec += '	}                             '
					cCabec += '	.demo th {                    '
					cCabec += '		border:1px sólido #87CEFA;'
					cCabec += '		padding:5px;              '
					cCabec += '		background:#87CEFA;       '
					cCabec += '	}                             '
					cCabec += '	.demo td {                    '
					cCabec += '		border:1px sólido #87CEFA;'
					cCabec += '		padding:5px;              '
					cCabec += '	}                             '
					cCabec += '</style>                       '

					cCabec += ' <table class="demo">                                        '
					cCabec += '	<caption> Todas as ações registradas no Sistema </caption>  '
					cCabec += '	<thead>                                                     '
					cCabec += '	<tr>                                                        '
					cCabec += '		<th>Nome da ação  </th>                                 '
					cCabec += '		<th>Segmento de Listagem         </th>                  '
					cCabec += '		<th>Setor  </th>                                        '
					cCabec += '		<th>Aprovado para Estudo? </th>                         '
					cCabec += '		<th>Preço </th>                                         '
					cCabec += '		<th>Margem de segurança   </th>                         '
					cCabec += '		<th>Margem Bruta </th>                                  '
					cCabec += '		<th>Margem Líquida  </th>                               '
					cCabec += '		<th>Movimentação Diária </th>                           '
					cCabec += '	</tr>                                                       '
					cCabec += '	</thead>                                                    '
					cCabec += '	<tbody>                                                     '

	       BeginSQL Alias 'SZ8TEMP'
		       SELECT
					Z8_ACAO,
					Z8_SEGMEN,
					Z8_SETORES,
					Z8_ESTUDO,
					Z8_PRECO,
					Z8_MARSEG,
					Z8_MARBRUT,
					Z8_MRGLIQ,
					Z8_MOVDIA,
					R_E_C_N_O_ AS Rec                                                                //Altera a forma do sistema Protheus gravar o campo R_E_C_N_O_ das tabelas de dados para a modalidade auto-incremental.
			   FROM
			        %TABLE:SZ8%
	       EndSql
					DbSelectArea('SZ8TEMP')                                                              // Define a área de trabalho especificada como ativa. Todas as operações subsequentes serão realizadas nesta área de trabalho, a menos que outra área seja informada ou que se utilize alias para se referenciar outra área de trabalho.
					lSendMail := SZ8TEMP ->(!Eof())                                                      // ( !Eof() ) Determina se o final do arquivo de dados foi atingido

						If lSendMail

						 While SZ8TEMP->(!Eof())
								
							cBody += '<tr>'
							cBody += '	<td>' + SZ8TEMP->Z8_ACAO  + '</td>'
							cBody += '	<td>' + SZ8TEMP->Z8_SEGMEN + '</td>'
							cBody += '	<td>' + SZ8TEMP->Z8_SETORES + '</td>'
							cBody += '	<td>' + SZ8TEMP->Z8_ESTUDO + '</td>'
							cBody += '	<td>' + cValtoChar(SZ8TEMP->Z8_PRECO) + '</td>'
							cBody += '	<td>' + cValtoChar(SZ8TEMP->Z8_MARSEG) + '</td>'
							cBody += '	<td>' + cValtoChar(SZ8TEMP->Z8_MARBRUT) + '</td>'
							cBody += '	<td>' + cValtoChar(SZ8TEMP->Z8_MRGLIQ) + '</td>'
							cBody += '	<td>' + cValtoChar(SZ8TEMP->Z8_MOVDIA) + '</td>'
							cBody += '</tr>'
							SZ8TEMP->(dbSkip())
		                 EndDo

							cFinal += '	</tbody>'
							cFinal += '</table> '
							_pcBody:=cCabec+cBody+cFinal
						    /*
							Autor       : Carlos Ryve Gandini
							Data/Time   : 15/02/17 às 16:02:06
							Detalhe     : Inicio do Envio do E-mail
						    */
							oMail := CRGSendMail():New()
							oMail:cTo      := cGet01 
							oMail:cCC      := cGet02 
							oMail:cSubject :=  "Workflow"
							oMail:cBody    := _pcBody 
							lSendOk := oMail:SendMail()

						    If lSendOk 
							    //DBGOTO Move o cursor da área de trabalho ativa para o primeiro registro lógico do arquivo de dados. Portanto, o arquivo de dados é posicionado no início.
						    	SZ8TEMP->(DBGOTOP())    
								//( !Eof() ) Determina se o final do arquivo de dados foi atingido.
							while SZ8TEMP->( !Eof() )               
								SZ8->(DBGOTO(SZ8TEMP->Rec))
								//RECLOCK Permite a inslusão ou alteração de um registro no alias informado.
								RECLOCK("SZ8",.F.) 
								//(MsUnlock())Libera o travamento / bloqueio (lock) do registro posicionado no alias corrente, obtido através da função RecLock().
								SZ8->(MsUnlock())   
								//( dbSkip() ) Desloca para outro registro na tabela corrente.                                               
								SZ8TEMP->( dbSkip() )                 
							EndDO 
							  ConOut("Tecnicamente Enviado ")
						    EndIf
	                    Else 
	                       ConOut("Sem dados para enviar...")
	                    Endif
							DbSelectArea('SZ8TEMP')
							DBCloseArea() 
   RETURN

  