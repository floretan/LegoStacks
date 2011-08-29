
class Participant {
  String name;
  long time;

  Participant() {
  }

  void saveScore() {
    String url = "http://lego.wunderkraut.com/services/node.xml";

    try {
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpPost          httpPost   = new HttpPost(url);

      // Build the parameters.
      List<NameValuePair> formparams = new ArrayList<NameValuePair>();
      formparams.add(new BasicNameValuePair("node[type]", "score"));
      formparams.add(new BasicNameValuePair("node[title]", this.name));
      formparams.add(new BasicNameValuePair("node[field_time][und][0][value]", Long.toString(this.time)));
      UrlEncodedFormEntity postEntity = new UrlEncodedFormEntity(formparams, "UTF-8");
      httpPost.setEntity(postEntity);

      println( "executing request: " + httpPost.getRequestLine() );

      HttpResponse response = httpClient.execute( httpPost );
      HttpEntity   entity   = response.getEntity();
      //
      //
      //      println("----------------------------------------");
      //      println( response.getStatusLine() );
      //      println("----------------------------------------");
      //
      //      if ( entity != null ) entity.writeTo( System.out );
      //      if ( entity != null ) entity.consumeContent();
      //

      // When HttpClient instance is no longer needed, 
      // shut down the connection manager to ensure
      // immediate deallocation of all system resources
      httpClient.getConnectionManager().shutdown();
    } 
    catch( Exception e ) { 
      e.printStackTrace();
    }

    // Also save scores locally.
    PrintWriter pw = null;
    try {
      pw = new PrintWriter(new BufferedWriter(new FileWriter("scores.txt", true)));
      pw.println(this.name + "," + this.time);
    } 
    catch (IOException e)  {
      // Report problem or handle it
    }
    finally {
      if (pw != null) {
        pw.close();
      }
    }
  }
}

