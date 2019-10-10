
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DigitalassetlinksAssetlinksCheck_588710 = ref object of OpenApiRestCall_588441
proc url_DigitalassetlinksAssetlinksCheck_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DigitalassetlinksAssetlinksCheck_588711(path: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588827 = query.getOrDefault("target.web.site")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "target.web.site", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("target.androidApp.certificate.sha256Fingerprint")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "target.androidApp.certificate.sha256Fingerprint", valid_588842
  var valid_588843 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_588843
  var valid_588844 = query.getOrDefault("oauth_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "oauth_token", valid_588844
  var valid_588845 = query.getOrDefault("callback")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "callback", valid_588845
  var valid_588846 = query.getOrDefault("access_token")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "access_token", valid_588846
  var valid_588847 = query.getOrDefault("uploadType")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "uploadType", valid_588847
  var valid_588848 = query.getOrDefault("source.web.site")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "source.web.site", valid_588848
  var valid_588849 = query.getOrDefault("target.androidApp.packageName")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "target.androidApp.packageName", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("$.xgafv")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("1"))
  if valid_588851 != nil:
    section.add "$.xgafv", valid_588851
  var valid_588852 = query.getOrDefault("relation")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "relation", valid_588852
  var valid_588853 = query.getOrDefault("prettyPrint")
  valid_588853 = validateParameter(valid_588853, JBool, required = false,
                                 default = newJBool(true))
  if valid_588853 != nil:
    section.add "prettyPrint", valid_588853
  var valid_588854 = query.getOrDefault("source.androidApp.packageName")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "source.androidApp.packageName", valid_588854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588877: Call_DigitalassetlinksAssetlinksCheck_588710;
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
  let valid = call_588877.validator(path, query, header, formData, body)
  let scheme = call_588877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588877.url(scheme.get, call_588877.host, call_588877.base,
                         call_588877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588877, url, valid)

proc call*(call_588948: Call_DigitalassetlinksAssetlinksCheck_588710;
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
  var query_588949 = newJObject()
  add(query_588949, "upload_protocol", newJString(uploadProtocol))
  add(query_588949, "fields", newJString(fields))
  add(query_588949, "quotaUser", newJString(quotaUser))
  add(query_588949, "target.web.site", newJString(targetWebSite))
  add(query_588949, "alt", newJString(alt))
  add(query_588949, "target.androidApp.certificate.sha256Fingerprint",
      newJString(targetAndroidAppCertificateSha256Fingerprint))
  add(query_588949, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_588949, "oauth_token", newJString(oauthToken))
  add(query_588949, "callback", newJString(callback))
  add(query_588949, "access_token", newJString(accessToken))
  add(query_588949, "uploadType", newJString(uploadType))
  add(query_588949, "source.web.site", newJString(sourceWebSite))
  add(query_588949, "target.androidApp.packageName",
      newJString(targetAndroidAppPackageName))
  add(query_588949, "key", newJString(key))
  add(query_588949, "$.xgafv", newJString(Xgafv))
  add(query_588949, "relation", newJString(relation))
  add(query_588949, "prettyPrint", newJBool(prettyPrint))
  add(query_588949, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  result = call_588948.call(nil, query_588949, nil, nil, nil)

var digitalassetlinksAssetlinksCheck* = Call_DigitalassetlinksAssetlinksCheck_588710(
    name: "digitalassetlinksAssetlinksCheck", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/assetlinks:check",
    validator: validate_DigitalassetlinksAssetlinksCheck_588711, base: "/",
    url: url_DigitalassetlinksAssetlinksCheck_588712, schemes: {Scheme.Https})
type
  Call_DigitalassetlinksStatementsList_588989 = ref object of OpenApiRestCall_588441
proc url_DigitalassetlinksStatementsList_588991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DigitalassetlinksStatementsList_588990(path: JsonNode;
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
  var valid_588992 = query.getOrDefault("upload_protocol")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "upload_protocol", valid_588992
  var valid_588993 = query.getOrDefault("fields")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "fields", valid_588993
  var valid_588994 = query.getOrDefault("quotaUser")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "quotaUser", valid_588994
  var valid_588995 = query.getOrDefault("alt")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = newJString("json"))
  if valid_588995 != nil:
    section.add "alt", valid_588995
  var valid_588996 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_588996
  var valid_588997 = query.getOrDefault("oauth_token")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "oauth_token", valid_588997
  var valid_588998 = query.getOrDefault("callback")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "callback", valid_588998
  var valid_588999 = query.getOrDefault("access_token")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "access_token", valid_588999
  var valid_589000 = query.getOrDefault("uploadType")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "uploadType", valid_589000
  var valid_589001 = query.getOrDefault("source.web.site")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "source.web.site", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("$.xgafv")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = newJString("1"))
  if valid_589003 != nil:
    section.add "$.xgafv", valid_589003
  var valid_589004 = query.getOrDefault("relation")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "relation", valid_589004
  var valid_589005 = query.getOrDefault("prettyPrint")
  valid_589005 = validateParameter(valid_589005, JBool, required = false,
                                 default = newJBool(true))
  if valid_589005 != nil:
    section.add "prettyPrint", valid_589005
  var valid_589006 = query.getOrDefault("source.androidApp.packageName")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "source.androidApp.packageName", valid_589006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589007: Call_DigitalassetlinksStatementsList_588989;
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
  let valid = call_589007.validator(path, query, header, formData, body)
  let scheme = call_589007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589007.url(scheme.get, call_589007.host, call_589007.base,
                         call_589007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589007, url, valid)

proc call*(call_589008: Call_DigitalassetlinksStatementsList_588989;
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
  var query_589009 = newJObject()
  add(query_589009, "upload_protocol", newJString(uploadProtocol))
  add(query_589009, "fields", newJString(fields))
  add(query_589009, "quotaUser", newJString(quotaUser))
  add(query_589009, "alt", newJString(alt))
  add(query_589009, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_589009, "oauth_token", newJString(oauthToken))
  add(query_589009, "callback", newJString(callback))
  add(query_589009, "access_token", newJString(accessToken))
  add(query_589009, "uploadType", newJString(uploadType))
  add(query_589009, "source.web.site", newJString(sourceWebSite))
  add(query_589009, "key", newJString(key))
  add(query_589009, "$.xgafv", newJString(Xgafv))
  add(query_589009, "relation", newJString(relation))
  add(query_589009, "prettyPrint", newJBool(prettyPrint))
  add(query_589009, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  result = call_589008.call(nil, query_589009, nil, nil, nil)

var digitalassetlinksStatementsList* = Call_DigitalassetlinksStatementsList_588989(
    name: "digitalassetlinksStatementsList", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/statements:list",
    validator: validate_DigitalassetlinksStatementsList_588990, base: "/",
    url: url_DigitalassetlinksStatementsList_588991, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
