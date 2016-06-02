<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title>Key Business</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="css/default.css">
  </head>
  <body>
  		<!-- Menu -->
  		<div class="MenuContainer">
  			<ul>  				
  				<li class="MenuFirst">
	  				<div class="MenuBR">
	  				<div class="MenuTR">
	  					&nbsp;
	  				</div>
	  				</div>
  				</li>
  				  				
  				<li class="MenuItem">
  					<div class="MenuBL">
	  				<div class="MenuBR">
	  				<div class="MenuTL">
	  				<div class="MenuTR">
	  					<a href="?p=uvod">Úvod</a>
	  				</div>
	  				</div>
	  				</div>
	  				</div>
  				</li>
  				
  				<li class="MenuItem">
  					<div class="MenuBL">
	  				<div class="MenuBR">
	  				<div class="MenuTL">
	  				<div class="MenuTR">
	  					<a href="?p=novinky">Novinky</a>
	  				</div>
	  				</div>
	  				</div>
	  				</div>		
  				</li>
  				
  				<li class="MenuItem">
  					<div class="MenuBL">
	  				<div class="MenuBR">
	  				<div class="MenuTL">
	  				<div class="MenuTR">
	  					<a href="?p=sluzby">Služby</a>
	  				</div>
	  				</div>
	  				</div>
	  				</div>		
  				</li>
  				
  				<li class="MenuItem">
  					<div class="MenuBL">
	  				<div class="MenuBR">
	  				<div class="MenuTL">
	  				<div class="MenuTR">
	  					<a href="?p=cennik">Cenník</a>
	  				</div>
	  				</div>
	  				</div>
	  				</div>		
  				</li>
  				
  				<li class="MenuItem">
  					<div class="MenuBL">
	  				<div class="MenuBR">
	  				<div class="MenuTL">
	  				<div class="MenuTR">
	  					<a href="?p=kontakt">Kontakt</a>
	  				</div>
	  				</div>
	  				</div>
	  				</div>		
  				</li>
  				
  				<li class="MenuLast">
	  				<div class="MenuBL">
	  				<div class="MenuTL">
	  					&nbsp;
	  				</div>
	  				</div>
  				</li>
  			</ul>
  		</div>
  		
  		<!-- Content -->
	  	<div class="Middle">
	  		<div class="Logo">
	  		</div>
	  		<div class="ContentContainer">
	  			<img src="img/ctl.gif" class="ContentTL"/>
	  			<img src="img/ctr.gif" class="ContentTR"/>
	  			<div class="ContentTable">
		  			<table>
		  				<tr>
		  					<td class="ContentLeft">
		  						<h1>Ľavý stlpec</h1>
				  				<p>weg weeigpo qepugh qpeuh qepgu hqepog qegu hqe[o hqe
				  				qegqei q[eoig hqeg jqe]p jqe]p qe
				  				qepgij qe[i qeg
				  				qeo gjqepg jqe[gji qe[ip jgqe ]qepigj qe]pji qeg[i gqe[oihqeo[ighqe oig</p>
		  					</td>
		  					
		  					<td class="ContentRight">
		  						<%
			  						Dim includePage
			  						
			  						Select Case Request.QueryString("p")
			  							Case "novinky"
			  								includePage = "novinky.html"
			  							Case "sluzby"
			  								includePage = "sluzby.html"
			  							Case "cennik"
			  								includePage = "cennik.html"
			  							Case "kontakt"
			  								includePage = "kontakt.html"
			  							Case Else
			  								includePage = "uvod.html"
			  						End Select
			  						
			  						Response.WriteFile(includePage)
		  						%>
		  					</td>
		  				</tr>
		  			</table>
	  			</div>
  				<img src="img/cbr.gif" class="ContentBR"/>
  				<img src="img/cbl.gif" class="ContentBL"/>
	  		</div>
	  	</div>
  		
  		<!-- Footer -->
  		<div class="FooterContainer">
  				<div class="Footer">
  						Copyright © 2008 KEY Business.sk. All rights reserved.
  				</div>
  		</div>
  </body>
</html>