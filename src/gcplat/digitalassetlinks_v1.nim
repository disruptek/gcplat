
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Digital Asset Links
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Discovers relationships between online assets such as websites or mobile apps.
## 
## https://developers.google.com/digital-asset-links/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "digitalassetlinks"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DigitalassetlinksAssetlinksCheck_593677 = ref object of OpenApiRestCall_593408
proc url_DigitalassetlinksAssetlinksCheck_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DigitalassetlinksAssetlinksCheck_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Determines whether the specified (directional) relationship exists between
  ## the specified source and target assets.
  ## 
  ## The relation describes the intent of the link between the two assets as
  ## claimed by the source asset.  An example for such relationships is the
  ## delegation of privileges or permissions.
  ## 
  ## This command is most often used by infrastructure systems to check
  ## preconditions for an action.  For example, a client may want to know if it
  ## is OK to send a web URL to a particular mobile app instead. The client can
  ## check for the relevant asset link from the website to the mobile app to
  ## decide if the operation should be allowed.
  ## 
  ## A note about security: if you specify a secure asset as the source, such as
  ## an HTTPS website or an Android app, the API will ensure that any
  ## statements used to generate the response have been made in a secure way by
  ## the owner of that asset.  Conversely, if the source asset is an insecure
  ## HTTP website (that is, the URL starts with `http://` instead of
  ## `https://`), the API cannot verify its statements securely, and it is not
  ## possible to ensure that the website's statements have not been altered by a
  ## third party.  For more information, see the [Digital Asset Links technical
  ## design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   target.web.site: JString
  ##                  : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   alt: JString
  ##      : Data format for response.
  ##   target.androidApp.certificate.sha256Fingerprint: JString
  ##                                                  : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   source.androidApp.certificate.sha256Fingerprint: JString
  ##                                                  : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   source.web.site: JString
  ##                  : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   target.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   relation: JString
  ##           : Query string for the relation.
  ## 
  ## We identify relations with strings of the format `<kind>/<detail>`, where
  ## `<kind>` must be one of a set of pre-defined purpose categories, and
  ## `<detail>` is a free-form lowercase alphanumeric string that describes the
  ## specific use case of the statement.
  ## 
  ## Refer to [our API documentation](/digital-asset-links/v1/relation-strings)
  ## for the current list of supported relations.
  ## 
  ## For a query to match an asset link, both the query's and the asset link's
  ## relation strings must match exactly.
  ## 
  ## Example: A query with relation `delegate_permission/common.handle_all_urls`
  ## matches an asset link with relation
  ## `delegate_permission/common.handle_all_urls`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   source.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("quotaUser")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "quotaUser", valid_593793
  var valid_593794 = query.getOrDefault("target.web.site")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "target.web.site", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("target.androidApp.certificate.sha256Fingerprint")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "target.androidApp.certificate.sha256Fingerprint", valid_593809
  var valid_593810 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_593810
  var valid_593811 = query.getOrDefault("oauth_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "oauth_token", valid_593811
  var valid_593812 = query.getOrDefault("callback")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "callback", valid_593812
  var valid_593813 = query.getOrDefault("access_token")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "access_token", valid_593813
  var valid_593814 = query.getOrDefault("uploadType")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "uploadType", valid_593814
  var valid_593815 = query.getOrDefault("source.web.site")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "source.web.site", valid_593815
  var valid_593816 = query.getOrDefault("target.androidApp.packageName")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "target.androidApp.packageName", valid_593816
  var valid_593817 = query.getOrDefault("key")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "key", valid_593817
  var valid_593818 = query.getOrDefault("$.xgafv")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = newJString("1"))
  if valid_593818 != nil:
    section.add "$.xgafv", valid_593818
  var valid_593819 = query.getOrDefault("relation")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "relation", valid_593819
  var valid_593820 = query.getOrDefault("prettyPrint")
  valid_593820 = validateParameter(valid_593820, JBool, required = false,
                                 default = newJBool(true))
  if valid_593820 != nil:
    section.add "prettyPrint", valid_593820
  var valid_593821 = query.getOrDefault("source.androidApp.packageName")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "source.androidApp.packageName", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_DigitalassetlinksAssetlinksCheck_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Determines whether the specified (directional) relationship exists between
  ## the specified source and target assets.
  ## 
  ## The relation describes the intent of the link between the two assets as
  ## claimed by the source asset.  An example for such relationships is the
  ## delegation of privileges or permissions.
  ## 
  ## This command is most often used by infrastructure systems to check
  ## preconditions for an action.  For example, a client may want to know if it
  ## is OK to send a web URL to a particular mobile app instead. The client can
  ## check for the relevant asset link from the website to the mobile app to
  ## decide if the operation should be allowed.
  ## 
  ## A note about security: if you specify a secure asset as the source, such as
  ## an HTTPS website or an Android app, the API will ensure that any
  ## statements used to generate the response have been made in a secure way by
  ## the owner of that asset.  Conversely, if the source asset is an insecure
  ## HTTP website (that is, the URL starts with `http://` instead of
  ## `https://`), the API cannot verify its statements securely, and it is not
  ## possible to ensure that the website's statements have not been altered by a
  ## third party.  For more information, see the [Digital Asset Links technical
  ## design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_DigitalassetlinksAssetlinksCheck_593677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          targetWebSite: string = ""; alt: string = "json";
          targetAndroidAppCertificateSha256Fingerprint: string = "";
          sourceAndroidAppCertificateSha256Fingerprint: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; sourceWebSite: string = "";
          targetAndroidAppPackageName: string = ""; key: string = "";
          Xgafv: string = "1"; relation: string = ""; prettyPrint: bool = true;
          sourceAndroidAppPackageName: string = ""): Recallable =
  ## digitalassetlinksAssetlinksCheck
  ## Determines whether the specified (directional) relationship exists between
  ## the specified source and target assets.
  ## 
  ## The relation describes the intent of the link between the two assets as
  ## claimed by the source asset.  An example for such relationships is the
  ## delegation of privileges or permissions.
  ## 
  ## This command is most often used by infrastructure systems to check
  ## preconditions for an action.  For example, a client may want to know if it
  ## is OK to send a web URL to a particular mobile app instead. The client can
  ## check for the relevant asset link from the website to the mobile app to
  ## decide if the operation should be allowed.
  ## 
  ## A note about security: if you specify a secure asset as the source, such as
  ## an HTTPS website or an Android app, the API will ensure that any
  ## statements used to generate the response have been made in a secure way by
  ## the owner of that asset.  Conversely, if the source asset is an insecure
  ## HTTP website (that is, the URL starts with `http://` instead of
  ## `https://`), the API cannot verify its statements securely, and it is not
  ## possible to ensure that the website's statements have not been altered by a
  ## third party.  For more information, see the [Digital Asset Links technical
  ## design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   targetWebSite: string
  ##                : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   alt: string
  ##      : Data format for response.
  ##   targetAndroidAppCertificateSha256Fingerprint: string
  ##                                               : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   sourceAndroidAppCertificateSha256Fingerprint: string
  ##                                               : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   sourceWebSite: string
  ##                : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   targetAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   relation: string
  ##           : Query string for the relation.
  ## 
  ## We identify relations with strings of the format `<kind>/<detail>`, where
  ## `<kind>` must be one of a set of pre-defined purpose categories, and
  ## `<detail>` is a free-form lowercase alphanumeric string that describes the
  ## specific use case of the statement.
  ## 
  ## Refer to [our API documentation](/digital-asset-links/v1/relation-strings)
  ## for the current list of supported relations.
  ## 
  ## For a query to match an asset link, both the query's and the asset link's
  ## relation strings must match exactly.
  ## 
  ## Example: A query with relation `delegate_permission/common.handle_all_urls`
  ## matches an asset link with relation
  ## `delegate_permission/common.handle_all_urls`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   sourceAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  var query_593916 = newJObject()
  add(query_593916, "upload_protocol", newJString(uploadProtocol))
  add(query_593916, "fields", newJString(fields))
  add(query_593916, "quotaUser", newJString(quotaUser))
  add(query_593916, "target.web.site", newJString(targetWebSite))
  add(query_593916, "alt", newJString(alt))
  add(query_593916, "target.androidApp.certificate.sha256Fingerprint",
      newJString(targetAndroidAppCertificateSha256Fingerprint))
  add(query_593916, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_593916, "oauth_token", newJString(oauthToken))
  add(query_593916, "callback", newJString(callback))
  add(query_593916, "access_token", newJString(accessToken))
  add(query_593916, "uploadType", newJString(uploadType))
  add(query_593916, "source.web.site", newJString(sourceWebSite))
  add(query_593916, "target.androidApp.packageName",
      newJString(targetAndroidAppPackageName))
  add(query_593916, "key", newJString(key))
  add(query_593916, "$.xgafv", newJString(Xgafv))
  add(query_593916, "relation", newJString(relation))
  add(query_593916, "prettyPrint", newJBool(prettyPrint))
  add(query_593916, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var digitalassetlinksAssetlinksCheck* = Call_DigitalassetlinksAssetlinksCheck_593677(
    name: "digitalassetlinksAssetlinksCheck", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/assetlinks:check",
    validator: validate_DigitalassetlinksAssetlinksCheck_593678, base: "/",
    url: url_DigitalassetlinksAssetlinksCheck_593679, schemes: {Scheme.Https})
type
  Call_DigitalassetlinksStatementsList_593956 = ref object of OpenApiRestCall_593408
proc url_DigitalassetlinksStatementsList_593958(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DigitalassetlinksStatementsList_593957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of all statements from a given source that match the
  ## specified target and statement string.
  ## 
  ## The API guarantees that all statements with secure source assets, such as
  ## HTTPS websites or Android apps, have been made in a secure way by the owner
  ## of those assets, as described in the [Digital Asset Links technical design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ## Specifically, you should consider that for insecure websites (that is,
  ## where the URL starts with `http://` instead of `https://`), this guarantee
  ## cannot be made.
  ## 
  ## The `List` command is most useful in cases where the API client wants to
  ## know all the ways in which two assets are related, or enumerate all the
  ## relationships from a particular source asset.  Example: a feature that
  ## helps users navigate to related items.  When a mobile app is running on a
  ## device, the feature would make it easy to navigate to the corresponding web
  ## site or Google+ profile.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   source.androidApp.certificate.sha256Fingerprint: JString
  ##                                                  : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   source.web.site: JString
  ##                  : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   relation: JString
  ##           : Use only associations that match the specified relation.
  ## 
  ## See the [`Statement`](#Statement) message for a detailed definition of
  ## relation strings.
  ## 
  ## For a query to match a statement, one of the following must be true:
  ## 
  ## *    both the query's and the statement's relation strings match exactly,
  ##      or
  ## *    the query's relation string is empty or missing.
  ## 
  ## Example: A query with relation `delegate_permission/common.handle_all_urls`
  ## matches an asset link with relation
  ## `delegate_permission/common.handle_all_urls`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   source.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  section = newJObject()
  var valid_593959 = query.getOrDefault("upload_protocol")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "upload_protocol", valid_593959
  var valid_593960 = query.getOrDefault("fields")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "fields", valid_593960
  var valid_593961 = query.getOrDefault("quotaUser")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "quotaUser", valid_593961
  var valid_593962 = query.getOrDefault("alt")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = newJString("json"))
  if valid_593962 != nil:
    section.add "alt", valid_593962
  var valid_593963 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_593963
  var valid_593964 = query.getOrDefault("oauth_token")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "oauth_token", valid_593964
  var valid_593965 = query.getOrDefault("callback")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "callback", valid_593965
  var valid_593966 = query.getOrDefault("access_token")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "access_token", valid_593966
  var valid_593967 = query.getOrDefault("uploadType")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "uploadType", valid_593967
  var valid_593968 = query.getOrDefault("source.web.site")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "source.web.site", valid_593968
  var valid_593969 = query.getOrDefault("key")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "key", valid_593969
  var valid_593970 = query.getOrDefault("$.xgafv")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = newJString("1"))
  if valid_593970 != nil:
    section.add "$.xgafv", valid_593970
  var valid_593971 = query.getOrDefault("relation")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "relation", valid_593971
  var valid_593972 = query.getOrDefault("prettyPrint")
  valid_593972 = validateParameter(valid_593972, JBool, required = false,
                                 default = newJBool(true))
  if valid_593972 != nil:
    section.add "prettyPrint", valid_593972
  var valid_593973 = query.getOrDefault("source.androidApp.packageName")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "source.androidApp.packageName", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_DigitalassetlinksStatementsList_593956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of all statements from a given source that match the
  ## specified target and statement string.
  ## 
  ## The API guarantees that all statements with secure source assets, such as
  ## HTTPS websites or Android apps, have been made in a secure way by the owner
  ## of those assets, as described in the [Digital Asset Links technical design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ## Specifically, you should consider that for insecure websites (that is,
  ## where the URL starts with `http://` instead of `https://`), this guarantee
  ## cannot be made.
  ## 
  ## The `List` command is most useful in cases where the API client wants to
  ## know all the ways in which two assets are related, or enumerate all the
  ## relationships from a particular source asset.  Example: a feature that
  ## helps users navigate to related items.  When a mobile app is running on a
  ## device, the feature would make it easy to navigate to the corresponding web
  ## site or Google+ profile.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_DigitalassetlinksStatementsList_593956;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json";
          sourceAndroidAppCertificateSha256Fingerprint: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; sourceWebSite: string = ""; key: string = "";
          Xgafv: string = "1"; relation: string = ""; prettyPrint: bool = true;
          sourceAndroidAppPackageName: string = ""): Recallable =
  ## digitalassetlinksStatementsList
  ## Retrieves a list of all statements from a given source that match the
  ## specified target and statement string.
  ## 
  ## The API guarantees that all statements with secure source assets, such as
  ## HTTPS websites or Android apps, have been made in a secure way by the owner
  ## of those assets, as described in the [Digital Asset Links technical design
  ## specification](https://github.com/google/digitalassetlinks/blob/master/well-known/details.md).
  ## Specifically, you should consider that for insecure websites (that is,
  ## where the URL starts with `http://` instead of `https://`), this guarantee
  ## cannot be made.
  ## 
  ## The `List` command is most useful in cases where the API client wants to
  ## know all the ways in which two assets are related, or enumerate all the
  ## relationships from a particular source asset.  Example: a feature that
  ## helps users navigate to related items.  When a mobile app is running on a
  ## device, the feature would make it easy to navigate to the corresponding web
  ## site or Google+ profile.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   sourceAndroidAppCertificateSha256Fingerprint: string
  ##                                               : The uppercase SHA-265 fingerprint of the certificate.  From the PEM
  ##  certificate, it can be acquired like this:
  ## 
  ##     $ keytool -printcert -file $CERTFILE | grep SHA256:
  ##     SHA256: 14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83: \
  ##         42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## or like this:
  ## 
  ##     $ openssl x509 -in $CERTFILE -noout -fingerprint -sha256
  ##     SHA256 Fingerprint=14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64: \
  ##         16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5
  ## 
  ## In this example, the contents of this field would be `14:6D:E9:83:C5:73:
  ## 06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:
  ## 44:E5`.
  ## 
  ## If these tools are not available to you, you can convert the PEM
  ## certificate into the DER format, compute the SHA-256 hash of that string
  ## and represent the result as a hexstring (that is, uppercase hexadecimal
  ## representations of each octet, separated by colons).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   sourceWebSite: string
  ##                : Web assets are identified by a URL that contains only the scheme, hostname
  ## and port parts.  The format is
  ## 
  ##     http[s]://<hostname>[:<port>]
  ## 
  ## Hostnames must be fully qualified: they must end in a single period
  ## ("`.`").
  ## 
  ## Only the schemes "http" and "https" are currently allowed.
  ## 
  ## Port numbers are given as a decimal number, and they must be omitted if the
  ## standard port numbers are used: 80 for http and 443 for https.
  ## 
  ## We call this limited URL the "site".  All URLs that share the same scheme,
  ## hostname and port are considered to be a part of the site and thus belong
  ## to the web asset.
  ## 
  ## Example: the asset with the site `https://www.google.com` contains all
  ## these URLs:
  ## 
  ##   *   `https://www.google.com/`
  ##   *   `https://www.google.com:443/`
  ##   *   `https://www.google.com/foo`
  ##   *   `https://www.google.com/foo?bar`
  ##   *   `https://www.google.com/foo#bar`
  ##   *   `https://user@password:www.google.com/`
  ## 
  ## But it does not contain these URLs:
  ## 
  ##   *   `http://www.google.com/`       (wrong scheme)
  ##   *   `https://google.com/`          (hostname does not match)
  ##   *   `https://www.google.com:444/`  (port does not match)
  ## REQUIRED
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   relation: string
  ##           : Use only associations that match the specified relation.
  ## 
  ## See the [`Statement`](#Statement) message for a detailed definition of
  ## relation strings.
  ## 
  ## For a query to match a statement, one of the following must be true:
  ## 
  ## *    both the query's and the statement's relation strings match exactly,
  ##      or
  ## *    the query's relation string is empty or missing.
  ## 
  ## Example: A query with relation `delegate_permission/common.handle_all_urls`
  ## matches an asset link with relation
  ## `delegate_permission/common.handle_all_urls`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   sourceAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  var query_593976 = newJObject()
  add(query_593976, "upload_protocol", newJString(uploadProtocol))
  add(query_593976, "fields", newJString(fields))
  add(query_593976, "quotaUser", newJString(quotaUser))
  add(query_593976, "alt", newJString(alt))
  add(query_593976, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_593976, "oauth_token", newJString(oauthToken))
  add(query_593976, "callback", newJString(callback))
  add(query_593976, "access_token", newJString(accessToken))
  add(query_593976, "uploadType", newJString(uploadType))
  add(query_593976, "source.web.site", newJString(sourceWebSite))
  add(query_593976, "key", newJString(key))
  add(query_593976, "$.xgafv", newJString(Xgafv))
  add(query_593976, "relation", newJString(relation))
  add(query_593976, "prettyPrint", newJBool(prettyPrint))
  add(query_593976, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  result = call_593975.call(nil, query_593976, nil, nil, nil)

var digitalassetlinksStatementsList* = Call_DigitalassetlinksStatementsList_593956(
    name: "digitalassetlinksStatementsList", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/statements:list",
    validator: validate_DigitalassetlinksStatementsList_593957, base: "/",
    url: url_DigitalassetlinksStatementsList_593958, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
