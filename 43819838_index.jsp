<html>

<head>
<style>

[type = "submit"] {
    background-color: #800080; 
    border: none;
    color: white;
    padding: 10px;
	border-radius: 12px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    cursor: pointer;
}
[type=text] , [type=number]{
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
}

body{
	background-image: url("https://www.xmple.com/wallpaper/gradient-white-blue-linear-2736x1824-c2-ffffff-87cefa-a-285-f-14.svg");
	background-repeat: no-repeat;
	background-position: center;
	background-size: 100% 120%;
	font-family: Comic Sans MS;
}

[placeholder]{
	font-weight: bold;
	font-family: Comic Sans MS;
	font-size: 15px;
}

#blue{
	color: blue;
	font-weight: bold;
	font-size: 17px;
}

#list {
    font-weight: bold;
	font-size: 18px;
}
#msg{
	color: red;
	font-size: 25px;
}
#show{
	border-collapse: collapse;
    width: 50%;
}
#z{
	text-align: left;
    padding: 8px;
}
th{
	background-color: #FFA500;
    color: white;
}

tr#z:nth-child(even){
	background-color: #f2f2f2;
}

</style>
</head>

<body>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="static java.lang.System.out" %>


<%
	Connection conn = null;

	try	{
            String userName = "gallery";
            String password = "eecs118";
            String url = "jdbc:mysql://127.0.0.1:3306/gallery";
			Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection (url, userName, password);
            System.out.println ("Database connection established.\n");
    }
    catch (Exception e)   {
            System.err.println ("Cannot connect to database server!");
    }
	Statement stmt = conn.createStatement();

%>

