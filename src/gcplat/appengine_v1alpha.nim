
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "appengine"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppengineAppsAuthorizedCertificatesCreate_597968 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedCertificatesCreate_597970(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesCreate_597969(path: JsonNode;
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
  var valid_597971 = path.getOrDefault("appsId")
  valid_597971 = validateParameter(valid_597971, JString, required = true,
                                 default = nil)
  if valid_597971 != nil:
    section.add "appsId", valid_597971
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597972 = query.getOrDefault("upload_protocol")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "upload_protocol", valid_597972
  var valid_597973 = query.getOrDefault("fields")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "fields", valid_597973
  var valid_597974 = query.getOrDefault("quotaUser")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "quotaUser", valid_597974
  var valid_597975 = query.getOrDefault("alt")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = newJString("json"))
  if valid_597975 != nil:
    section.add "alt", valid_597975
  var valid_597976 = query.getOrDefault("oauth_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "oauth_token", valid_597976
  var valid_597977 = query.getOrDefault("callback")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "callback", valid_597977
  var valid_597978 = query.getOrDefault("access_token")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "access_token", valid_597978
  var valid_597979 = query.getOrDefault("uploadType")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "uploadType", valid_597979
  var valid_597980 = query.getOrDefault("key")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "key", valid_597980
  var valid_597981 = query.getOrDefault("$.xgafv")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("1"))
  if valid_597981 != nil:
    section.add "$.xgafv", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(true))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
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

proc call*(call_597984: Call_AppengineAppsAuthorizedCertificatesCreate_597968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_AppengineAppsAuthorizedCertificatesCreate_597968;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsAuthorizedCertificatesCreate
  ## Uploads the specified SSL certificate.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  var body_597988 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(query_597987, "key", newJString(key))
  add(path_597986, "appsId", newJString(appsId))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597988 = body
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(path_597986, query_597987, nil, nil, body_597988)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_597968(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_597969,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_597970,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_597677 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedCertificatesList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesList_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("appsId")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "appsId", valid_597805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Controls the set of fields returned in the LIST response.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("pageToken")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "pageToken", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("view")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_597823 != nil:
    section.add "view", valid_597823
  var valid_597824 = query.getOrDefault("alt")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = newJString("json"))
  if valid_597824 != nil:
    section.add "alt", valid_597824
  var valid_597825 = query.getOrDefault("oauth_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "oauth_token", valid_597825
  var valid_597826 = query.getOrDefault("callback")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "callback", valid_597826
  var valid_597827 = query.getOrDefault("access_token")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "access_token", valid_597827
  var valid_597828 = query.getOrDefault("uploadType")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "uploadType", valid_597828
  var valid_597829 = query.getOrDefault("key")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = nil)
  if valid_597829 != nil:
    section.add "key", valid_597829
  var valid_597830 = query.getOrDefault("$.xgafv")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = newJString("1"))
  if valid_597830 != nil:
    section.add "$.xgafv", valid_597830
  var valid_597831 = query.getOrDefault("pageSize")
  valid_597831 = validateParameter(valid_597831, JInt, required = false, default = nil)
  if valid_597831 != nil:
    section.add "pageSize", valid_597831
  var valid_597832 = query.getOrDefault("prettyPrint")
  valid_597832 = validateParameter(valid_597832, JBool, required = false,
                                 default = newJBool(true))
  if valid_597832 != nil:
    section.add "prettyPrint", valid_597832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597855: Call_AppengineAppsAuthorizedCertificatesList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_597855.validator(path, query, header, formData, body)
  let scheme = call_597855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597855.url(scheme.get, call_597855.host, call_597855.base,
                         call_597855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597855, url, valid)

