
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "digitalassetlinks"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DigitalassetlinksAssetlinksCheck_578610 = ref object of OpenApiRestCall_578339
proc url_DigitalassetlinksAssetlinksCheck_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DigitalassetlinksAssetlinksCheck_578611(path: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   target.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("source.androidApp.packageName")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "source.androidApp.packageName", valid_578740
  var valid_578741 = query.getOrDefault("target.web.site")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "target.web.site", valid_578741
  var valid_578742 = query.getOrDefault("$.xgafv")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("1"))
  if valid_578742 != nil:
    section.add "$.xgafv", valid_578742
  var valid_578743 = query.getOrDefault("target.androidApp.packageName")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "target.androidApp.packageName", valid_578743
  var valid_578744 = query.getOrDefault("alt")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = newJString("json"))
  if valid_578744 != nil:
    section.add "alt", valid_578744
  var valid_578745 = query.getOrDefault("uploadType")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "uploadType", valid_578745
  var valid_578746 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_578746
  var valid_578747 = query.getOrDefault("quotaUser")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "quotaUser", valid_578747
  var valid_578748 = query.getOrDefault("target.androidApp.certificate.sha256Fingerprint")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "target.androidApp.certificate.sha256Fingerprint", valid_578748
  var valid_578749 = query.getOrDefault("relation")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "relation", valid_578749
  var valid_578750 = query.getOrDefault("callback")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "callback", valid_578750
  var valid_578751 = query.getOrDefault("fields")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "fields", valid_578751
  var valid_578752 = query.getOrDefault("access_token")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "access_token", valid_578752
  var valid_578753 = query.getOrDefault("upload_protocol")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "upload_protocol", valid_578753
  var valid_578754 = query.getOrDefault("source.web.site")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "source.web.site", valid_578754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578777: Call_DigitalassetlinksAssetlinksCheck_578610;
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
  let valid = call_578777.validator(path, query, header, formData, body)
  let scheme = call_578777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578777.url(scheme.get, call_578777.host, call_578777.base,
                         call_578777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578777, url, valid)

