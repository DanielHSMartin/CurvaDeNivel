<h1 align="center" id="title">Plugin Curva de Nivel</h1>

> **🌍 Versão mundial disponível!**
> Este plugin é restrito ao território brasileiro. Se você precisa gerar curvas de nível em qualquer lugar do mundo, confira o plugin [**Contour Lines**](https://github.com/DanielHSMartin/ContourLines), que utiliza o modelo digital de elevação global **Copernicus GLO-30** (ESA) com cobertura mundial e resolução de ~30 m. Nenhuma conta ou chave de API é necessária.

<p id="description">Este plugin cria curvas de nível a partir de dados geomorfométricos do território brasileiro obtidos no portal TOPODATA do INPE.</p>

<h2>🧐 Funcionalidades: </h2>

*   Cria curvas de nível em todo território brasileiro a partir de uma área selecionada pelo usuário.
*   Permite definir o intervalo entre as curvas de nível.
*   Possui três opções de suavização para criar curvas de nível mais limpas.
*   Cria uma camada vetorial de linhas com simbologia, rótulos e máscara seguindo o padrão das cartas topográficas.
*   Permite utilizar Proxy com autenticação em redes privadas.

<h2>🛠️ Como usar:</h2>

<p>1. Selecione a área de interesse utilizando a ferramenta de seleção.</p>

<p>2. Defina o intervalo entre as curvas. O intervalo padrão é de 10 metros.</p>

<p>3. Escolha o nível de suavização. O padrão é nível médio.</p>

<p>4. Escolha um perfil de autenticação de Proxy caso necessário. Para criar um novo perfil:<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.1   Clique no botão +.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.2   Escolha o tipo <i>Basic Authentication</i><br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.3   Escolha um nome para o perfil.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.4   Entre com o nome do usuário.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.5   Entre com a senha.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.6   Entre com o domínio e porta. Ex.: http://proxy.dpf.gov.br:8080<br>
  &nbsp;&nbsp;&nbsp;&nbsp;4.7   Clique em Salvar e escolha o perfil criado na lista de perfis.</p>
  
<p>5. Clique em Executar. O plugin criará uma camada vetorial temporária com o resultado.</p>

<h2>🍰 Sobre o Desenvolvedor:</h2>
Daniel Hulshof Saint Martin é Agente de Polícia Federal, atualmente lotado no Grupo de Bombas e Explosivos - GBE, em Brasília/DF. 
Atua também como professor da Academia Nacional de Polícia, na cadeira de de Orientação e Navegação do Serviço de Ensino Operacional.
  
<h2>💻 Recursos e tecnologias utilizados nesse plugin:</h2>

*   Portal TOPODATA do INPE - http://www.dsr.inpe.br/topodata/
*   Smooth-Contours - https://github.com/MathiasGroebe/Smooth-Contours
*   Biblioteca GDAL - https://gdal.org/en/latest/
*   PyQGIS
*   QGIS

<h2>🛡️ Licença:</h2>

Este projeto é distribuído sob a licença GPL-3.0
