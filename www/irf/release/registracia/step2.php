<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=windows-1250">
    <link rel=stylesheet href="../style.css" type="text/css" title="style.css">	
	<title>intelignetn� rie�enie pre firmy - registr�cia nov�ho �lena</title>
</head>

<body>
  <center>
    <img src="../images/logo-big.gif" width="373" height="185" alt="" border="0">
  </center>
  <div align="center">
    <?
      echo( "<form action=\"../scripts/adddata.php?name=".$GLOBALS["name"]."\" method=\"post\"> ");
	?>
    <table width=500 cellspacing=0 cellpadding=0 border=0>
      <tr height=20>
	    <td width=10></td>
		<td width=50></td>
		<td width=100></td>
		<td width=280></td>
		<td width=50></td>
		<td width=10></td>		
	  </tr>
	  <tr height=20 bgcolor=#660000>
	    <td colspan=2><img src="images/2of3.gif" width="50" height="20" alt="" border="0"></td>
		<td></td>
		<td></td>
		<td colspan=2></td>		
	  </tr>
	  <tr height=20 bgcolor=#ffcfa5>
	    <td colspan=6></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>n�zov firmy</strong></td>
		<td colspan=2><input name="nazov" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>popis �innosti</strong></td>
		<td colspan=2><input name="popis" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>adresa</strong></td>
		<td colspan=2><input name="adresa" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>telef�nne �. 1</strong></td>
		<td colspan=2><input name="telc1" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>telef�nne �. 2</strong></td>
		<td colspan=2><input name="telc2" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>fax</strong></td>
		<td colspan=2><input name="fax" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td></td>
	    <td colspan=2><strong>mail</strong></td>
		<td colspan=2><input name="mail" type="text" value="" size=49 align="right"></td>
		<td></td>
	  </tr>
	  <tr bgcolor=#ffcfa5>
	    <td colspan=6><center><input type="submit" value="�alej >>"></center></td>
	  </tr>
	  <tr height=20 bgcolor=#ffcfa5>
	    <td colspan=6></td>
	  </tr>
	  <tr height=20 bgcolor=#660000>
	    <td colspan=4></td>
		<td colspan=2><img src="../images/logo-small.gif" width="50" height="20" alt="" border="0" align="right"></td>
	  </tr>
	  <tr height=20>
	    <td></td>
	  </tr>
    </table>
	</form>
  </div>
</body>

</html>