![Maintained YES](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square&color=important)
![Memory Leak Verified YES](https://img.shields.io/badge/Memory%20Leak%20Verified%3F-yes-green.svg?style=flat-square&color=important)
![Release](https://img.shields.io/github/v/release/antoniojmsjr/IPGeoLocation?label=Latest%20release&style=flat-square&color=important)
![Stars](https://img.shields.io/github/stars/antoniojmsjr/IPGeoLocation.svg?style=flat-square)
![Forks](https://img.shields.io/github/forks/antoniojmsjr/IPGeoLocation.svg?style=flat-square)
![Issues](https://img.shields.io/github/issues/antoniojmsjr/IPGeoLocation.svg?style=flat-square&color=blue)</br>
![Compatibility](https://img.shields.io/badge/Compatibility-VCL,%20Firemonkey,%20DataSnap,%20Horse,%20RDW,%20RADServer-3db36a?style=flat-square)
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-Tokyo%2010.2.3%20and%20above-3db36a?style=flat-square)
<p align="center">
  <a href="https://github.com/antoniojmsjr/IPGeoLocation/blob/master/Image/logo.png">
    <img alt="IPGeolocation" height="150" src="https://github.com/antoniojmsjr/IPGeoLocation/blob/master/Image/logo.png">
  </a>
</p>

# IPGeoLocation

Biblioteca de geolocalização por IP.

Implementado na linguagem Delphi, utiliza o conceito de [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface) para guiar no uso da biblioteca.</br>
Biblioteca desenvolvida utilizando os principais players do mercado de solução de "IP-Geolocation", em anexo a lista dos provedores homologados.

## O que é a geolocalização de IP?

A geolocalização baseada em endereços IP é uma técnica usada para estimar a localização geográfica de um dispositivo conectado à Internet usando o endereço IP do mesmo.  Este mecanismo depende de que o endereço IP do dispositivo apareça em um banco de dados com sua respectiva localização, endereço postal, cidade, país, região ou coordenadas geográficas, que são alguns dos níveis de detalhe que podem ser registrados.

Para mais informações: [Geolocalização de IPs](https://www.lacnic.net/3107/3/lacnic/geolocalizac%C3%A3o-de-ips)

## Para que?

Essa tecnologia é amplamente usada em:

* Geo Marketing
  * Propagandas direcionadas/sob medida
  * Informação interessante com base na localização
  * Promoções/campanhas destinadas a certo público/local
  * Empresas de turismo, companhias aéreas, redes hoteleiras
  * Entretenimento

* Direcionamento de conteúdo
  * Portais “globais” com conteúdos “locais”
  * Informações no idioma do leitor
  * Conteúdo de interesse local (notícia, novidades, etc)
  * Portais de notícias
  * Serviços de informação meteorológica
  * Serviços de emergência

* Controle de acesso (à conteúdos/serviços)
  * Restringir acesso conteúdo/serviços com base na “localização” do usuário
  * Conteúdos específicos para determinado “público”
  * Censura
  * Jogos online
  * Streaming vídeos/músicas

* Segurança
  * Restringir tráfego, por localização do usuário
  * Em situação de emergência/ataque descartar tráfego “não esperado”
  * Controle de SPAM
  * Firewalls

## Provedores Homologados

| Provedor | Site | API | Free Requests |
|---|---|---|---|
| IP2Location | https://www.ip2location.com | https://api.ip2location.com/v2 | 30.000 yearthly |
| IP2Location.io | https://www.ip2location.io | https://api.ip2location.io | 50.000 monthly |
| IPGeolocation | https://ipgeolocation.io | https://api.ipgeolocation.io/ipgeo | 1.500 daily |
| IPStack  | https://ipstack.com | http://api.ipstack.com | 10.000 monthly |
| IPIfy | https://geo.ipify.org | https://geo.ipify.org/api/v1 | 1.000 monthly |
| IPAPI | https://ipapi.com | http://api.ipapi.com/api | 10.000 yearthly |
| IPInfo | https://ipinfo.io | https://ipinfo.io | 50.000 monthly |
| IPGeolocationAPI | https://ipgeolocationapi.com | https://api.ipgeolocationapi.com/geolocate | Unlimited |
| IPWhois | https://ipwhois.io | http://ipwhois.app | 10.000 monthly |
| IPDig | https://ipdig.io | https://ipdig.io | Unlimited |
| IPData | https://ipdata.co | https://api.ipdata.co | 1.500 daily |
| IPLabstack | https://labstack.com/ip | https://ip.labstack.com/api/v1 | 10.000 monthly |
| IPTwist | https://iptwist.com | https://iptwist.com | 1.000 monthly |
| IP-API | https://ip-api.com | http://ip-api.com | Unlimited |
| DB-IP | https://db-ip.com | http://api.db-ip.com/v2 | Unlimited |

## Instalação Automatizada

Utilizando o [**Boss**](https://github.com/HashLoad/boss) (Dependency anager for Delphi) é possível instalar a biblioteca de forma automática.

```
boss install github.com/antoniojmsjr/IPGeoLocation
```

## Instalação Manual:

Project > Options > Delphi Compiler > Target > All Configurations > Search path

```
..\IPGeoLocation\Source
```

## Uso
```delphi
uses IPGeoLocation, IPGeoLocation.Interfaces, IPGeoLocation.Types;
```

```delphi
var
  lMsgError: string;
  lGeoLocation: IGeoLocation;
begin

  try
    lGeoLocation := TIPGeoLocation.New
      .IP['201.86.220.241']
      .Provider[TIPGeoLocationProviderKind.IPInfo]
        //.SetTimeout(5000) //[OPCIONAL]
        //.SetAPIKey('TOKEN') //[OPCIONAL]: VERIFICAR ARQUIVO: APIKey.inc
      .Request
        //.SetResultLanguageCode('pt-br') //[OPCIONAL]
        .Execute;

    Application.MessageBox(PWideChar(lGeoLocation.ToJSON), 'JSON', MB_OK + MB_ICONINFORMATION); //JSON COM O RESULTADO DA GEOLOCALIZAÇÃO
  except
    on E: EIPGeoLocationRequestException do
    begin
      lMsgError := Concat(lMsgError, Format('IP: %s', [E.IP]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('IPVersion: %s', [E.IPVersion]), sLineBreak);      
      lMsgError := Concat(lMsgError, Format('Provider: %s', [E.Provider]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('DateTime: %s', [DateTimeTostr(E.DateTime)]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Kind: %s', [E.Kind.AsString]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('URL: %s', [E.URL]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Method: %s', [E.Method]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Code: %d', [E.StatusCode]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Status Text: %s', [E.StatusText]), sLineBreak);
      lMsgError := Concat(lMsgError, Format('Message: %s', [E.Message]));

      Application.MessageBox(PWideChar(lMsgError), 'A T E N Ç Ã O', MB_OK + MB_ICONERROR);
    end;
    on E: Exception do
    begin
      Application.MessageBox(PWideChar(E.Message), 'A T E N Ç Ã O', MB_OK + MB_ICONERROR);
    end;
  end;

end;
```

## Demo
[![Download](https://img.shields.io/badge/Download-Demo.zip-orange.svg)](https://github.com/antoniojmsjr/IPGeoLocation/files/5663736/Demo.zip)
![IP Geolocalização](https://user-images.githubusercontent.com/20980984/70379772-a2843a80-190f-11ea-98b7-2bde17365438.png)

## Youtube
[![Vídeo Youtube](https://user-images.githubusercontent.com/20980984/72579261-5c7ba880-38b7-11ea-9b20-942d806a14d9.png)](https://www.youtube.com/watch?v=x8CVAudNkSY)

## Licença
`IPGeoLocation` is free and open-source software licensed under the [![License](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://github.com/antoniojmsjr/IPGeoLocation/blob/master/LICENSE)
