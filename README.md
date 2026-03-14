<h1 align="center" id="title">Plugin Curva de Nivel</h1>

<p id="description">Este plugin cria curvas de nível a partir de dados de elevação do INPE (TOPODATA) ou do Copernicus GLO-30, com cobertura global.</p>

<h2>🧐 Funcionalidades: </h2>

*   Cria curvas de nível a partir de uma área selecionada pelo usuário.
*   **Seleção da fonte de DEM**: INPE TOPODATA (cobre apenas o Brasil) ou **Copernicus GLO-30** (cobertura mundial a ~30 m, sem necessidade de conta ou API key).
*   Permite definir o intervalo entre as curvas de nível.
*   Possui quatro níveis de suavização para criar curvas de nível mais limpas (Nenhum / Baixo / Médio / Alto).
*   **Overlay de elevação (Hillshade)**: gera uma camada raster com relevo sombreado, inserida abaixo das curvas de nível.
*   Cria uma camada vetorial de linhas com simbologia, rótulos e máscara seguindo o padrão das cartas topográficas.
*   Permite utilizar Proxy com autenticação em redes privadas.

<h2>🛠️ Como usar:</h2>

<p>1. Selecione a área de interesse utilizando a ferramenta de seleção.</p>

<p>2. Escolha a fonte de dados de elevação: <b>INPE TOPODATA (Brasil)</b> para áreas no território brasileiro, ou <b>Copernicus GLO-30 (Mundial)</b> para qualquer lugar do mundo.</p>

<p>3. Defina o intervalo entre as curvas. O intervalo padrão é de 10 metros.</p>

<p>4. Escolha o nível de suavização. O padrão é nível médio.</p>

<p>5. Marque a opção <b>Gerar Overlay de Elevação (Hillshade)</b> se desejar adicionar uma camada de relevo sombreado ao projeto.</p>

<p>6. Escolha um perfil de autenticação de Proxy caso necessário. Para criar um novo perfil:<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.1   Clique no botão +.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.2   Escolha o tipo <i>Basic Authentication</i><br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.3   Escolha um nome para o perfil.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.4   Entre com o nome do usuário.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.5   Entre com a senha.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.6   Entre com o domínio e porta. Ex.: http://proxy.dpf.gov.br:8080<br>
  &nbsp;&nbsp;&nbsp;&nbsp;6.7   Clique em Salvar e escolha o perfil criado na lista de perfis.</p>
  
<p>7. Clique em Executar. O plugin criará as camadas de resultado no projeto.</p>

<h2>🍰 Sobre o Desenvolvedor:</h2>
Daniel Hulshof Saint Martin é Agente de Polícia Federal, atualmente lotado no Grupo de Bombas e Explosivos - GBE, em Brasília/DF. 
Atua também como professor da Academia Nacional de Polícia, na cadeira de de Orientação e Navegação do Serviço de Ensino Operacional.
  
<h2>💻 Recursos e tecnologias utilizados nesse plugin:</h2>

*   Portal TOPODATA do INPE - http://www.dsr.inpe.br/topodata/
*   Copernicus GLO-30 DEM (AWS Open Data) - https://registry.opendata.aws/copernicus-dem/
*   Smooth-Contours - https://github.com/MathiasGroebe/Smooth-Contours
*   Biblioteca GDAL - https://gdal.org/en/latest/
*   PyQGIS
*   QGIS

<h2>🛡️ Licença:</h2>

Este projeto é distribuído sob a licença GPL-3.0