proc call*(call_597926: Call_AppengineAppsAuthorizedCertificatesList_597677;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "BASIC_CERTIFICATE"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsAuthorizedCertificatesList
  ## Lists all SSL certificates the user is authorized to administer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Controls the set of fields returned in the LIST response.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597927 = newJObject()
  var query_597929 = newJObject()
  add(query_597929, "upload_protocol", newJString(uploadProtocol))
  add(query_597929, "fields", newJString(fields))
  add(query_597929, "pageToken", newJString(pageToken))
  add(query_597929, "quotaUser", newJString(quotaUser))
  add(query_597929, "view", newJString(view))
  add(query_597929, "alt", newJString(alt))
  add(query_597929, "oauth_token", newJString(oauthToken))
  add(query_597929, "callback", newJString(callback))
  add(query_597929, "access_token", newJString(accessToken))
  add(query_597929, "uploadType", newJString(uploadType))
  add(query_597929, "key", newJString(key))
  add(path_597927, "appsId", newJString(appsId))
  add(query_597929, "$.xgafv", newJString(Xgafv))
  add(query_597929, "pageSize", newJInt(pageSize))
  add(query_597929, "prettyPrint", newJBool(prettyPrint))
  result = call_597926.call(path_597927, query_597929, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_597677(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_597678, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_597679,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_597989 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedCertificatesGet_597991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesGet_597990(path: JsonNode;
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
  var valid_597992 = path.getOrDefault("appsId")
  valid_597992 = validateParameter(valid_597992, JString, required = true,
                                 default = nil)
  if valid_597992 != nil:
    section.add "appsId", valid_597992
  var valid_597993 = path.getOrDefault("authorizedCertificatesId")
  valid_597993 = validateParameter(valid_597993, JString, required = true,
                                 default = nil)
  if valid_597993 != nil:
    section.add "authorizedCertificatesId", valid_597993
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Controls the set of fields returned in the GET response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597994 = query.getOrDefault("upload_protocol")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "upload_protocol", valid_597994
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("view")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_597996 != nil:
    section.add "view", valid_597996
  var valid_597997 = query.getOrDefault("quotaUser")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "quotaUser", valid_597997
  var valid_597998 = query.getOrDefault("alt")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("json"))
  if valid_597998 != nil:
    section.add "alt", valid_597998
  var valid_597999 = query.getOrDefault("oauth_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "oauth_token", valid_597999
  var valid_598000 = query.getOrDefault("callback")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "callback", valid_598000
  var valid_598001 = query.getOrDefault("access_token")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "access_token", valid_598001
  var valid_598002 = query.getOrDefault("uploadType")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "uploadType", valid_598002
  var valid_598003 = query.getOrDefault("key")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "key", valid_598003
  var valid_598004 = query.getOrDefault("$.xgafv")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = newJString("1"))
  if valid_598004 != nil:
    section.add "$.xgafv", valid_598004
  var valid_598005 = query.getOrDefault("prettyPrint")
  valid_598005 = validateParameter(valid_598005, JBool, required = false,
                                 default = newJBool(true))
  if valid_598005 != nil:
    section.add "prettyPrint", valid_598005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598006: Call_AppengineAppsAuthorizedCertificatesGet_597989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_598006.validator(path, query, header, formData, body)
  let scheme = call_598006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598006.url(scheme.get, call_598006.host, call_598006.base,
                         call_598006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598006, url, valid)

proc call*(call_598007: Call_AppengineAppsAuthorizedCertificatesGet_597989;
          appsId: string; authorizedCertificatesId: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "BASIC_CERTIFICATE"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsAuthorizedCertificatesGet
  ## Gets the specified SSL certificate.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Controls the set of fields returned in the GET response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/authorizedCertificates/12345.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  var path_598008 = newJObject()
  var query_598009 = newJObject()
  add(query_598009, "upload_protocol", newJString(uploadProtocol))
  add(query_598009, "fields", newJString(fields))
  add(query_598009, "view", newJString(view))
  add(query_598009, "quotaUser", newJString(quotaUser))
  add(query_598009, "alt", newJString(alt))
  add(query_598009, "oauth_token", newJString(oauthToken))
  add(query_598009, "callback", newJString(callback))
  add(query_598009, "access_token", newJString(accessToken))
  add(query_598009, "uploadType", newJString(uploadType))
  add(query_598009, "key", newJString(key))
  add(path_598008, "appsId", newJString(appsId))
  add(query_598009, "$.xgafv", newJString(Xgafv))
  add(query_598009, "prettyPrint", newJBool(prettyPrint))
  add(path_598008, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598007.call(path_598008, query_598009, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_597989(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_597990, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_597991,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_598030 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedCertificatesPatch_598032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesPatch_598031(path: JsonNode;
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
  var valid_598033 = path.getOrDefault("appsId")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "appsId", valid_598033
  var valid_598034 = path.getOrDefault("authorizedCertificatesId")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "authorizedCertificatesId", valid_598034
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated. Updates are only supported on the certificate_raw_data and display_name fields.
  section = newJObject()
  var valid_598035 = query.getOrDefault("upload_protocol")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "upload_protocol", valid_598035
  var valid_598036 = query.getOrDefault("fields")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "fields", valid_598036
  var valid_598037 = query.getOrDefault("quotaUser")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "quotaUser", valid_598037
  var valid_598038 = query.getOrDefault("alt")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("json"))
  if valid_598038 != nil:
    section.add "alt", valid_598038
  var valid_598039 = query.getOrDefault("oauth_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "oauth_token", valid_598039
  var valid_598040 = query.getOrDefault("callback")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "callback", valid_598040
  var valid_598041 = query.getOrDefault("access_token")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "access_token", valid_598041
  var valid_598042 = query.getOrDefault("uploadType")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "uploadType", valid_598042
  var valid_598043 = query.getOrDefault("key")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "key", valid_598043
  var valid_598044 = query.getOrDefault("$.xgafv")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = newJString("1"))
  if valid_598044 != nil:
    section.add "$.xgafv", valid_598044
  var valid_598045 = query.getOrDefault("prettyPrint")
  valid_598045 = validateParameter(valid_598045, JBool, required = false,
                                 default = newJBool(true))
  if valid_598045 != nil:
    section.add "prettyPrint", valid_598045
  var valid_598046 = query.getOrDefault("updateMask")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "updateMask", valid_598046
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

proc call*(call_598048: Call_AppengineAppsAuthorizedCertificatesPatch_598030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_598048.validator(path, query, header, formData, body)
  let scheme = call_598048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598048.url(scheme.get, call_598048.host, call_598048.base,
                         call_598048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598048, url, valid)

proc call*(call_598049: Call_AppengineAppsAuthorizedCertificatesPatch_598030;
          appsId: string; authorizedCertificatesId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## appengineAppsAuthorizedCertificatesPatch
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/authorizedCertificates/12345.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated. Updates are only supported on the certificate_raw_data and display_name fields.
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  var path_598050 = newJObject()
  var query_598051 = newJObject()
  var body_598052 = newJObject()
  add(query_598051, "upload_protocol", newJString(uploadProtocol))
  add(query_598051, "fields", newJString(fields))
  add(query_598051, "quotaUser", newJString(quotaUser))
  add(query_598051, "alt", newJString(alt))
  add(query_598051, "oauth_token", newJString(oauthToken))
  add(query_598051, "callback", newJString(callback))
  add(query_598051, "access_token", newJString(accessToken))
  add(query_598051, "uploadType", newJString(uploadType))
  add(query_598051, "key", newJString(key))
  add(path_598050, "appsId", newJString(appsId))
  add(query_598051, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598052 = body
  add(query_598051, "prettyPrint", newJBool(prettyPrint))
  add(query_598051, "updateMask", newJString(updateMask))
  add(path_598050, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598049.call(path_598050, query_598051, nil, nil, body_598052)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_598030(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_598031,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_598032,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_598010 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedCertificatesDelete_598012(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesDelete_598011(path: JsonNode;
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
  var valid_598013 = path.getOrDefault("appsId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "appsId", valid_598013
  var valid_598014 = path.getOrDefault("authorizedCertificatesId")
  valid_598014 = validateParameter(valid_598014, JString, required = true,
                                 default = nil)
  if valid_598014 != nil:
    section.add "authorizedCertificatesId", valid_598014
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598015 = query.getOrDefault("upload_protocol")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "upload_protocol", valid_598015
  var valid_598016 = query.getOrDefault("fields")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "fields", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  var valid_598019 = query.getOrDefault("oauth_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "oauth_token", valid_598019
  var valid_598020 = query.getOrDefault("callback")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "callback", valid_598020
  var valid_598021 = query.getOrDefault("access_token")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "access_token", valid_598021
  var valid_598022 = query.getOrDefault("uploadType")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "uploadType", valid_598022
  var valid_598023 = query.getOrDefault("key")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "key", valid_598023
  var valid_598024 = query.getOrDefault("$.xgafv")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = newJString("1"))
  if valid_598024 != nil:
    section.add "$.xgafv", valid_598024
  var valid_598025 = query.getOrDefault("prettyPrint")
  valid_598025 = validateParameter(valid_598025, JBool, required = false,
                                 default = newJBool(true))
  if valid_598025 != nil:
    section.add "prettyPrint", valid_598025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598026: Call_AppengineAppsAuthorizedCertificatesDelete_598010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_598026.validator(path, query, header, formData, body)
  let scheme = call_598026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598026.url(scheme.get, call_598026.host, call_598026.base,
                         call_598026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598026, url, valid)

proc call*(call_598027: Call_AppengineAppsAuthorizedCertificatesDelete_598010;
          appsId: string; authorizedCertificatesId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsAuthorizedCertificatesDelete
  ## Deletes the specified SSL certificate.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/authorizedCertificates/12345.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   authorizedCertificatesId: string (required)
  ##                           : Part of `name`. See documentation of `appsId`.
  var path_598028 = newJObject()
  var query_598029 = newJObject()
  add(query_598029, "upload_protocol", newJString(uploadProtocol))
  add(query_598029, "fields", newJString(fields))
  add(query_598029, "quotaUser", newJString(quotaUser))
  add(query_598029, "alt", newJString(alt))
  add(query_598029, "oauth_token", newJString(oauthToken))
  add(query_598029, "callback", newJString(callback))
  add(query_598029, "access_token", newJString(accessToken))
  add(query_598029, "uploadType", newJString(uploadType))
  add(query_598029, "key", newJString(key))
  add(path_598028, "appsId", newJString(appsId))
  add(query_598029, "$.xgafv", newJString(Xgafv))
  add(query_598029, "prettyPrint", newJBool(prettyPrint))
  add(path_598028, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598027.call(path_598028, query_598029, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_598010(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_598011,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_598012,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_598053 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsAuthorizedDomainsList_598055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedDomainsList_598054(path: JsonNode;
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
  var valid_598056 = path.getOrDefault("appsId")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "appsId", valid_598056
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598057 = query.getOrDefault("upload_protocol")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "upload_protocol", valid_598057
  var valid_598058 = query.getOrDefault("fields")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "fields", valid_598058
  var valid_598059 = query.getOrDefault("pageToken")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "pageToken", valid_598059
  var valid_598060 = query.getOrDefault("quotaUser")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "quotaUser", valid_598060
  var valid_598061 = query.getOrDefault("alt")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = newJString("json"))
  if valid_598061 != nil:
    section.add "alt", valid_598061
  var valid_598062 = query.getOrDefault("oauth_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "oauth_token", valid_598062
  var valid_598063 = query.getOrDefault("callback")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "callback", valid_598063
  var valid_598064 = query.getOrDefault("access_token")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "access_token", valid_598064
  var valid_598065 = query.getOrDefault("uploadType")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "uploadType", valid_598065
  var valid_598066 = query.getOrDefault("key")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "key", valid_598066
  var valid_598067 = query.getOrDefault("$.xgafv")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = newJString("1"))
  if valid_598067 != nil:
    section.add "$.xgafv", valid_598067
  var valid_598068 = query.getOrDefault("pageSize")
  valid_598068 = validateParameter(valid_598068, JInt, required = false, default = nil)
  if valid_598068 != nil:
    section.add "pageSize", valid_598068
  var valid_598069 = query.getOrDefault("prettyPrint")
  valid_598069 = validateParameter(valid_598069, JBool, required = false,
                                 default = newJBool(true))
  if valid_598069 != nil:
    section.add "prettyPrint", valid_598069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598070: Call_AppengineAppsAuthorizedDomainsList_598053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_598070.validator(path, query, header, formData, body)
  let scheme = call_598070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598070.url(scheme.get, call_598070.host, call_598070.base,
                         call_598070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598070, url, valid)

proc call*(call_598071: Call_AppengineAppsAuthorizedDomainsList_598053;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsAuthorizedDomainsList
  ## Lists all domains the user is authorized to administer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598072 = newJObject()
  var query_598073 = newJObject()
  add(query_598073, "upload_protocol", newJString(uploadProtocol))
  add(query_598073, "fields", newJString(fields))
  add(query_598073, "pageToken", newJString(pageToken))
  add(query_598073, "quotaUser", newJString(quotaUser))
  add(query_598073, "alt", newJString(alt))
  add(query_598073, "oauth_token", newJString(oauthToken))
  add(query_598073, "callback", newJString(callback))
  add(query_598073, "access_token", newJString(accessToken))
  add(query_598073, "uploadType", newJString(uploadType))
  add(query_598073, "key", newJString(key))
  add(path_598072, "appsId", newJString(appsId))
  add(query_598073, "$.xgafv", newJString(Xgafv))
  add(query_598073, "pageSize", newJInt(pageSize))
  add(query_598073, "prettyPrint", newJBool(prettyPrint))
  result = call_598071.call(path_598072, query_598073, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_598053(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_598054, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_598055, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_598095 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsDomainMappingsCreate_598097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsCreate_598096(path: JsonNode;
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
  var valid_598098 = path.getOrDefault("appsId")
  valid_598098 = validateParameter(valid_598098, JString, required = true,
                                 default = nil)
  if valid_598098 != nil:
    section.add "appsId", valid_598098
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   noManagedCertificate: JBool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manaually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   overrideStrategy: JString
  ##                   : Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected.
  section = newJObject()
  var valid_598099 = query.getOrDefault("upload_protocol")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "upload_protocol", valid_598099
  var valid_598100 = query.getOrDefault("fields")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "fields", valid_598100
  var valid_598101 = query.getOrDefault("quotaUser")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "quotaUser", valid_598101
  var valid_598102 = query.getOrDefault("alt")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("json"))
  if valid_598102 != nil:
    section.add "alt", valid_598102
  var valid_598103 = query.getOrDefault("oauth_token")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "oauth_token", valid_598103
  var valid_598104 = query.getOrDefault("callback")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "callback", valid_598104
  var valid_598105 = query.getOrDefault("access_token")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "access_token", valid_598105
  var valid_598106 = query.getOrDefault("uploadType")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "uploadType", valid_598106
  var valid_598107 = query.getOrDefault("noManagedCertificate")
  valid_598107 = validateParameter(valid_598107, JBool, required = false, default = nil)
  if valid_598107 != nil:
    section.add "noManagedCertificate", valid_598107
  var valid_598108 = query.getOrDefault("key")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "key", valid_598108
  var valid_598109 = query.getOrDefault("$.xgafv")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = newJString("1"))
  if valid_598109 != nil:
    section.add "$.xgafv", valid_598109
  var valid_598110 = query.getOrDefault("prettyPrint")
  valid_598110 = validateParameter(valid_598110, JBool, required = false,
                                 default = newJBool(true))
  if valid_598110 != nil:
    section.add "prettyPrint", valid_598110
  var valid_598111 = query.getOrDefault("overrideStrategy")
  valid_598111 = validateParameter(valid_598111, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_598111 != nil:
    section.add "overrideStrategy", valid_598111
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

proc call*(call_598113: Call_AppengineAppsDomainMappingsCreate_598095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_AppengineAppsDomainMappingsCreate_598095;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          noManagedCertificate: bool = false; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true;
          overrideStrategy: string = "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"): Recallable =
  ## appengineAppsDomainMappingsCreate
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   noManagedCertificate: bool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manaually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   overrideStrategy: string
  ##                   : Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected.
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  var body_598117 = newJObject()
  add(query_598116, "upload_protocol", newJString(uploadProtocol))
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "callback", newJString(callback))
  add(query_598116, "access_token", newJString(accessToken))
  add(query_598116, "uploadType", newJString(uploadType))
  add(query_598116, "noManagedCertificate", newJBool(noManagedCertificate))
  add(query_598116, "key", newJString(key))
  add(path_598115, "appsId", newJString(appsId))
  add(query_598116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598117 = body
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  add(query_598116, "overrideStrategy", newJString(overrideStrategy))
  result = call_598114.call(path_598115, query_598116, nil, nil, body_598117)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_598095(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_598096, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_598097, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_598074 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsDomainMappingsList_598076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsList_598075(path: JsonNode;
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
  var valid_598077 = path.getOrDefault("appsId")
  valid_598077 = validateParameter(valid_598077, JString, required = true,
                                 default = nil)
  if valid_598077 != nil:
    section.add "appsId", valid_598077
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598078 = query.getOrDefault("upload_protocol")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "upload_protocol", valid_598078
  var valid_598079 = query.getOrDefault("fields")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "fields", valid_598079
  var valid_598080 = query.getOrDefault("pageToken")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "pageToken", valid_598080
  var valid_598081 = query.getOrDefault("quotaUser")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "quotaUser", valid_598081
  var valid_598082 = query.getOrDefault("alt")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = newJString("json"))
  if valid_598082 != nil:
    section.add "alt", valid_598082
  var valid_598083 = query.getOrDefault("oauth_token")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "oauth_token", valid_598083
  var valid_598084 = query.getOrDefault("callback")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "callback", valid_598084
  var valid_598085 = query.getOrDefault("access_token")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "access_token", valid_598085
  var valid_598086 = query.getOrDefault("uploadType")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "uploadType", valid_598086
  var valid_598087 = query.getOrDefault("key")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "key", valid_598087
  var valid_598088 = query.getOrDefault("$.xgafv")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = newJString("1"))
  if valid_598088 != nil:
    section.add "$.xgafv", valid_598088
  var valid_598089 = query.getOrDefault("pageSize")
  valid_598089 = validateParameter(valid_598089, JInt, required = false, default = nil)
  if valid_598089 != nil:
    section.add "pageSize", valid_598089
  var valid_598090 = query.getOrDefault("prettyPrint")
  valid_598090 = validateParameter(valid_598090, JBool, required = false,
                                 default = newJBool(true))
  if valid_598090 != nil:
    section.add "prettyPrint", valid_598090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598091: Call_AppengineAppsDomainMappingsList_598074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_598091.validator(path, query, header, formData, body)
  let scheme = call_598091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598091.url(scheme.get, call_598091.host, call_598091.base,
                         call_598091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598091, url, valid)

proc call*(call_598092: Call_AppengineAppsDomainMappingsList_598074;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsDomainMappingsList
  ## Lists the domain mappings on an application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598093 = newJObject()
  var query_598094 = newJObject()
  add(query_598094, "upload_protocol", newJString(uploadProtocol))
  add(query_598094, "fields", newJString(fields))
  add(query_598094, "pageToken", newJString(pageToken))
  add(query_598094, "quotaUser", newJString(quotaUser))
  add(query_598094, "alt", newJString(alt))
  add(query_598094, "oauth_token", newJString(oauthToken))
  add(query_598094, "callback", newJString(callback))
  add(query_598094, "access_token", newJString(accessToken))
  add(query_598094, "uploadType", newJString(uploadType))
  add(query_598094, "key", newJString(key))
  add(path_598093, "appsId", newJString(appsId))
  add(query_598094, "$.xgafv", newJString(Xgafv))
  add(query_598094, "pageSize", newJInt(pageSize))
  add(query_598094, "prettyPrint", newJBool(prettyPrint))
  result = call_598092.call(path_598093, query_598094, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_598074(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_598075, base: "/",
    url: url_AppengineAppsDomainMappingsList_598076, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_598118 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsDomainMappingsGet_598120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsGet_598119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/domainMappings/example.com.
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598121 = path.getOrDefault("appsId")
  valid_598121 = validateParameter(valid_598121, JString, required = true,
                                 default = nil)
  if valid_598121 != nil:
    section.add "appsId", valid_598121
  var valid_598122 = path.getOrDefault("domainMappingsId")
  valid_598122 = validateParameter(valid_598122, JString, required = true,
                                 default = nil)
  if valid_598122 != nil:
    section.add "domainMappingsId", valid_598122
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598123 = query.getOrDefault("upload_protocol")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "upload_protocol", valid_598123
  var valid_598124 = query.getOrDefault("fields")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "fields", valid_598124
  var valid_598125 = query.getOrDefault("quotaUser")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "quotaUser", valid_598125
  var valid_598126 = query.getOrDefault("alt")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("json"))
  if valid_598126 != nil:
    section.add "alt", valid_598126
  var valid_598127 = query.getOrDefault("oauth_token")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "oauth_token", valid_598127
  var valid_598128 = query.getOrDefault("callback")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "callback", valid_598128
  var valid_598129 = query.getOrDefault("access_token")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "access_token", valid_598129
  var valid_598130 = query.getOrDefault("uploadType")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "uploadType", valid_598130
  var valid_598131 = query.getOrDefault("key")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "key", valid_598131
  var valid_598132 = query.getOrDefault("$.xgafv")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("1"))
  if valid_598132 != nil:
    section.add "$.xgafv", valid_598132
  var valid_598133 = query.getOrDefault("prettyPrint")
  valid_598133 = validateParameter(valid_598133, JBool, required = false,
                                 default = newJBool(true))
  if valid_598133 != nil:
    section.add "prettyPrint", valid_598133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598134: Call_AppengineAppsDomainMappingsGet_598118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_598134.validator(path, query, header, formData, body)
  let scheme = call_598134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598134.url(scheme.get, call_598134.host, call_598134.base,
                         call_598134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598134, url, valid)

proc call*(call_598135: Call_AppengineAppsDomainMappingsGet_598118; appsId: string;
          domainMappingsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsDomainMappingsGet
  ## Gets the specified domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/domainMappings/example.com.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  var path_598136 = newJObject()
  var query_598137 = newJObject()
  add(query_598137, "upload_protocol", newJString(uploadProtocol))
  add(query_598137, "fields", newJString(fields))
  add(query_598137, "quotaUser", newJString(quotaUser))
  add(query_598137, "alt", newJString(alt))
  add(query_598137, "oauth_token", newJString(oauthToken))
  add(query_598137, "callback", newJString(callback))
  add(query_598137, "access_token", newJString(accessToken))
  add(query_598137, "uploadType", newJString(uploadType))
  add(query_598137, "key", newJString(key))
  add(path_598136, "appsId", newJString(appsId))
  add(query_598137, "$.xgafv", newJString(Xgafv))
  add(query_598137, "prettyPrint", newJBool(prettyPrint))
  add(path_598136, "domainMappingsId", newJString(domainMappingsId))
  result = call_598135.call(path_598136, query_598137, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_598118(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_598119, base: "/",
    url: url_AppengineAppsDomainMappingsGet_598120, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_598158 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsDomainMappingsPatch_598160(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsPatch_598159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/domainMappings/example.com.
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598161 = path.getOrDefault("appsId")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "appsId", valid_598161
  var valid_598162 = path.getOrDefault("domainMappingsId")
  valid_598162 = validateParameter(valid_598162, JString, required = true,
                                 default = nil)
  if valid_598162 != nil:
    section.add "domainMappingsId", valid_598162
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   noManagedCertificate: JBool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated. Only applicable if ssl_settings.certificate_id is specified in the update mask.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_598163 = query.getOrDefault("upload_protocol")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "upload_protocol", valid_598163
  var valid_598164 = query.getOrDefault("fields")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "fields", valid_598164
  var valid_598165 = query.getOrDefault("quotaUser")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "quotaUser", valid_598165
  var valid_598166 = query.getOrDefault("alt")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = newJString("json"))
  if valid_598166 != nil:
    section.add "alt", valid_598166
  var valid_598167 = query.getOrDefault("oauth_token")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "oauth_token", valid_598167
  var valid_598168 = query.getOrDefault("callback")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "callback", valid_598168
  var valid_598169 = query.getOrDefault("access_token")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "access_token", valid_598169
  var valid_598170 = query.getOrDefault("uploadType")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "uploadType", valid_598170
  var valid_598171 = query.getOrDefault("noManagedCertificate")
  valid_598171 = validateParameter(valid_598171, JBool, required = false, default = nil)
  if valid_598171 != nil:
    section.add "noManagedCertificate", valid_598171
  var valid_598172 = query.getOrDefault("key")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "key", valid_598172
  var valid_598173 = query.getOrDefault("$.xgafv")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = newJString("1"))
  if valid_598173 != nil:
    section.add "$.xgafv", valid_598173
  var valid_598174 = query.getOrDefault("prettyPrint")
  valid_598174 = validateParameter(valid_598174, JBool, required = false,
                                 default = newJBool(true))
  if valid_598174 != nil:
    section.add "prettyPrint", valid_598174
  var valid_598175 = query.getOrDefault("updateMask")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "updateMask", valid_598175
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

proc call*(call_598177: Call_AppengineAppsDomainMappingsPatch_598158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_598177.validator(path, query, header, formData, body)
  let scheme = call_598177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598177.url(scheme.get, call_598177.host, call_598177.base,
                         call_598177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598177, url, valid)

proc call*(call_598178: Call_AppengineAppsDomainMappingsPatch_598158;
          appsId: string; domainMappingsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; noManagedCertificate: bool = false; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## appengineAppsDomainMappingsPatch
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   noManagedCertificate: bool
  ##                       : Whether a managed certificate should be provided by App Engine. If true, a certificate ID must be manually set in the DomainMapping resource to configure SSL for this domain. If false, a managed certificate will be provisioned and a certificate ID will be automatically populated. Only applicable if ssl_settings.certificate_id is specified in the update mask.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/domainMappings/example.com.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_598179 = newJObject()
  var query_598180 = newJObject()
  var body_598181 = newJObject()
  add(query_598180, "upload_protocol", newJString(uploadProtocol))
  add(query_598180, "fields", newJString(fields))
  add(query_598180, "quotaUser", newJString(quotaUser))
  add(query_598180, "alt", newJString(alt))
  add(query_598180, "oauth_token", newJString(oauthToken))
  add(query_598180, "callback", newJString(callback))
  add(query_598180, "access_token", newJString(accessToken))
  add(query_598180, "uploadType", newJString(uploadType))
  add(query_598180, "noManagedCertificate", newJBool(noManagedCertificate))
  add(query_598180, "key", newJString(key))
  add(path_598179, "appsId", newJString(appsId))
  add(query_598180, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598181 = body
  add(query_598180, "prettyPrint", newJBool(prettyPrint))
  add(path_598179, "domainMappingsId", newJString(domainMappingsId))
  add(query_598180, "updateMask", newJString(updateMask))
  result = call_598178.call(path_598179, query_598180, nil, nil, body_598181)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_598158(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_598159, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_598160, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_598138 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsDomainMappingsDelete_598140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsDelete_598139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/domainMappings/example.com.
  ##   domainMappingsId: JString (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598141 = path.getOrDefault("appsId")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "appsId", valid_598141
  var valid_598142 = path.getOrDefault("domainMappingsId")
  valid_598142 = validateParameter(valid_598142, JString, required = true,
                                 default = nil)
  if valid_598142 != nil:
    section.add "domainMappingsId", valid_598142
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598143 = query.getOrDefault("upload_protocol")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "upload_protocol", valid_598143
  var valid_598144 = query.getOrDefault("fields")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "fields", valid_598144
  var valid_598145 = query.getOrDefault("quotaUser")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "quotaUser", valid_598145
  var valid_598146 = query.getOrDefault("alt")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = newJString("json"))
  if valid_598146 != nil:
    section.add "alt", valid_598146
  var valid_598147 = query.getOrDefault("oauth_token")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "oauth_token", valid_598147
  var valid_598148 = query.getOrDefault("callback")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "callback", valid_598148
  var valid_598149 = query.getOrDefault("access_token")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "access_token", valid_598149
  var valid_598150 = query.getOrDefault("uploadType")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "uploadType", valid_598150
  var valid_598151 = query.getOrDefault("key")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "key", valid_598151
  var valid_598152 = query.getOrDefault("$.xgafv")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = newJString("1"))
  if valid_598152 != nil:
    section.add "$.xgafv", valid_598152
  var valid_598153 = query.getOrDefault("prettyPrint")
  valid_598153 = validateParameter(valid_598153, JBool, required = false,
                                 default = newJBool(true))
  if valid_598153 != nil:
    section.add "prettyPrint", valid_598153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598154: Call_AppengineAppsDomainMappingsDelete_598138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_598154.validator(path, query, header, formData, body)
  let scheme = call_598154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598154.url(scheme.get, call_598154.host, call_598154.base,
                         call_598154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598154, url, valid)

proc call*(call_598155: Call_AppengineAppsDomainMappingsDelete_598138;
          appsId: string; domainMappingsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## appengineAppsDomainMappingsDelete
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to delete. Example: apps/myapp/domainMappings/example.com.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   domainMappingsId: string (required)
  ##                   : Part of `name`. See documentation of `appsId`.
  var path_598156 = newJObject()
  var query_598157 = newJObject()
  add(query_598157, "upload_protocol", newJString(uploadProtocol))
  add(query_598157, "fields", newJString(fields))
  add(query_598157, "quotaUser", newJString(quotaUser))
  add(query_598157, "alt", newJString(alt))
  add(query_598157, "oauth_token", newJString(oauthToken))
  add(query_598157, "callback", newJString(callback))
  add(query_598157, "access_token", newJString(accessToken))
  add(query_598157, "uploadType", newJString(uploadType))
  add(query_598157, "key", newJString(key))
  add(path_598156, "appsId", newJString(appsId))
  add(query_598157, "$.xgafv", newJString(Xgafv))
  add(query_598157, "prettyPrint", newJBool(prettyPrint))
  add(path_598156, "domainMappingsId", newJString(domainMappingsId))
  result = call_598155.call(path_598156, query_598157, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_598138(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_598139, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_598140, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_598182 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsLocationsList_598184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsLocationsList_598183(path: JsonNode; query: JsonNode;
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
  var valid_598185 = path.getOrDefault("appsId")
  valid_598185 = validateParameter(valid_598185, JString, required = true,
                                 default = nil)
  if valid_598185 != nil:
    section.add "appsId", valid_598185
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_598186 = query.getOrDefault("upload_protocol")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "upload_protocol", valid_598186
  var valid_598187 = query.getOrDefault("fields")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "fields", valid_598187
  var valid_598188 = query.getOrDefault("pageToken")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "pageToken", valid_598188
  var valid_598189 = query.getOrDefault("quotaUser")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "quotaUser", valid_598189
  var valid_598190 = query.getOrDefault("alt")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = newJString("json"))
  if valid_598190 != nil:
    section.add "alt", valid_598190
  var valid_598191 = query.getOrDefault("oauth_token")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "oauth_token", valid_598191
  var valid_598192 = query.getOrDefault("callback")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "callback", valid_598192
  var valid_598193 = query.getOrDefault("access_token")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "access_token", valid_598193
  var valid_598194 = query.getOrDefault("uploadType")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "uploadType", valid_598194
  var valid_598195 = query.getOrDefault("key")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "key", valid_598195
  var valid_598196 = query.getOrDefault("$.xgafv")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = newJString("1"))
  if valid_598196 != nil:
    section.add "$.xgafv", valid_598196
  var valid_598197 = query.getOrDefault("pageSize")
  valid_598197 = validateParameter(valid_598197, JInt, required = false, default = nil)
  if valid_598197 != nil:
    section.add "pageSize", valid_598197
  var valid_598198 = query.getOrDefault("prettyPrint")
  valid_598198 = validateParameter(valid_598198, JBool, required = false,
                                 default = newJBool(true))
  if valid_598198 != nil:
    section.add "prettyPrint", valid_598198
  var valid_598199 = query.getOrDefault("filter")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "filter", valid_598199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598200: Call_AppengineAppsLocationsList_598182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598200.validator(path, query, header, formData, body)
  let scheme = call_598200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598200.url(scheme.get, call_598200.host, call_598200.base,
                         call_598200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598200, url, valid)

proc call*(call_598201: Call_AppengineAppsLocationsList_598182; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## appengineAppsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. The resource that owns the locations collection, if applicable.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_598202 = newJObject()
  var query_598203 = newJObject()
  add(query_598203, "upload_protocol", newJString(uploadProtocol))
  add(query_598203, "fields", newJString(fields))
  add(query_598203, "pageToken", newJString(pageToken))
  add(query_598203, "quotaUser", newJString(quotaUser))
  add(query_598203, "alt", newJString(alt))
  add(query_598203, "oauth_token", newJString(oauthToken))
  add(query_598203, "callback", newJString(callback))
  add(query_598203, "access_token", newJString(accessToken))
  add(query_598203, "uploadType", newJString(uploadType))
  add(query_598203, "key", newJString(key))
  add(path_598202, "appsId", newJString(appsId))
  add(query_598203, "$.xgafv", newJString(Xgafv))
  add(query_598203, "pageSize", newJInt(pageSize))
  add(query_598203, "prettyPrint", newJBool(prettyPrint))
  add(query_598203, "filter", newJString(filter))
  result = call_598201.call(path_598202, query_598203, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_598182(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_598183, base: "/",
    url: url_AppengineAppsLocationsList_598184, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_598204 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsLocationsGet_598206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsLocationsGet_598205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Resource name for the location.
  ##   locationsId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598207 = path.getOrDefault("appsId")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "appsId", valid_598207
  var valid_598208 = path.getOrDefault("locationsId")
  valid_598208 = validateParameter(valid_598208, JString, required = true,
                                 default = nil)
  if valid_598208 != nil:
    section.add "locationsId", valid_598208
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598209 = query.getOrDefault("upload_protocol")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "upload_protocol", valid_598209
  var valid_598210 = query.getOrDefault("fields")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "fields", valid_598210
  var valid_598211 = query.getOrDefault("quotaUser")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "quotaUser", valid_598211
  var valid_598212 = query.getOrDefault("alt")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("json"))
  if valid_598212 != nil:
    section.add "alt", valid_598212
  var valid_598213 = query.getOrDefault("oauth_token")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "oauth_token", valid_598213
  var valid_598214 = query.getOrDefault("callback")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "callback", valid_598214
  var valid_598215 = query.getOrDefault("access_token")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "access_token", valid_598215
  var valid_598216 = query.getOrDefault("uploadType")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "uploadType", valid_598216
  var valid_598217 = query.getOrDefault("key")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "key", valid_598217
  var valid_598218 = query.getOrDefault("$.xgafv")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = newJString("1"))
  if valid_598218 != nil:
    section.add "$.xgafv", valid_598218
  var valid_598219 = query.getOrDefault("prettyPrint")
  valid_598219 = validateParameter(valid_598219, JBool, required = false,
                                 default = newJBool(true))
  if valid_598219 != nil:
    section.add "prettyPrint", valid_598219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598220: Call_AppengineAppsLocationsGet_598204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_598220.validator(path, query, header, formData, body)
  let scheme = call_598220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598220.url(scheme.get, call_598220.host, call_598220.base,
                         call_598220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598220, url, valid)

proc call*(call_598221: Call_AppengineAppsLocationsGet_598204; appsId: string;
          locationsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsLocationsGet
  ## Gets information about a location.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Resource name for the location.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   locationsId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  var path_598222 = newJObject()
  var query_598223 = newJObject()
  add(query_598223, "upload_protocol", newJString(uploadProtocol))
  add(query_598223, "fields", newJString(fields))
  add(query_598223, "quotaUser", newJString(quotaUser))
  add(query_598223, "alt", newJString(alt))
  add(query_598223, "oauth_token", newJString(oauthToken))
  add(query_598223, "callback", newJString(callback))
  add(query_598223, "access_token", newJString(accessToken))
  add(query_598223, "uploadType", newJString(uploadType))
  add(query_598223, "key", newJString(key))
  add(path_598222, "appsId", newJString(appsId))
  add(query_598223, "$.xgafv", newJString(Xgafv))
  add(query_598223, "prettyPrint", newJBool(prettyPrint))
  add(path_598222, "locationsId", newJString(locationsId))
  result = call_598221.call(path_598222, query_598223, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_598204(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_598205, base: "/",
    url: url_AppengineAppsLocationsGet_598206, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_598224 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsOperationsList_598226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsList_598225(path: JsonNode; query: JsonNode;
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
  var valid_598227 = path.getOrDefault("appsId")
  valid_598227 = validateParameter(valid_598227, JString, required = true,
                                 default = nil)
  if valid_598227 != nil:
    section.add "appsId", valid_598227
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_598228 = query.getOrDefault("upload_protocol")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "upload_protocol", valid_598228
  var valid_598229 = query.getOrDefault("fields")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "fields", valid_598229
  var valid_598230 = query.getOrDefault("pageToken")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "pageToken", valid_598230
  var valid_598231 = query.getOrDefault("quotaUser")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "quotaUser", valid_598231
  var valid_598232 = query.getOrDefault("alt")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = newJString("json"))
  if valid_598232 != nil:
    section.add "alt", valid_598232
  var valid_598233 = query.getOrDefault("oauth_token")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "oauth_token", valid_598233
  var valid_598234 = query.getOrDefault("callback")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "callback", valid_598234
  var valid_598235 = query.getOrDefault("access_token")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "access_token", valid_598235
  var valid_598236 = query.getOrDefault("uploadType")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "uploadType", valid_598236
  var valid_598237 = query.getOrDefault("key")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "key", valid_598237
  var valid_598238 = query.getOrDefault("$.xgafv")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = newJString("1"))
  if valid_598238 != nil:
    section.add "$.xgafv", valid_598238
  var valid_598239 = query.getOrDefault("pageSize")
  valid_598239 = validateParameter(valid_598239, JInt, required = false, default = nil)
  if valid_598239 != nil:
    section.add "pageSize", valid_598239
  var valid_598240 = query.getOrDefault("prettyPrint")
  valid_598240 = validateParameter(valid_598240, JBool, required = false,
                                 default = newJBool(true))
  if valid_598240 != nil:
    section.add "prettyPrint", valid_598240
  var valid_598241 = query.getOrDefault("filter")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "filter", valid_598241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598242: Call_AppengineAppsOperationsList_598224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_598242.validator(path, query, header, formData, body)
  let scheme = call_598242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598242.url(scheme.get, call_598242.host, call_598242.base,
                         call_598242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598242, url, valid)

proc call*(call_598243: Call_AppengineAppsOperationsList_598224; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## appengineAppsOperationsList
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. The name of the operation's parent resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_598244 = newJObject()
  var query_598245 = newJObject()
  add(query_598245, "upload_protocol", newJString(uploadProtocol))
  add(query_598245, "fields", newJString(fields))
  add(query_598245, "pageToken", newJString(pageToken))
  add(query_598245, "quotaUser", newJString(quotaUser))
  add(query_598245, "alt", newJString(alt))
  add(query_598245, "oauth_token", newJString(oauthToken))
  add(query_598245, "callback", newJString(callback))
  add(query_598245, "access_token", newJString(accessToken))
  add(query_598245, "uploadType", newJString(uploadType))
  add(query_598245, "key", newJString(key))
  add(path_598244, "appsId", newJString(appsId))
  add(query_598245, "$.xgafv", newJString(Xgafv))
  add(query_598245, "pageSize", newJInt(pageSize))
  add(query_598245, "prettyPrint", newJBool(prettyPrint))
  add(query_598245, "filter", newJString(filter))
  result = call_598243.call(path_598244, query_598245, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_598224(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1alpha/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_598225, base: "/",
    url: url_AppengineAppsOperationsList_598226, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_598246 = ref object of OpenApiRestCall_597408
proc url_AppengineAppsOperationsGet_598248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsGet_598247(path: JsonNode; query: JsonNode;
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
  var valid_598249 = path.getOrDefault("appsId")
  valid_598249 = validateParameter(valid_598249, JString, required = true,
                                 default = nil)
  if valid_598249 != nil:
    section.add "appsId", valid_598249
  var valid_598250 = path.getOrDefault("operationsId")
  valid_598250 = validateParameter(valid_598250, JString, required = true,
                                 default = nil)
  if valid_598250 != nil:
    section.add "operationsId", valid_598250
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598251 = query.getOrDefault("upload_protocol")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "upload_protocol", valid_598251
  var valid_598252 = query.getOrDefault("fields")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "fields", valid_598252
  var valid_598253 = query.getOrDefault("quotaUser")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "quotaUser", valid_598253
  var valid_598254 = query.getOrDefault("alt")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = newJString("json"))
  if valid_598254 != nil:
    section.add "alt", valid_598254
  var valid_598255 = query.getOrDefault("oauth_token")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "oauth_token", valid_598255
  var valid_598256 = query.getOrDefault("callback")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "callback", valid_598256
  var valid_598257 = query.getOrDefault("access_token")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "access_token", valid_598257
  var valid_598258 = query.getOrDefault("uploadType")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "uploadType", valid_598258
  var valid_598259 = query.getOrDefault("key")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "key", valid_598259
  var valid_598260 = query.getOrDefault("$.xgafv")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = newJString("1"))
  if valid_598260 != nil:
    section.add "$.xgafv", valid_598260
  var valid_598261 = query.getOrDefault("prettyPrint")
  valid_598261 = validateParameter(valid_598261, JBool, required = false,
                                 default = newJBool(true))
  if valid_598261 != nil:
    section.add "prettyPrint", valid_598261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598262: Call_AppengineAppsOperationsGet_598246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_598262.validator(path, query, header, formData, body)
  let scheme = call_598262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598262.url(scheme.get, call_598262.host, call_598262.base,
                         call_598262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598262, url, valid)

proc call*(call_598263: Call_AppengineAppsOperationsGet_598246; appsId: string;
          operationsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsOperationsGet
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. The name of the operation resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operationsId: string (required)
  ##               : Part of `name`. See documentation of `appsId`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598264 = newJObject()
  var query_598265 = newJObject()
  add(query_598265, "upload_protocol", newJString(uploadProtocol))
  add(query_598265, "fields", newJString(fields))
  add(query_598265, "quotaUser", newJString(quotaUser))
  add(query_598265, "alt", newJString(alt))
  add(query_598265, "oauth_token", newJString(oauthToken))
  add(query_598265, "callback", newJString(callback))
  add(query_598265, "access_token", newJString(accessToken))
  add(query_598265, "uploadType", newJString(uploadType))
  add(query_598265, "key", newJString(key))
  add(path_598264, "appsId", newJString(appsId))
  add(query_598265, "$.xgafv", newJString(Xgafv))
  add(path_598264, "operationsId", newJString(operationsId))
  add(query_598265, "prettyPrint", newJBool(prettyPrint))
  result = call_598263.call(path_598264, query_598265, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_598246(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1alpha/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_598247, base: "/",
    url: url_AppengineAppsOperationsGet_598248, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
