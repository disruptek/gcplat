
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: App Engine Admin
## version: v1alpha
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provisions and manages developers' App Engine applications.
## 
## https://cloud.google.com/appengine/docs/admin-api/
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
  gcpServiceName = "appengine"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppengineAppsAuthorizedCertificatesCreate_578901 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedCertificatesCreate_578903(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesCreate_578902(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads the specified SSL certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578904 = path.getOrDefault("appsId")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "appsId", valid_578904
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("callback")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "callback", valid_578912
  var valid_578913 = query.getOrDefault("fields")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "fields", valid_578913
  var valid_578914 = query.getOrDefault("access_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "access_token", valid_578914
  var valid_578915 = query.getOrDefault("upload_protocol")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "upload_protocol", valid_578915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_AppengineAppsAuthorizedCertificatesCreate_578901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_AppengineAppsAuthorizedCertificatesCreate_578901;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsAuthorizedCertificatesCreate
  ## Uploads the specified SSL certificate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  var body_578921 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(path_578919, "appsId", newJString(appsId))
  add(query_578920, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578921 = body
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(path_578919, query_578920, nil, nil, body_578921)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_578901(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_578902,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_578903,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_578610 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedCertificatesList_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578738 = path.getOrDefault("appsId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "appsId", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Controls the set of fields returned in the LIST response.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("pageSize")
  valid_578756 = validateParameter(valid_578756, JInt, required = false, default = nil)
  if valid_578756 != nil:
    section.add "pageSize", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("pageToken")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "pageToken", valid_578760
  var valid_578761 = query.getOrDefault("callback")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "callback", valid_578761
  var valid_578762 = query.getOrDefault("fields")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "fields", valid_578762
  var valid_578763 = query.getOrDefault("access_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "access_token", valid_578763
  var valid_578764 = query.getOrDefault("upload_protocol")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "upload_protocol", valid_578764
  var valid_578765 = query.getOrDefault("view")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_578765 != nil:
    section.add "view", valid_578765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578788: Call_AppengineAppsAuthorizedCertificatesList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_578788.validator(path, query, header, formData, body)
  let scheme = call_578788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578788.url(scheme.get, call_578788.host, call_578788.base,
                         call_578788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578788, url, valid)

proc call*(call_578859: Call_AppengineAppsAuthorizedCertificatesList_578610;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "BASIC_CERTIFICATE"): Recallable =
  ## appengineAppsAuthorizedCertificatesList
  ## Lists all SSL certificates the user is authorized to administer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Controls the set of fields returned in the LIST response.
  var path_578860 = newJObject()
  var query_578862 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "pageSize", newJInt(pageSize))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(path_578860, "appsId", newJString(appsId))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(query_578862, "pageToken", newJString(pageToken))
  add(query_578862, "callback", newJString(callback))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  add(query_578862, "view", newJString(view))
  result = call_578859.call(path_578860, query_578862, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_578610(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_578611, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_578612,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_578922 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedCertificatesGet_578924(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesGet_578923(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified SSL certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/authorizedCertificates/12345.
  ##   authorizedCertificatesId: JString (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578925 = path.getOrDefault("appsId")
  valid_578925 = validateParameter(valid_578925, JString, required = true,
                                 default = nil)
  if valid_578925 != nil:
    section.add "appsId", valid_578925
  var valid_578926 = path.getOrDefault("authorizedCertificatesId")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "authorizedCertificatesId", valid_578926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Controls the set of fields returned in the GET response.
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("$.xgafv")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("1"))
  if valid_578930 != nil:
    section.add "$.xgafv", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
  var valid_578938 = query.getOrDefault("view")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_578938 != nil:
    section.add "view", valid_578938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578939: Call_AppengineAppsAuthorizedCertificatesGet_578922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_AppengineAppsAuthorizedCertificatesGet_578922;
          appsId: string; authorizedCertificatesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "BASIC_CERTIFICATE"): Recallable =
  ## appengineAppsAuthorizedCertificatesGet
  ## Gets the specified SSL certificate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/authorizedCertificates/12345.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Controls the set of fields returned in the GET response.
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "$.xgafv", newJString(Xgafv))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "uploadType", newJString(uploadType))
  add(path_578941, "appsId", newJString(appsId))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(query_578942, "callback", newJString(callback))
  add(path_578941, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_578942, "fields", newJString(fields))
  add(query_578942, "access_token", newJString(accessToken))
  add(query_578942, "upload_protocol", newJString(uploadProtocol))
  add(query_578942, "view", newJString(view))
  result = call_578940.call(path_578941, query_578942, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_578922(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_578923, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_578924,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_578963 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedCertificatesPatch_578965(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesPatch_578964(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/authorizedCertificates/12345.
  ##   authorizedCertificatesId: JString (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578966 = path.getOrDefault("appsId")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "appsId", valid_578966
  var valid_578967 = path.getOrDefault("authorizedCertificatesId")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "authorizedCertificatesId", valid_578967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated. Updates are only supported on the certificate_raw_data and display_name fields.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  var valid_578971 = query.getOrDefault("$.xgafv")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("1"))
  if valid_578971 != nil:
    section.add "$.xgafv", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("uploadType")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "uploadType", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("updateMask")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "updateMask", valid_578975
  var valid_578976 = query.getOrDefault("callback")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "callback", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  var valid_578978 = query.getOrDefault("access_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "access_token", valid_578978
  var valid_578979 = query.getOrDefault("upload_protocol")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "upload_protocol", valid_578979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578981: Call_AppengineAppsAuthorizedCertificatesPatch_578963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_AppengineAppsAuthorizedCertificatesPatch_578963;
          appsId: string; authorizedCertificatesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsAuthorizedCertificatesPatch
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/authorizedCertificates/12345.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated. Updates are only supported on the certificate_raw_data and display_name fields.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  var body_578985 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "$.xgafv", newJString(Xgafv))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "uploadType", newJString(uploadType))
  add(path_578983, "appsId", newJString(appsId))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(query_578984, "updateMask", newJString(updateMask))
  if body != nil:
    body_578985 = body
  add(query_578984, "callback", newJString(callback))
  add(path_578983, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_578984, "fields", newJString(fields))
  add(query_578984, "access_token", newJString(accessToken))
  add(query_578984, "upload_protocol", newJString(uploadProtocol))
  result = call_578982.call(path_578983, query_578984, nil, nil, body_578985)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_578963(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_578964,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_578965,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_578943 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedCertificatesDelete_578945(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesDelete_578944(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified SSL certificate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/authorizedCertificates/12345.
  ##   authorizedCertificatesId: JString (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578946 = path.getOrDefault("appsId")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "appsId", valid_578946
  var valid_578947 = path.getOrDefault("authorizedCertificatesId")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "authorizedCertificatesId", valid_578947
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578948 = query.getOrDefault("key")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "key", valid_578948
  var valid_578949 = query.getOrDefault("prettyPrint")
  valid_578949 = validateParameter(valid_578949, JBool, required = false,
                                 default = newJBool(true))
  if valid_578949 != nil:
    section.add "prettyPrint", valid_578949
  var valid_578950 = query.getOrDefault("oauth_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "oauth_token", valid_578950
  var valid_578951 = query.getOrDefault("$.xgafv")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("1"))
  if valid_578951 != nil:
    section.add "$.xgafv", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("uploadType")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "uploadType", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("callback")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callback", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("access_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "access_token", valid_578957
  var valid_578958 = query.getOrDefault("upload_protocol")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "upload_protocol", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_AppengineAppsAuthorizedCertificatesDelete_578943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_AppengineAppsAuthorizedCertificatesDelete_578943;
          appsId: string; authorizedCertificatesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsAuthorizedCertificatesDelete
  ## Deletes the specified SSL certificate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/authorizedCertificates/12345.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(path_578961, "appsId", newJString(appsId))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(query_578962, "callback", newJString(callback))
  add(path_578961, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_578943(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_578944,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_578945,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_578986 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsAuthorizedDomainsList_578988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedDomainsList_578987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all domains the user is authorized to administer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_578989 = path.getOrDefault("appsId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "appsId", valid_578989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("pageSize")
  valid_578994 = validateParameter(valid_578994, JInt, required = false, default = nil)
  if valid_578994 != nil:
    section.add "pageSize", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("uploadType")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "uploadType", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("pageToken")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "pageToken", valid_578998
  var valid_578999 = query.getOrDefault("callback")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "callback", valid_578999
  var valid_579000 = query.getOrDefault("fields")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "fields", valid_579000
  var valid_579001 = query.getOrDefault("access_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "access_token", valid_579001
  var valid_579002 = query.getOrDefault("upload_protocol")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "upload_protocol", valid_579002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_AppengineAppsAuthorizedDomainsList_578986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_AppengineAppsAuthorizedDomainsList_578986;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsAuthorizedDomainsList
  ## Lists all domains the user is authorized to administer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(query_579006, "$.xgafv", newJString(Xgafv))
  add(query_579006, "pageSize", newJInt(pageSize))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "uploadType", newJString(uploadType))
  add(path_579005, "appsId", newJString(appsId))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(query_579006, "pageToken", newJString(pageToken))
  add(query_579006, "callback", newJString(callback))
  add(query_579006, "fields", newJString(fields))
  add(query_579006, "access_token", newJString(accessToken))
  add(query_579006, "upload_protocol", newJString(uploadProtocol))
  result = call_579004.call(path_579005, query_579006, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_578986(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_578987, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_578988, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_579028 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsDomainMappingsCreate_579030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsCreate_579029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579031 = path.getOrDefault("appsId")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "appsId", valid_579031
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   overrideStrategy: JString
  ##                   : Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   noManagedCertificate: JBool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manaually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated.
  section = newJObject()
  var valid_579032 = query.getOrDefault("key")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "key", valid_579032
  var valid_579033 = query.getOrDefault("prettyPrint")
  valid_579033 = validateParameter(valid_579033, JBool, required = false,
                                 default = newJBool(true))
  if valid_579033 != nil:
    section.add "prettyPrint", valid_579033
  var valid_579034 = query.getOrDefault("oauth_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "oauth_token", valid_579034
  var valid_579035 = query.getOrDefault("$.xgafv")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("1"))
  if valid_579035 != nil:
    section.add "$.xgafv", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("uploadType")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "uploadType", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
  var valid_579039 = query.getOrDefault("overrideStrategy")
  valid_579039 = validateParameter(valid_579039, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_579039 != nil:
    section.add "overrideStrategy", valid_579039
  var valid_579040 = query.getOrDefault("callback")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "callback", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
  var valid_579042 = query.getOrDefault("access_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "access_token", valid_579042
  var valid_579043 = query.getOrDefault("upload_protocol")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "upload_protocol", valid_579043
  var valid_579044 = query.getOrDefault("noManagedCertificate")
  valid_579044 = validateParameter(valid_579044, JBool, required = false, default = nil)
  if valid_579044 != nil:
    section.add "noManagedCertificate", valid_579044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_AppengineAppsDomainMappingsCreate_579028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_AppengineAppsDomainMappingsCreate_579028;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          overrideStrategy: string = "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          noManagedCertificate: bool = false): Recallable =
  ## appengineAppsDomainMappingsCreate
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   overrideStrategy: string
  ##                   : Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   noManagedCertificate: bool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manaually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated.
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  var body_579050 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(path_579048, "appsId", newJString(appsId))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(query_579049, "overrideStrategy", newJString(overrideStrategy))
  if body != nil:
    body_579050 = body
  add(query_579049, "callback", newJString(callback))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  add(query_579049, "noManagedCertificate", newJBool(noManagedCertificate))
  result = call_579047.call(path_579048, query_579049, nil, nil, body_579050)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_579028(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_579029, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_579030, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_579007 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsDomainMappingsList_579009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsList_579008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the domain mappings on an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579010 = path.getOrDefault("appsId")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "appsId", valid_579010
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("$.xgafv")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("1"))
  if valid_579014 != nil:
    section.add "$.xgafv", valid_579014
  var valid_579015 = query.getOrDefault("pageSize")
  valid_579015 = validateParameter(valid_579015, JInt, required = false, default = nil)
  if valid_579015 != nil:
    section.add "pageSize", valid_579015
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("uploadType")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "uploadType", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("pageToken")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "pageToken", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("access_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "access_token", valid_579022
  var valid_579023 = query.getOrDefault("upload_protocol")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "upload_protocol", valid_579023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579024: Call_AppengineAppsDomainMappingsList_579007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_579024.validator(path, query, header, formData, body)
  let scheme = call_579024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579024.url(scheme.get, call_579024.host, call_579024.base,
                         call_579024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579024, url, valid)

proc call*(call_579025: Call_AppengineAppsDomainMappingsList_579007;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsDomainMappingsList
  ## Lists the domain mappings on an application.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579026 = newJObject()
  var query_579027 = newJObject()
  add(query_579027, "key", newJString(key))
  add(query_579027, "prettyPrint", newJBool(prettyPrint))
  add(query_579027, "oauth_token", newJString(oauthToken))
  add(query_579027, "$.xgafv", newJString(Xgafv))
  add(query_579027, "pageSize", newJInt(pageSize))
  add(query_579027, "alt", newJString(alt))
  add(query_579027, "uploadType", newJString(uploadType))
  add(path_579026, "appsId", newJString(appsId))
  add(query_579027, "quotaUser", newJString(quotaUser))
  add(query_579027, "pageToken", newJString(pageToken))
  add(query_579027, "callback", newJString(callback))
  add(query_579027, "fields", newJString(fields))
  add(query_579027, "access_token", newJString(accessToken))
  add(query_579027, "upload_protocol", newJString(uploadProtocol))
  result = call_579025.call(path_579026, query_579027, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_579007(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_579008, base: "/",
    url: url_AppengineAppsDomainMappingsList_579009, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_579051 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsDomainMappingsGet_579053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsGet_579052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/domainMappings/example.com.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainMappingsId` field"
  var valid_579054 = path.getOrDefault("domainMappingsId")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "domainMappingsId", valid_579054
  var valid_579055 = path.getOrDefault("appsId")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "appsId", valid_579055
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("$.xgafv")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("1"))
  if valid_579059 != nil:
    section.add "$.xgafv", valid_579059
  var valid_579060 = query.getOrDefault("alt")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("json"))
  if valid_579060 != nil:
    section.add "alt", valid_579060
  var valid_579061 = query.getOrDefault("uploadType")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "uploadType", valid_579061
  var valid_579062 = query.getOrDefault("quotaUser")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "quotaUser", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579067: Call_AppengineAppsDomainMappingsGet_579051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_AppengineAppsDomainMappingsGet_579051;
          domainMappingsId: string; appsId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsDomainMappingsGet
  ## Gets the specified domain mapping.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/domainMappings/example.com.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(query_579070, "$.xgafv", newJString(Xgafv))
  add(path_579069, "domainMappingsId", newJString(domainMappingsId))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "uploadType", newJString(uploadType))
  add(path_579069, "appsId", newJString(appsId))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(query_579070, "callback", newJString(callback))
  add(query_579070, "fields", newJString(fields))
  add(query_579070, "access_token", newJString(accessToken))
  add(query_579070, "upload_protocol", newJString(uploadProtocol))
  result = call_579068.call(path_579069, query_579070, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_579051(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_579052, base: "/",
    url: url_AppengineAppsDomainMappingsGet_579053, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_579091 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsDomainMappingsPatch_579093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsPatch_579092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/domainMappings/example.com.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainMappingsId` field"
  var valid_579094 = path.getOrDefault("domainMappingsId")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "domainMappingsId", valid_579094
  var valid_579095 = path.getOrDefault("appsId")
  valid_579095 = validateParameter(valid_579095, JString, required = true,
                                 default = nil)
  if valid_579095 != nil:
    section.add "appsId", valid_579095
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   noManagedCertificate: JBool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated. Only applicable if ssl_settings.certificate_id is specified in the update mask.
  section = newJObject()
  var valid_579096 = query.getOrDefault("key")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "key", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("$.xgafv")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("1"))
  if valid_579099 != nil:
    section.add "$.xgafv", valid_579099
  var valid_579100 = query.getOrDefault("alt")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("json"))
  if valid_579100 != nil:
    section.add "alt", valid_579100
  var valid_579101 = query.getOrDefault("uploadType")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "uploadType", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("updateMask")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "updateMask", valid_579103
  var valid_579104 = query.getOrDefault("callback")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "callback", valid_579104
  var valid_579105 = query.getOrDefault("fields")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "fields", valid_579105
  var valid_579106 = query.getOrDefault("access_token")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "access_token", valid_579106
  var valid_579107 = query.getOrDefault("upload_protocol")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "upload_protocol", valid_579107
  var valid_579108 = query.getOrDefault("noManagedCertificate")
  valid_579108 = validateParameter(valid_579108, JBool, required = false, default = nil)
  if valid_579108 != nil:
    section.add "noManagedCertificate", valid_579108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_AppengineAppsDomainMappingsPatch_579091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_AppengineAppsDomainMappingsPatch_579091;
          domainMappingsId: string; appsId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          noManagedCertificate: bool = false): Recallable =
  ## appengineAppsDomainMappingsPatch
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/domainMappings/example.com.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   noManagedCertificate: bool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated. Only applicable if ssl_settings.certificate_id is specified in the update mask.
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  var body_579114 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(query_579113, "$.xgafv", newJString(Xgafv))
  add(path_579112, "domainMappingsId", newJString(domainMappingsId))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "uploadType", newJString(uploadType))
  add(path_579112, "appsId", newJString(appsId))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "updateMask", newJString(updateMask))
  if body != nil:
    body_579114 = body
  add(query_579113, "callback", newJString(callback))
  add(query_579113, "fields", newJString(fields))
  add(query_579113, "access_token", newJString(accessToken))
  add(query_579113, "upload_protocol", newJString(uploadProtocol))
  add(query_579113, "noManagedCertificate", newJBool(noManagedCertificate))
  result = call_579111.call(path_579112, query_579113, nil, nil, body_579114)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_579091(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_579092, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_579093, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_579071 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsDomainMappingsDelete_579073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsDelete_579072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/domainMappings/example.com.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainMappingsId` field"
  var valid_579074 = path.getOrDefault("domainMappingsId")
  valid_579074 = validateParameter(valid_579074, JString, required = true,
                                 default = nil)
  if valid_579074 != nil:
    section.add "domainMappingsId", valid_579074
  var valid_579075 = path.getOrDefault("appsId")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "appsId", valid_579075
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579076 = query.getOrDefault("key")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "key", valid_579076
  var valid_579077 = query.getOrDefault("prettyPrint")
  valid_579077 = validateParameter(valid_579077, JBool, required = false,
                                 default = newJBool(true))
  if valid_579077 != nil:
    section.add "prettyPrint", valid_579077
  var valid_579078 = query.getOrDefault("oauth_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "oauth_token", valid_579078
  var valid_579079 = query.getOrDefault("$.xgafv")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("1"))
  if valid_579079 != nil:
    section.add "$.xgafv", valid_579079
  var valid_579080 = query.getOrDefault("alt")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("json"))
  if valid_579080 != nil:
    section.add "alt", valid_579080
  var valid_579081 = query.getOrDefault("uploadType")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "uploadType", valid_579081
  var valid_579082 = query.getOrDefault("quotaUser")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "quotaUser", valid_579082
  var valid_579083 = query.getOrDefault("callback")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "callback", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  var valid_579085 = query.getOrDefault("access_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "access_token", valid_579085
  var valid_579086 = query.getOrDefault("upload_protocol")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "upload_protocol", valid_579086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579087: Call_AppengineAppsDomainMappingsDelete_579071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_579087.validator(path, query, header, formData, body)
  let scheme = call_579087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579087.url(scheme.get, call_579087.host, call_579087.base,
                         call_579087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579087, url, valid)

proc call*(call_579088: Call_AppengineAppsDomainMappingsDelete_579071;
          domainMappingsId: string; appsId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsDomainMappingsDelete
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/domainMappings/example.com.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579089 = newJObject()
  var query_579090 = newJObject()
  add(query_579090, "key", newJString(key))
  add(query_579090, "prettyPrint", newJBool(prettyPrint))
  add(query_579090, "oauth_token", newJString(oauthToken))
  add(query_579090, "$.xgafv", newJString(Xgafv))
  add(path_579089, "domainMappingsId", newJString(domainMappingsId))
  add(query_579090, "alt", newJString(alt))
  add(query_579090, "uploadType", newJString(uploadType))
  add(path_579089, "appsId", newJString(appsId))
  add(query_579090, "quotaUser", newJString(quotaUser))
  add(query_579090, "callback", newJString(callback))
  add(query_579090, "fields", newJString(fields))
  add(query_579090, "access_token", newJString(accessToken))
  add(query_579090, "upload_protocol", newJString(uploadProtocol))
  result = call_579088.call(path_579089, query_579090, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_579071(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_579072, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_579073, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_579115 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsLocationsList_579117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsList_579116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579118 = path.getOrDefault("appsId")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "appsId", valid_579118
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("$.xgafv")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("1"))
  if valid_579122 != nil:
    section.add "$.xgafv", valid_579122
  var valid_579123 = query.getOrDefault("pageSize")
  valid_579123 = validateParameter(valid_579123, JInt, required = false, default = nil)
  if valid_579123 != nil:
    section.add "pageSize", valid_579123
  var valid_579124 = query.getOrDefault("alt")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("json"))
  if valid_579124 != nil:
    section.add "alt", valid_579124
  var valid_579125 = query.getOrDefault("uploadType")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "uploadType", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("filter")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "filter", valid_579127
  var valid_579128 = query.getOrDefault("pageToken")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "pageToken", valid_579128
  var valid_579129 = query.getOrDefault("callback")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "callback", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
  var valid_579132 = query.getOrDefault("upload_protocol")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "upload_protocol", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_AppengineAppsLocationsList_579115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_AppengineAppsLocationsList_579115; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. The resource that owns the locations collection, if applicable.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "pageSize", newJInt(pageSize))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(path_579135, "appsId", newJString(appsId))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(query_579136, "filter", newJString(filter))
  add(query_579136, "pageToken", newJString(pageToken))
  add(query_579136, "callback", newJString(callback))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_579115(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_579116, base: "/",
    url: url_AppengineAppsLocationsList_579117, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_579137 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsLocationsGet_579139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "locationsId" in path, "`locationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "locationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsGet_579138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationsId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Resource name for the location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationsId` field"
  var valid_579140 = path.getOrDefault("locationsId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "locationsId", valid_579140
  var valid_579141 = path.getOrDefault("appsId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "appsId", valid_579141
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("uploadType")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "uploadType", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("callback")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "callback", valid_579149
  var valid_579150 = query.getOrDefault("fields")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "fields", valid_579150
  var valid_579151 = query.getOrDefault("access_token")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "access_token", valid_579151
  var valid_579152 = query.getOrDefault("upload_protocol")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "upload_protocol", valid_579152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579153: Call_AppengineAppsLocationsGet_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_AppengineAppsLocationsGet_579137; locationsId: string;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsLocationsGet
  ## Gets information about a location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   locationsId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Resource name for the location.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(query_579156, "$.xgafv", newJString(Xgafv))
  add(path_579155, "locationsId", newJString(locationsId))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "uploadType", newJString(uploadType))
  add(path_579155, "appsId", newJString(appsId))
  add(query_579156, "quotaUser", newJString(quotaUser))
  add(query_579156, "callback", newJString(callback))
  add(query_579156, "fields", newJString(fields))
  add(query_579156, "access_token", newJString(accessToken))
  add(query_579156, "upload_protocol", newJString(uploadProtocol))
  result = call_579154.call(path_579155, query_579156, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_579137(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_579138, base: "/",
    url: url_AppengineAppsLocationsGet_579139, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_579157 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsOperationsList_579159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsList_579158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579160 = path.getOrDefault("appsId")
  valid_579160 = validateParameter(valid_579160, JString, required = true,
                                 default = nil)
  if valid_579160 != nil:
    section.add "appsId", valid_579160
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579161 = query.getOrDefault("key")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "key", valid_579161
  var valid_579162 = query.getOrDefault("prettyPrint")
  valid_579162 = validateParameter(valid_579162, JBool, required = false,
                                 default = newJBool(true))
  if valid_579162 != nil:
    section.add "prettyPrint", valid_579162
  var valid_579163 = query.getOrDefault("oauth_token")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "oauth_token", valid_579163
  var valid_579164 = query.getOrDefault("$.xgafv")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("1"))
  if valid_579164 != nil:
    section.add "$.xgafv", valid_579164
  var valid_579165 = query.getOrDefault("pageSize")
  valid_579165 = validateParameter(valid_579165, JInt, required = false, default = nil)
  if valid_579165 != nil:
    section.add "pageSize", valid_579165
  var valid_579166 = query.getOrDefault("alt")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("json"))
  if valid_579166 != nil:
    section.add "alt", valid_579166
  var valid_579167 = query.getOrDefault("uploadType")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "uploadType", valid_579167
  var valid_579168 = query.getOrDefault("quotaUser")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "quotaUser", valid_579168
  var valid_579169 = query.getOrDefault("filter")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "filter", valid_579169
  var valid_579170 = query.getOrDefault("pageToken")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "pageToken", valid_579170
  var valid_579171 = query.getOrDefault("callback")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "callback", valid_579171
  var valid_579172 = query.getOrDefault("fields")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "fields", valid_579172
  var valid_579173 = query.getOrDefault("access_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "access_token", valid_579173
  var valid_579174 = query.getOrDefault("upload_protocol")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "upload_protocol", valid_579174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579175: Call_AppengineAppsOperationsList_579157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_579175.validator(path, query, header, formData, body)
  let scheme = call_579175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579175.url(scheme.get, call_579175.host, call_579175.base,
                         call_579175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579175, url, valid)

proc call*(call_579176: Call_AppengineAppsOperationsList_579157; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsOperationsList
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. The name of the operation's parent resource.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579177 = newJObject()
  var query_579178 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "$.xgafv", newJString(Xgafv))
  add(query_579178, "pageSize", newJInt(pageSize))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "uploadType", newJString(uploadType))
  add(path_579177, "appsId", newJString(appsId))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(query_579178, "filter", newJString(filter))
  add(query_579178, "pageToken", newJString(pageToken))
  add(query_579178, "callback", newJString(callback))
  add(query_579178, "fields", newJString(fields))
  add(query_579178, "access_token", newJString(accessToken))
  add(query_579178, "upload_protocol", newJString(uploadProtocol))
  result = call_579176.call(path_579177, query_579178, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_579157(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_579158, base: "/",
    url: url_AppengineAppsOperationsList_579159, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_579179 = ref object of OpenApiRestCall_578339
proc url_AppengineAppsOperationsGet_579181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "operationsId" in path, "`operationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsGet_579180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. The name of the operation resource.
  ##   operationsId: JString (required)
  ##               : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579182 = path.getOrDefault("appsId")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "appsId", valid_579182
  var valid_579183 = path.getOrDefault("operationsId")
  valid_579183 = validateParameter(valid_579183, JString, required = true,
                                 default = nil)
  if valid_579183 != nil:
    section.add "operationsId", valid_579183
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579184 = query.getOrDefault("key")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "key", valid_579184
  var valid_579185 = query.getOrDefault("prettyPrint")
  valid_579185 = validateParameter(valid_579185, JBool, required = false,
                                 default = newJBool(true))
  if valid_579185 != nil:
    section.add "prettyPrint", valid_579185
  var valid_579186 = query.getOrDefault("oauth_token")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "oauth_token", valid_579186
  var valid_579187 = query.getOrDefault("$.xgafv")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = newJString("1"))
  if valid_579187 != nil:
    section.add "$.xgafv", valid_579187
  var valid_579188 = query.getOrDefault("alt")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("json"))
  if valid_579188 != nil:
    section.add "alt", valid_579188
  var valid_579189 = query.getOrDefault("uploadType")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "uploadType", valid_579189
  var valid_579190 = query.getOrDefault("quotaUser")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "quotaUser", valid_579190
  var valid_579191 = query.getOrDefault("callback")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "callback", valid_579191
  var valid_579192 = query.getOrDefault("fields")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "fields", valid_579192
  var valid_579193 = query.getOrDefault("access_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "access_token", valid_579193
  var valid_579194 = query.getOrDefault("upload_protocol")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "upload_protocol", valid_579194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579195: Call_AppengineAppsOperationsGet_579179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_579195.validator(path, query, header, formData, body)
  let scheme = call_579195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579195.url(scheme.get, call_579195.host, call_579195.base,
                         call_579195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579195, url, valid)

proc call*(call_579196: Call_AppengineAppsOperationsGet_579179; appsId: string;
          operationsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsOperationsGet
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. The name of the operation resource.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   operationsId: string (required)
  ##               : Part of `name`. See documentation of `appsId`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579197 = newJObject()
  var query_579198 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "$.xgafv", newJString(Xgafv))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "uploadType", newJString(uploadType))
  add(path_579197, "appsId", newJString(appsId))
  add(query_579198, "quotaUser", newJString(quotaUser))
  add(path_579197, "operationsId", newJString(operationsId))
  add(query_579198, "callback", newJString(callback))
  add(query_579198, "fields", newJString(fields))
  add(query_579198, "access_token", newJString(accessToken))
  add(query_579198, "upload_protocol", newJString(uploadProtocol))
  result = call_579196.call(path_579197, query_579198, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_579179(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_579180, base: "/",
    url: url_AppengineAppsOperationsGet_579181, schemes: {Scheme.Https})
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
