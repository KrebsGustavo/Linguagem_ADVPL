#INCLUDE "protheus.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "topconn.ch"
#include "tbiconn.ch"


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function EVAMP3()       *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que envia o email,       *******************************|
    |******************************* via schedule.                    *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/
        

     User Function EVAMP3()
	     Local cCabec:=""
	     Local cBody:= ""
	     Local cFinal:= ""
 //Realiza a inicialização do ambiente determinado  
 PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SZ8' // MODULO 'ESP' /*******COMANDOS *********/

  
            //Monta a estrutura em HTML5 o modelo para visualização do E-mail 
			cCabec += '<style>                        '
			cCabec += '	.demo {                       '
			cCabec += '		border:1px sólido #D3D3D3;'
			cCabec += '		border-collapse:colapso;  '
			cCabec += '		padding:5px;              '
			cCabec += '	}                             '
			cCabec += '	.demo th {                    '
			cCabec += '		border:1px sólido #D3D3D3;'
			cCabec += '		padding:5px;              '
			cCabec += '		background:#D3D3D3;       '
			cCabec += '	}                             '
			cCabec += '	.demo td {                    '
			cCabec += '		border:1px sólido #D3D3D3;'
			cCabec += '		padding:5px;              '
			cCabec += '	}                             '
			cCabec += '</style>                       '

			cCabec += '<table class="demo">                               '
			cCabec += '	<caption> TOP 10 AÇÕES COM MAIORES MOVIMENTAÇÕES </caption>                       '
			cCabec += '	<thead>                                           '
			cCabec += '	<tr>                                              '
			cCabec += '		<th>Nome da ação  </th>                       '
			cCabec += '		<th>Segmento de Listagem         </th>        '
			cCabec += '		<th>Setor  </th>                              '
			cCabec += '		<th>Aprovado para Estudo? </th>               '
			cCabec += '		<th>Preço </th>                               '
			cCabec += '		<th>Margem de segurança   </th>               '
			cCabec += '		<th>Margem Bruta </th>                        '
			cCabec += '		<th>Margem Líquida  </th>                     '
			cCabec += '		<th>Movimentação Diária </th>                 '
			cCabec += '	</tr>                                             '
			cCabec += '	</thead>                                          '
			cCabec += '	<tbody>                                           '
           
		    //Cria tabela temporaria com as informações que ainda não foram enviado por e-mail. 
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
			     R_E_C_N_O_ AS Rec 

		        FROM
			     %TABLE:SZ8%
			// WHERE Z8_WFSEND <>'S' ou seja informações que ainda não foram enviadas por email 
		        WHERE 
				Z8_WFSEND <>'S'
                
		         ORDER BY Z8_MOVDIA DESC
			     OFFSET 0 ROWS  
                 FETCH NEXT 10 ROWS ONLY 
	
	        EndSql
			
				 DbSelectArea('SZ8TEMP')
				 lSendMail := SZ8TEMP ->(!Eof())

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

					
					//Detalhe     : Inicio do Envio do E-mail 
					
				    oMail := CRGSendMail():New()
					oMail:cTo      := "testepararotina@outlook.com"
					oMail:cCC      := "walter_gustavokrebs@hotmail.com"
					oMail:cSubject := "Workflow"
					oMail:cBody    := _pcBody //Informe aqui o corpo no e-mail.
					lSendOk := oMail:SendMail()


				If lSendOk 

					SZ8TEMP->(DBGOTOP())
				while SZ8TEMP->( !Eof() )
					     SZ8->(DBGOTO(SZ8TEMP->Rec))
						     RECLOCK("SZ8",.F.)
							     SZ8->Z8_WFSEND:='N'
								     SZ8->(MsUnlock())
								       SZ8TEMP->( dbSkip() )
				EndDO 

				 ConOut("Tecnicamente Enviado ")

				EndIf
                              
	Else 
	  ConOut("Sem dados para enviar...")
	Endif

      RESET ENVIRONMENT 
Return