proc call*(call_578848: Call_DigitalassetlinksAssetlinksCheck_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          sourceAndroidAppPackageName: string = ""; targetWebSite: string = "";
          Xgafv: string = "1"; targetAndroidAppPackageName: string = "";
          alt: string = "json"; uploadType: string = "";
          sourceAndroidAppCertificateSha256Fingerprint: string = "";
          quotaUser: string = "";
          targetAndroidAppCertificateSha256Fingerprint: string = "";
          relation: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          sourceWebSite: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   targetAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
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
  var query_578849 = newJObject()
  add(query_578849, "key", newJString(key))
  add(query_578849, "prettyPrint", newJBool(prettyPrint))
  add(query_578849, "oauth_token", newJString(oauthToken))
  add(query_578849, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  add(query_578849, "target.web.site", newJString(targetWebSite))
  add(query_578849, "$.xgafv", newJString(Xgafv))
  add(query_578849, "target.androidApp.packageName",
      newJString(targetAndroidAppPackageName))
  add(query_578849, "alt", newJString(alt))
  add(query_578849, "uploadType", newJString(uploadType))
  add(query_578849, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_578849, "quotaUser", newJString(quotaUser))
  add(query_578849, "target.androidApp.certificate.sha256Fingerprint",
      newJString(targetAndroidAppCertificateSha256Fingerprint))
  add(query_578849, "relation", newJString(relation))
  add(query_578849, "callback", newJString(callback))
  add(query_578849, "fields", newJString(fields))
  add(query_578849, "access_token", newJString(accessToken))
  add(query_578849, "upload_protocol", newJString(uploadProtocol))
  add(query_578849, "source.web.site", newJString(sourceWebSite))
  result = call_578848.call(nil, query_578849, nil, nil, nil)

var digitalassetlinksAssetlinksCheck* = Call_DigitalassetlinksAssetlinksCheck_578610(
    name: "digitalassetlinksAssetlinksCheck", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/assetlinks:check",
    validator: validate_DigitalassetlinksAssetlinksCheck_578611, base: "/",
    url: url_DigitalassetlinksAssetlinksCheck_578612, schemes: {Scheme.Https})
type
  Call_DigitalassetlinksStatementsList_578889 = ref object of OpenApiRestCall_578339
proc url_DigitalassetlinksStatementsList_578891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DigitalassetlinksStatementsList_578890(path: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   source.androidApp.packageName: JString
  ##                                : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  section = newJObject()
  var valid_578892 = query.getOrDefault("key")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "key", valid_578892
  var valid_578893 = query.getOrDefault("prettyPrint")
  valid_578893 = validateParameter(valid_578893, JBool, required = false,
                                 default = newJBool(true))
  if valid_578893 != nil:
    section.add "prettyPrint", valid_578893
  var valid_578894 = query.getOrDefault("oauth_token")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "oauth_token", valid_578894
  var valid_578895 = query.getOrDefault("source.androidApp.packageName")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "source.androidApp.packageName", valid_578895
  var valid_578896 = query.getOrDefault("$.xgafv")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = newJString("1"))
  if valid_578896 != nil:
    section.add "$.xgafv", valid_578896
  var valid_578897 = query.getOrDefault("alt")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = newJString("json"))
  if valid_578897 != nil:
    section.add "alt", valid_578897
  var valid_578898 = query.getOrDefault("uploadType")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "uploadType", valid_578898
  var valid_578899 = query.getOrDefault("source.androidApp.certificate.sha256Fingerprint")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "source.androidApp.certificate.sha256Fingerprint", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("relation")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "relation", valid_578901
  var valid_578902 = query.getOrDefault("callback")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "callback", valid_578902
  var valid_578903 = query.getOrDefault("fields")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "fields", valid_578903
  var valid_578904 = query.getOrDefault("access_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "access_token", valid_578904
  var valid_578905 = query.getOrDefault("upload_protocol")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "upload_protocol", valid_578905
  var valid_578906 = query.getOrDefault("source.web.site")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "source.web.site", valid_578906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578907: Call_DigitalassetlinksStatementsList_578889;
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
  let valid = call_578907.validator(path, query, header, formData, body)
  let scheme = call_578907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578907.url(scheme.get, call_578907.host, call_578907.base,
                         call_578907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578907, url, valid)

proc call*(call_578908: Call_DigitalassetlinksStatementsList_578889;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          sourceAndroidAppPackageName: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = "";
          sourceAndroidAppCertificateSha256Fingerprint: string = "";
          quotaUser: string = ""; relation: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          sourceWebSite: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceAndroidAppPackageName: string
  ##                              : Android App assets are naturally identified by their Java package name.
  ## For example, the Google Maps app uses the package name
  ## `com.google.android.apps.maps`.
  ## REQUIRED
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
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
  var query_578909 = newJObject()
  add(query_578909, "key", newJString(key))
  add(query_578909, "prettyPrint", newJBool(prettyPrint))
  add(query_578909, "oauth_token", newJString(oauthToken))
  add(query_578909, "source.androidApp.packageName",
      newJString(sourceAndroidAppPackageName))
  add(query_578909, "$.xgafv", newJString(Xgafv))
  add(query_578909, "alt", newJString(alt))
  add(query_578909, "uploadType", newJString(uploadType))
  add(query_578909, "source.androidApp.certificate.sha256Fingerprint",
      newJString(sourceAndroidAppCertificateSha256Fingerprint))
  add(query_578909, "quotaUser", newJString(quotaUser))
  add(query_578909, "relation", newJString(relation))
  add(query_578909, "callback", newJString(callback))
  add(query_578909, "fields", newJString(fields))
  add(query_578909, "access_token", newJString(accessToken))
  add(query_578909, "upload_protocol", newJString(uploadProtocol))
  add(query_578909, "source.web.site", newJString(sourceWebSite))
  result = call_578908.call(nil, query_578909, nil, nil, nil)

var digitalassetlinksStatementsList* = Call_DigitalassetlinksStatementsList_578889(
    name: "digitalassetlinksStatementsList", meth: HttpMethod.HttpGet,
    host: "digitalassetlinks.googleapis.com", route: "/v1/statements:list",
    validator: validate_DigitalassetlinksStatementsList_578890, base: "/",
    url: url_DigitalassetlinksStatementsList_578891, schemes: {Scheme.Https})
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