<table>
	<tr id="list"> <td> 1-List galleries </td> </tr>
	<tr><td>
	<form method="post">
		<input name="funcID" type="hidden" value="1">
		<input type="submit" value="Go!" >
	</form>
	<%
		String fId = request.getParameter("funcID");
		if(fId != null && fId.equals("1")){
			String sql = "SELECT * FROM gallery";
			ResultSet rs=stmt.executeQuery(sql);
			String table = "";
			table += ("<table id=\"show\">");
			table += ("<tr id=\"z\">");
			table += ("<th id=\"z\">Id</th>");
			table += ("<th id=\"z\">Name</th>");
			table += ("<th id=\"z\">Description</th>");
			table += ("</tr>");
			while (rs.next()) {
				table += ("<tr id=\"z\">");
				table += ("<td id=\"z\">"+rs.getString("gallery_id")+"</td>");
				table += ("<td id=\"z\">"+rs.getString("name")+"</td>");
				table += ("<td id=\"z\">"+rs.getString("description")+"</td>");
				table += ("</tr>");
			}
			table += ("</table>");
			out.println(table);
		}
	%>
	</td></tr>
	<tr id="list"><td> 2-List images </td></tr>
	<tr><td>
	<form method="post">
		<input name="funcID" type="hidden" value="2">
		<input name="ga2" type="number"  placeholder="Gallery Id">
		<input type="submit" value="Go!" >
	</form>
	<%
		if(fId != null && fId.equals("2")){
			String ga_id = request.getParameter("ga2");
			if(ga_id == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter gallery Id.</td></tr></table>");
			}
			else if(ga_id.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Gallery id length is too long.</td></tr></table>");
			}
			else{
			int id = Integer.parseInt(ga_id);
			String sql = "SELECT * FROM image WHERE gallery_id = " + ga_id;
			ResultSet rs=stmt.executeQuery(sql);
			int count = 0;
			String table = "";
			table += "<table id=\"show\">";
			table += ("<tr id=\"z\">");
			table += ("<th id=\"z\">Id</th>");
			table += ("<th id=\"z\">Title</th>");
			table += ("<th id=\"z\">Image</th>");
			table += ("</tr>");
			while (rs.next()) {
				count ++;
				table += ("<tr id=\"z\">");
				table += "<td id=\"z\">"+rs.getString("image_id")+"</td>";
				table += "<td id=\"z\">"+rs.getString("title")+"</td>";
				table += "<td id=\"z\"><img src=\"" +rs.getString("link")+ "\" width=\"30%\" height=\"auto\"></td>";
				table += ("</tr>");
			}
			if(count == 0){
				out.println("<tr id=\"msg\"><td>Gallery not found or empty gallery.</td></td>");
			}
			else{
				out.println("<table><tr id=\"msg\"><td>Gallery has "+count+" images.</td></tr></table>");
				table += "</table>";
				out.println(table);

			}
			}
		}
	%>
	</td></tr>
	<tr id="list"> <td>3-List image details </td></tr>
	<tr><td>
	<form method="post">
		<input name="funcID" type="hidden" value="3">
		<input name="id3" type="number" placeholder="Image Id">
		<input type="submit" value="Go!" >
	</form>
	<%
		if(fId != null && fId.equals("3")){
			String temp = request.getParameter("id3");
			if(temp == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter image Id.</td></tr></table>");
			}
			else if(temp.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Image id length is too long.</td></tr></table>");
			}
			else{
			int id3 = Integer.parseInt(temp);
			String sql = "SELECT * FROM image WHERE image_id ="+id3;
			ResultSet rs = stmt.executeQuery(sql);
			if(!rs.next()){
				out.println("<table><tr id=\"msg\"><td>Image not found.</td></td></table>");
			}
			else{
				String link = rs.getString("link");
				String title = rs.getString("title");
				int ar_id = rs.getInt("artist_id");
				sql = "SELECT * FROM detail WHERE image_id = "+id3;
				rs = stmt.executeQuery(sql);
				rs.next();
				out.println("<table id=\"show\">");
				out.println("<tr id=\"z\">");
				out.println("<th id=\"z\">Title</th>");
				out.println("<th id=\"z\">Image</th>");
				out.println("<th id=\"z\">Artist</th>");
				out.println("<th id=\"z\">Width</th>");
				out.println("<th id=\"z\">Height</th>");
				out.println("<th id=\"z\">Location</th>");
				out.println("<th id=\"z\">Year</th>");
				out.println("<th id=\"z\">Description</th>");
				out.println("<th id=\"z\">Type</th>");
				out.println("</tr>");
				
				int w = rs.getInt("width");
				int h = rs.getInt("height");
				String lo = rs.getString("location");
				int y  =rs.getInt("year");
				String des3 = rs.getString("description");
				String type3 = rs.getString("type");
				
				sql = "SELECT name FROM artist WHERE artist_id="+ar_id;
				ResultSet r2 = stmt.executeQuery(sql);
				r2.next();
				String name3 = r2.getString(1);
				out.println("<tr id=\"z\">");
				out.println("<td id=\"z\">"+title+"</td>");
				out.println("<td id=\"z\"><img src=\"" +link+ "\" width=\"100%\" height=\"auto\" ></td>");
				out.println("<td id=\"z\">"+ name3+"</td>");
				out.println("<td id=\"z\">"+w+"</td>");
				out.println("<td id=\"z\">"+h+"</td>");
				out.println("<td id=\"z\"> "+lo+"</td>");
				out.println("<td id=\"z\">"+y+"</td>");
				out.println("<td id=\"z\">"+des3+"</td>");
				out.println("<td id=\"z\">"+type3+"</td>");
				out.println("</tr>");
				out.println("</table>");
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 4-List artist details </td></tr>
	<tr><td>
	<form method="post">
		<input name="funcID" type="hidden" value="4">
		<input name="id4" type="number" placeholder="Artist Id">
		<input type="submit" value="Go!" >
	</form>
	<%
		if(fId != null && fId.equals("4")){
			String temp = request.getParameter("id4");
			if(temp == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter artist Id.</td></tr></table>");
			}
			else if(temp.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Artist id length is too long.</td></tr></table>");
			}
			else{
			int id4 = Integer.parseInt(temp);
			String sql = "SELECT * FROM artist WHERE artist_id ="+id4;
			ResultSet rs = stmt.executeQuery(sql);
			if(!rs.next()){
				out.println("<table><tr id=\"msg\"><td>Artist not found.</td></tr></table>");
			}
			else{
				String name = rs.getString("name");
				String by = rs.getString("birth_year");
				String country = rs.getString("country");
				String des = rs.getString("description");
				out.println("<table id=\"show\">");
				out.println("<tr id=\"z\">");
				out.println("<th id=\"z\">Id</th>");
				out.println("<th id=\"z\">Name</th>");
				out.println("<th id=\"z\">Birth year</th>");
				out.println("<th id=\"z\">Country</th>");
				out.println("<th id=\"z\">Description</th>");
				out.println("</tr id=\"z\">");

				out.println("<tr id=\"z\">");
				out.println("<td id=\"z\">"+id4+"</td>");
				out.println("<td id=\"z\">"+name+"</td>");
				out.println("<td id=\"z\">"+by+"</td>");
				out.println("<td id=\"z\">"+country+"</td>");	
				out.println("<td id=\"z\">"+des+"</td>");
				out.println("</tr>");
				out.println("</table");
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 5-Create new gallery </td></tr>
	<tr> <td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="5">
				<input name="name1" type="text" placeholder="name">
				<input name="des1" type="text" placeholder="Description">
				<input type="submit" value="Add"/>
			</form>
			<%
				if(fId != null && fId.equals("5")){
					String name = request.getParameter("name1");
					String des = request.getParameter("des1");
					if(name != null && des != null && name != "" && des != "" ){
						if(name.length() > 45 || des.length() > 2000){
							out.println("<table><tr id=\"msg\"><td>Maximum length of name is 45, and maximum length of description is 2000.</td></tr></table>");
						}
						else{
						String sql = "INSERT INTO gallery(gallery_id, name, description)VALUES(default,?,?)";
						PreparedStatement statement = conn.prepareStatement(sql);
						statement.setString(1,name);
						statement.setString(2, des);
						statement.execute();
						out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
						}
					}
					else{
						out.println("<table><tr id=\"msg\"><td>Please fill all inputs.</td></tr></table>");
					}
				}
			%>
	</td></tr>
	<tr id="list"><td> 6-Create new artist </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="6">
				<input name="name2" type="text" placeholder="Name">
				<input name="birth2" type="number" placeholder="Birth year">
				<input name="country2" type="text" placeholder="Country">
				<input name="des2" type="text" placeholder="Description">
				<input type="submit" value="Add"/>
			</form>
			<%
				if(fId != null && fId.equals("6")){
					String name2 = request.getParameter("name2");
					String des2 = request.getParameter("des2");
					String Country2 = request.getParameter("country2");
					String bd2 = request.getParameter("birth2");
					if(name2 != null && des2 != null && name2 != "" && des2 != "" && Country2 != null && Country2 != "" && bd2 != null && bd2 != "" ){
						if(name2.length() > 45 || des2.length() > 2000 || Country2.length() >45 || bd2.length() > 4){
							out.println("<table><tr id=\"msg\"><td>Maximum length of name and country is 45, and maximum length of description is 2000.</td></tr></table>");
							out.println("<table><tr id=\"msg\"><td>Maximum length of year is 4.</td></tr></table>");
						}
						else{
						String sql = "INSERT INTO artist(artist_id, name, birth_year,country,description)VALUES(default,?,?,?,?)";
						PreparedStatement statement = conn.prepareStatement(sql);
						statement.setString(1,name2);
						statement.setInt(2,Integer.parseInt(bd2));
						statement.setString(3, Country2);
						statement.setString(4, des2);
						statement.execute();
						out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
						}
					}
					else{
						out.println("<table><tr id=\"msg\"><td>Please fill all inputs.</td></tr></table>");
					}
				}
			%>
	</td></tr>
	<tr id="list"><td> 7-Add a new image </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="7">
				<input name="title7" type="text" placeholder="Title">
				<input name="link7" type="text" placeholder="Link">
				<input name="ar7" type="number" placeholder="Artist id">
				<input name="ga7" type="number" placeholder="Gallery id">
				<input name="des7" type="text" placeholder="Description">
				<input name="loc7" type="text" placeholder="Location">
				<input name="width7" type="number" placeholder="Width">
				<input name="height7" type="number" placeholder="Height">
				<input name="year7" type="number" placeholder="Year">
				<input name="type7" type="text" placeholder="Type">
				<input type="submit" value="Add"/>
			</form>
	<% 
		if(fId != null && fId.equals("7")){
			String artist_id = request.getParameter("ar7");
			String gallery_id = request.getParameter("ga7");
			if(artist_id == "" || gallery_id == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter artist id and gallery id.</td></tr></table>");
			}
			else if(gallery_id.length() > 11 || artist_id.length() >11 ){
					out.println("<table><tr id=\"msg\"><td>Gallery id or artist id length is too long.</td></tr></table>");
			}
			else{
			String sql = "SELECT artist_id FROM artist WHERE artist_id=\"";
			sql += Integer.parseInt(artist_id);
			sql +=" \" "; 
			ResultSet rs=stmt.executeQuery(sql);
			if(	!rs.next()){
				out.println("<table><tr id=\"msg\"><td>Artist id not found!</td></tr></table>");
			}
			else{
				sql = "SELECT gallery_id FROM gallery WHERE gallery_id=\"";
				sql += Integer.parseInt(gallery_id);
				sql +=" \" "; 
				rs=stmt.executeQuery(sql);
				if(	!rs.next()){
					out.println("<table><tr id=\"msg\"><td>Gallery id not found!</td></tr></table>");
				}
				else{
					String title7 = request.getParameter("title7");
					String link7 = request.getParameter("link7");
					String des7 = request.getParameter("des7");
					String loc7 = request.getParameter("loc7");
					String width7 = request.getParameter("width7");
					String height7 = request.getParameter("height7");
					String year7 = request.getParameter("year7");
					String t7 = request.getParameter("type7");
					if(title7 == "" || link7 == "" || des7 == "" || loc7 == "" || width7 == "" || height7 == "" || year7 == "" || t7 == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter all details.</td></tr></table>");
					}
					else if(title7.length() > 45 || link7.length() > 200 || des7.length() > 2000 || loc7.length() > 45 ||  t7.length() > 45){
						out.println("<table><tr id=\"msg\"><td>Length overflow.(Some data is too long)</td></tr></table>");
					}
					else if(width7.length() > 11 || height7.length() > 11 || year7.length() > 4){
						out.println("<table><tr id=\"msg\"><td>Length overflow.(Some data is too long)</td></tr></table>");
					}
					else{
					sql = "SELECT `AUTO_INCREMENT` FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'gallery' AND   TABLE_NAME  = 'image'";
					ResultSet r3 = stmt.executeQuery(sql);
					r3.next();
					int id7 = r3.getInt(1);
					sql = "INSERT INTO image VALUES (default, ?, ?, ?, ?, ?)";
					PreparedStatement statement = conn.prepareStatement(sql);
					statement.setString(1,title7);
					statement.setString(2,link7);
					statement.setInt(3,Integer.parseInt(gallery_id));
					statement.setInt(4,Integer.parseInt(artist_id));
					statement.setInt(5, id7);
					statement.execute();
				
					sql = "INSERT INTO detail VALUES (default, ?, ?, ?, ?, ?, ?, ?)";
					statement = conn.prepareStatement(sql);
					statement.setInt(1,id7);
					statement.setInt(2,Integer.parseInt(year7));
					statement.setString(3,t7);
					statement.setInt(4,Integer.parseInt(width7));
					statement.setInt(5,Integer.parseInt(height7));
					statement.setString(6,loc7);
					statement.setString(7,des7);
					statement.execute();
					out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
					}
				}
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 8-Delete an image </td></tr>
	<tr> <td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="8">
				<input name="id8" type="number" placeholder="Image id">
				<input type="submit" value="Add"/>
			</form>
	<%
		if(fId != null && fId.equals("8")){
			String temp = request.getParameter("id8");
			if(temp == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter image id.</td></tr></table>");
			}
			else if(temp.length() > 11){
				out.println("<table><tr id=\"msg\"><td>Image id length overflow.</td></tr></table>");
			}
			else{
			int id8 = Integer.parseInt(temp);
			String sql = "SELECT * FROM image WHERE image_id ="+id8;
			ResultSet rs = stmt.executeQuery(sql);
			if(!rs.next()){
				out.println("<table><tr id=\"msg\"><td>Image not found</td></tr></table>");
			}
			else{
				sql = "DELETE FROM image WHERE image_id="+id8;
				stmt.execute(sql);
				sql = "DELETE FROM detail WHERE detail_id="+id8;
				stmt.execute(sql);
				out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 9-Modify image details </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="9">
				<input name="i9" type="number" placeholder="Image id"><br>
				<div id="blue">Leave blank whatever you don't want to change.</div>
				<input name="title9" type="text" placeholder="Title">
				<input name="link9" type="text" placeholder="Link">
				<input name="ar9" type="number" placeholder="Artist id">
				<input name="ga9" type="number" placeholder="Gallery id">
				<input name="des9" type="text" placeholder="Description">
				<input name="loc9" type="text" placeholder="Location">
				<input name="width9" type="number" placeholder="Width">
				<input name="height9" type="number" placeholder="Height">
				<input name="year9" type="number" placeholder="Year">
				<input name="type9" type="text" placeholder="Type">
				<input type="submit" value="Add"/>
			</form>
	<% 
		if(fId != null && fId.equals("9")){
					String x;
					int y;
					String temp = request.getParameter("i9");
					if(temp == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter image id.</td></tr></table>");
					}
					else if(temp.length() > 11){
						out.println("<table><tr id=\"msg\"><td>Image id length overflow.</td></tr></table>");
					}
					else{
					int i9 = Integer.parseInt(temp);
					String sql = "SELECT * FROM image WHERE image_id="+i9;
					ResultSet rs = stmt.executeQuery(sql);
					if(rs.next()){
						boolean flag = true;
						if(request.getParameter("ar9")!= ""){
							y = Integer.parseInt(request.getParameter("ar9"));
							sql = "SELECT artist_id FROM artist WHERE artist_id=\"";
						    sql += y;
							sql +=" \" "; 
							Statement stmt2 = conn.createStatement();
							ResultSet r2=stmt2.executeQuery(sql);
							if(	!r2.next()){
								out.println("<table><tr id=\"msg\"><td>Artist id not found!</td></tr></table>");
								flag = false;
							}
							else{
							sql = "UPDATE  image SET artist_id ="+y+" WHERE image_id ="+i9;
							stmt.execute(sql);
							}
						}
						if(request.getParameter("ga9")!= ""){
							y = Integer.parseInt(request.getParameter("ga9"));
							sql = "SELECT gallery_id FROM gallery WHERE gallery_id=\"";
							sql += y;
							sql +=" \" "; 
							Statement stmt2 = conn.createStatement();
							ResultSet r2=stmt2.executeQuery(sql);
							if(	!r2.next()){
								out.println("<table><tr id=\"msg\"><td>Gallery id not found!</td></tr></table>");
								flag = false;
							}
							else{
							sql = "UPDATE  image SET title = "+y+" WHERE image_id ="+i9;
							stmt.execute(sql);
							}
						}
						if(flag){
						if(request.getParameter("title9")!= ""){
							x = request.getParameter("title9");
							if(x.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Title length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  image SET title = \""+x+"\" WHERE image_id ="+i9;
							stmt.execute(sql);
							}
						}
						if(request.getParameter("link9")!= ""){
							x = request.getParameter("link9");
							if(x.length() > 200){
								out.println("<table><tr id=\"msg\"><td>Link length is too long.</td></tr></table>");
								flag = false;
							}
							else{
							sql = "UPDATE  image SET link = \""+x+"\" WHERE image_id ="+i9;
							stmt.execute(sql);
							}
						}
						if(request.getParameter("des9")!= ""){
							x = request.getParameter("des9");
							if(x.length() > 2000){
								out.println("<table><tr id=\"msg\"><td>Description length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  detail SET description = \""+x+"\" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						if(request.getParameter("loc9")!= ""){
							x = request.getParameter("loc9");
							if(x.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Location length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  detail SET location = \""+x+"\" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						if(request.getParameter("width9")!= ""){
							x = request.getParameter("width9");
							if(x.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Width length is too long.</td></tr></table>");
							}
							else{
								y =Integer.parseInt(x);
							sql = "UPDATE  detail SET width = "+y+" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						if(request.getParameter("height9")!= ""){
							x = request.getParameter("height9");
							if(x.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Height length is too long.</td></tr></table>");
							}
							else{
								y =Integer.parseInt(x);
							sql = "UPDATE  detail SET height = "+y+" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						if(request.getParameter("year9")!= ""){
							x = request.getParameter("year9");
							if(x.length() > 11){
								out.println("<table><tr id=\"msg\"><td>Year length is too long.</td></tr></table>");
							}
							else{
								y =Integer.parseInt(x);
							sql = "UPDATE  detail SET year = "+y+" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						if(request.getParameter("type9")!= ""){
							x = request.getParameter("type9");
							if(x.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Type length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  detail SET type = \""+x+"\" WHERE image_id ="+i9;
							stmt.execute(sql);}
						}
						out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");}
					}
					else{
						out.println("<table><tr id=\"msg\"><td>Image not found!</td></tr></table>");
					}
					}
				}
	%>
	</td></tr>
	<tr id="list"><td> 10-Modify artist details </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="10">
				<input name="aId10" type="number" placeholder="Artist id"><br>
				<div id="blue">Leave blank whatever you don't want to change.</div>
				<input name="name10" type="text" placeholder="Name">
				<input name="birth10" type="number" placeholder="Birth year">
				<input name="country10" type="text" placeholder="Country">
				<input name="des10" type="text" placeholder="Description">
				<input type="submit" value="Add"/>
			</form>
			<%
				if(fId != null && fId.equals("10")){
					String name10;
					String des10 ;
					String Country10;
					int bd10 ;
					String temp = request.getParameter("aId10");
					if(temp == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter artist id.</td></tr></table>");
					}
					else if(temp.length() > 11 ){
						out.println("<table><tr id=\"msg\"><td>Artist id length overflow.</td></tr></table>");
					}
					else{
					int ar10 = Integer.parseInt(temp);
					String sql = "SELECT * FROM artist WHERE artist_id="+ar10;
					ResultSet rs = stmt.executeQuery(sql);
					if(rs.next()){
						if(request.getParameter("name10")!= ""){
							name10 = request.getParameter("name10");
							if(name10.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Name length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  artist SET name = \""+name10+"\" WHERE artist_id ="+ar10;
							stmt.execute(sql);}
						}
						if(request.getParameter("des10") != ""){
							des10 = request.getParameter("des10");
							if(des10.length() > 2000){
								out.println("<table><tr id=\"msg\"><td>Description length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  artist SET description = \""+des10+"\" WHERE artist_id ="+ar10;
							stmt.execute(sql);}
						}
						if(request.getParameter("country10") != ""){
							Country10 = request.getParameter("country10");
							if(Country10.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Country length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  artist SET country = \""+Country10+"\" WHERE artist_id ="+ar10;
							stmt.execute(sql);}
						}
						if(request.getParameter("birth10") != ""){
							String x = request.getParameter("birth10");
							if(x.length() > 4){
								out.println("<table><tr id=\"msg\"><td>Birth year length is too long.</td></tr></table>");
							}
							else{
							bd10 = Integer.parseInt(x);
							sql = "UPDATE  artist SET birth_year ="+bd10+" WHERE artist_id ="+ar10;
							stmt.execute(sql);}
						}
						out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
					}
					else{
						out.println("<table><tr id=\"msg\"><td>Artist not found!</td></tr></table>");
					}
					}
				}
			%>
	</td></tr>
	<tr id="list"><td> 11-Modify gallery details </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="11">
				<input name="g11" type="number" placeholder="Gallery id"><br>
				<div id="blue">Leave blank whatever you don't want to change.</div>
				<input name="name11" type="text" placeholder="Name">
				<input name="des11" type="text" placeholder="Description">
				<input type="submit" value="Add"/>
			</form>
	<%
				if(fId != null && fId.equals("11")){
					String name11;
					String des11;
					String temp = request.getParameter("g11");
					if(temp == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter gallery id.</td></tr></table>");
					}
					else if(temp.length() > 11){
						out.println("<table><tr id=\"msg\"><td>Gallery id is too long.</td></tr></table>");
					}
					else{
					int g11 = Integer.parseInt(temp);
					String sql = "SELECT * FROM gallery WHERE gallery_id="+g11;
					ResultSet rs = stmt.executeQuery(sql);
					if(rs.next()){
						if(request.getParameter("name11")!= ""){
							name11 = request.getParameter("name11");
							if(name11.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Name length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  gallery SET name = \""+name11+"\" WHERE gallery_id ="+g11;
							stmt.execute(sql);}
						}
						if(request.getParameter("des11") != ""){
							des11 = request.getParameter("des11");
							if(des11.length() > 2000){
								out.println("<table><tr id=\"msg\"><td>Description length is too long.</td></tr></table>");
							}
							else{
							sql = "UPDATE  gallery SET description = \""+des11+"\" WHERE gallery_id ="+g11;
							stmt.execute(sql);}
						}
						out.println("<table><tr id=\"msg\"><td>Done!</td></tr></table>");
					}
					else{
						out.println("<table><tr id=\"msg\"><td>Gallery not found!</td></tr></table>");
					}
					}
				}
	%>
	</td></tr>
	<tr id="list"><td> 12-Find image by type </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="12">
				<input name="t13" type="text" placeholder="Type">
				<input type="submit" value="Go!"/>
			</form>
	<%
		if(fId != null && fId.equals("12")){
			String t13 = request.getParameter("t13");
			if(t13 == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter type.</td></tr></table>");
			}
			else if(t13.length() > 45){
					out.println("<table><tr id=\"msg\"><td>Type length is too long.</td></tr></table>");
			}
			else{
			String sql = "SELECT * FROM detail WHERE type =\""+t13+"\"";
			ResultSet rs = stmt.executeQuery(sql);
			ResultSet r2;
			int count = 0;
			Statement stmt2 = conn.createStatement();
			String table = "";
			table += ("<table id=\"show\">");
			table += ("<tr id=\"z\">");
			table += ("<th id=\"z\">Title</th>");
			table += ("<th id=\"z\">Image</td>");
			table += ("<th id=\"z\">Year</th>");
			table += ("<th id=\"z\">Type</th>");
			table += ("<th id=\"z\">Width</th>");
			table += ("<th id=\"z\">Height</th>");
			table += ("<th id=\"z\">Description</th>");
			table += ("</tr>");
			while(rs.next()){
				count++;
				sql = "SELECT * FROM image WHERE image_id = ";
				sql += rs.getInt("image_id");
				r2 = stmt2.executeQuery(sql);
				r2.next();
				table += ("<tr id=\"z\">");
				table += ("<td id=\"z\">"+r2.getString("title")+"</td>");
				table += ("<td id=\"z\"><img src=\"" +r2.getString("link")+"\"width=\"50%\" height=\"auto\"></td>");
				table += ("<td id=\"z\">"+rs.getInt("year")+"</td>");
				table += ("<td id=\"z\">"+rs.getString("type")+"</td>");
				table += ("<td id=\"z\">"+rs.getInt("width")+"</td>");
				table += ("<td id=\"z\">"+rs.getInt("height")+"</td>");
				table += ("<td id=\"z\">"+rs.getString("description")+"</td>");
				table += ("</tr>");
			}
			if(count == 0){
				out.println("<table><tr id=\"msg\"><td>No image found!</td></tr></table>");
			}
			else{
				table += "</table>";
				out.println(table);
			}
			}
			
		}
	%>
	</td></tr>
	<tr id="list"><td> 13-Find image by year </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="13">
				<input name="y13" type="number" placeholder="First year">
				<input name="y213" type="number" placeholder="Second year">
				<input type="submit" value="Go!"/>
			</form>
	<%
		if(fId != null && fId.equals("13")){
			String temp1 = request.getParameter("y13");
			String temp2 = request.getParameter("y213");
			if(temp1 == "" || temp2 == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter details.</td></tr></table>");
			}
			else if(temp1.length() > 4 || temp2.length() > 4 ){
					out.println("<table><tr id=\"msg\"><td>Year length is too long.</td></tr></table>");
			}
			else{
			int y13 = Integer.parseInt(request.getParameter("y13"));
			int y2 = Integer.parseInt(request.getParameter("y213"));
			if(y13 > y2){
				out.println("<table><tr id=\"msg\"><td>Year 1 should be smaller than year 2.</td></tr></table>");
			}
			else{
			String sql = "SELECT * FROM detail WHERE year >= "+y13+" && year <="+y2 ;
			ResultSet rs = stmt.executeQuery(sql);
			ResultSet r2;
			int count = 0;
			Statement stmt2 = conn.createStatement();
			String table = "";
			table += ("<table id=\"show\">");
			table += ("<tr id=\"z\">");
			table += ("<th id=\"z\">Title</th>");
			table += ("<th id=\"z\">Image</td>");
			table += ("<th id=\"z\">Year</th>");
			table += ("<th id=\"z\">Location</th>");
			table += ("<th id=\"z\">Type</th>");
			table += ("<th id=\"z\">Width</th>");
			table += ("<th id=\"z\">Height</th>");
			table += ("<th id=\"z\">Description</th>");
			table += ("</tr>");
			while(rs.next()){
				count++;
				sql = "SELECT * FROM image WHERE image_id = ";
				sql += rs.getInt("image_id");
				r2 = stmt2.executeQuery(sql);
				r2.next();
				table +=("<tr id=\"z\">");
				table +=("<td id=\"z\">"+r2.getString("title")+"</td>");
				table +=("<td id=\"z\"><img src=\"" +r2.getString("link")+ "\"width=\"100%\" height=\"auto\"></td>");
				table +=("<td id=\"z\">"+rs.getInt("year")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("Location")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("type")+"</td>");
				table +=("<td id=\"z\">"+rs.getInt("width")+"</td>");
				table +=("<td id=\"z\">"+rs.getInt("height")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("description")+"</td>");
				table +=("</tr>");
			}
			if(count == 0){
				out.println("<table><tr id=\"msg\"><td>No image found!</td></tr></table>");
			}
			else{
				table += "</table>";
				out.println(table);
			}
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 14-Find image by artist name </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="14">
				<input name="ar14" type="text" placeholder="Artist name">
				<input type="submit" value="Go!"/>
			</form>
	<%
		if(fId != null && fId.equals("14")){
			String ar14 = request.getParameter("ar14");
			if(ar14 == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter details.</td></tr></table>");
			}
			else if(ar14.length() > 45){
				out.println("<table><tr id=\"msg\"><td>Artist name length is too long.</td></tr></table>");
			}
			else{
			String sql = "SELECT artist_id FROM artist WHERE name =\""+ar14+"\"";
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.next()){
				int aId = rs.getInt(1);
				sql = "SELECT * FROM image WHERE artist_id = " + aId;
				ResultSet r2,r3;
				r3 = stmt.executeQuery(sql);
				Statement stmt2 = conn.createStatement();
				String table = "";
				table += ("<table id=\"show\">");
				table += ("<tr id=\"z\">");
				table += ("<th id=\"z\">Title</th>");
				table += ("<th id=\"z\">Image</td>");
				table += ("<th id=\"z\">Year</th>");
				table += ("<th id=\"z\">Location</th>");
				table += ("<th id=\"z\">Type</th>");
				table += ("<th id=\"z\">Width</th>");
				table += ("<th id=\"z\">Height</th>");
				table += ("<th id=\"z\">Description</th>");
				table += ("</tr>");
				int count = 0;
				while(r3.next()){
					count++;
					int iId = r3.getInt("image_id");
					r2 = stmt2.executeQuery("SELECT * from detail WHERE image_id ="+iId);
					r2.next();
					table +=("<tr id=\"z\">");
					table +=("<td id=\"z\">"+r3.getString("title")+"</td>");
					table +=("<td id=\"z\"><img src=\"" +r3.getString("link")+ "\" width=\"100%\" height=\"auto\"></td>");
					table +=("<td id=\"z\">"+r2.getInt("year")+"</td>");	
					table +=("<td id=\"z\">"+r2.getString("Location")+"</td>");
					table +=("<td id=\"z\">"+r2.getString("type")+"</td>");
					table +=("<td id=\"z\">"+r2.getInt("width")+"</td>");
					table +=("<td id=\"z\">"+r2.getInt("height")+"</td>");
					table +=("<td id=\"z\">"+r2.getString("description")+"</td>");
					table +=("</tr>");
				}
				if(count == 0){
					out.println("<table><tr id=\"msg\"><td>No image found!</td></tr></table>");
				}
				else{
					table += "</table>";
					out.println(table);
				}
				
			}
			else{
				out.println("<table><tr id=\"msg\"><td>Artist not found</td></tr></table>");
			}
			}
			
		}
	%>
	</td></tr>
	<tr id="list"><td> 15-Find image by location </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="15">
				<input name="lo15" type="text" placeholder="Location">
				<input type="submit" value="Go!"/>
			</form>
	<%
		if(fId != null && fId.equals("15")){
			String lo15 = request.getParameter("lo15");
			if(lo15 == ""){
				out.println("<table><tr id=\"msg\"><td>Please enter details.</td></tr></table>");
			}
			else if(lo15.length() > 45){
					out.println("<table><tr id=\"msg\"><td>Location length is too long.</td></tr></table>");
			}
			else{
			String sql = "SELECT * FROM detail WHERE location = ?";
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setString(1,lo15);
			ResultSet rs = statement.executeQuery();
			ResultSet r2;
			int count = 0;
			String table = "";
			table += ("<table id=\"show\">");
			table += ("<tr id=\"z\">");
			table += ("<th id=\"z\">Title</th>");
			table += ("<th id=\"z\">Image</td>");
			table += ("<th id=\"z\">Year</th>");
			table += ("<th id=\"z\">Location</th>");
			table += ("<th id=\"z\">Type</th>");
			table += ("<th id=\"z\">Width</th>");
			table += ("<th id=\"z\">Height</th>");
			table += ("<th id=\"z\">Description</th>");
			table += ("</tr>");
			while(rs.next()){
				count++;
				sql = "SELECT * FROM image WHERE image_id = ";
				sql += rs.getInt("image_id");
				r2 = stmt.executeQuery(sql);
				r2.next();
				table +=("<tr id=\"z\">");
				table +=("<td id=\"z\">"+r2.getString("title")+"</td>");
				table +=("<td id=\"z\"><img src=\"" +r2.getString("link")+ "\" width=\"100%\" height=\"auto\"></td>");
				table +=("<td id=\"z\">"+rs.getInt("year")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("Location")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("type")+"</td>");
				table +=("<td id=\"z\">"+rs.getInt("width")+"</td>");
				table +=("<td id=\"z\">"+rs.getInt("height")+"</td>");
				table +=("<td id=\"z\">"+rs.getString("description")+"</td>");
				table +=("</tr>");
			}
			if(count == 0){
					out.println("<table><tr id=\"msg\"><td>No image found!</td></tr></table>");
			}
			else{
				table += "</table>";
				out.println(table);
			}
			}
		}
	%>
	</td></tr>
	<tr id="list"><td> 16-Find artist by country </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="16">
				<input name="co16" type="text" placeholder="Country">
				<input type="submit" value="Go!"/>
			</form>
			<%
				if(fId != null && fId.equals("16")){
					String co16 = request.getParameter("co16");
					if(co16 == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter details.</td></tr></table>");
					}
					else if(co16.length() > 45){
								out.println("<table><tr id=\"msg\"><td>Country length is too long.</td></tr></table>");
					}
					else{
					String sql = "SELECT * FROM artist WHERE country = ?";
					PreparedStatement statement = conn.prepareStatement(sql);
					statement.setString(1,co16);	
					ResultSet rs = statement.executeQuery();
					String table = "";
					table += "<table id=\"show\">";
					table += ("<tr  id=\"z\">");
					table += ("<th id=\"z\">Id</th>");
					table += ("<th id=\"z\">Name</th>");
					table += ("<th id=\"z\">Birth year</th>");
					table += ("<th id=\"z\">Country</th>");
					table += ("<th id=\"z\">Description</th>");
					table += ("</tr>");
					int count = 0;
					while (rs.next()) {
						count++;
						table += ("<tr id=\"z\">");
						table += ("<td id=\"z\">"+rs.getString("artist_id")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("name")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("birth_year")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("country")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("description")+"</td>");
						table += ("</tr>");
					}
					if(count == 0){
						out.println("<table><tr id=\"msg\"><td>No artist found!</td></tr></table>");
					}
					else{
						table += "</table>";
						out.println(table);
					}
					}
				}
			%>
	</td></tr>
	<tr id="list"><td> 17-Find artist by birth year </td></tr>
	<tr><td>
	<form method="post"> 
				<input name="funcID" type="hidden" value="17">
				<input name="by17" type="number" placeholder="Birth year">
				<input type="submit" value="Go!"/>
			</form>
			<%
				if(fId != null && fId.equals("17")){
					String bd17 = request.getParameter("by17");
					if(bd17 == ""){
						out.println("<table><tr id=\"msg\"><td>Please enter details.</td></tr></table>");
					}
					else if(bd17.length() > 4){
								out.println("<table><tr id=\"msg\"><td>Birth year length is too long.</td></tr></table>");
					}
					else{
					String sql = "SELECT * FROM artist WHERE birth_year = ?";
					PreparedStatement statement = conn.prepareStatement(sql);
					statement.setInt(1,Integer.parseInt(bd17));	
					ResultSet rs = statement.executeQuery();
					String table = "";
					table += "<table id=\"show\">";
					table += ("<tr  id=\"z\">");
					table += ("<th id=\"z\">Id</th>");
					table += ("<th id=\"z\">Name</th>");
					table += ("<th id=\"z\">Birth year</th>");
					table += ("<th id=\"z\">Country</th>");
					table += ("<th id=\"z\">Description</th>");
					table += ("</tr>");
					int count = 0;
					while (rs.next()) {
						count++;
						table += ("<tr id=\"z\">");
						table += ("<td id=\"z\">"+rs.getString("artist_id")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("name")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("birth_year")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("country")+"</td>");
						table += ("<td id=\"z\">"+rs.getString("description")+"</td>");
						table += ("</tr>");
					}
					if(count == 0){
						out.println("<table><tr id=\"msg\"><td>No artist found!</td></tr></table>");
					}
					else{
						table += "</table>";
						out.println(table);
					}
					}
				}
			%>
	</td></tr>
</table>


</body>
</html>