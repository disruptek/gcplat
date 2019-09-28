
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: App Engine Admin
## version: v1
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppengineAppsCreate_579690 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsCreate_579692(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppengineAppsCreate_579691(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("callback")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "callback", valid_579822
  var valid_579823 = query.getOrDefault("access_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "access_token", valid_579823
  var valid_579824 = query.getOrDefault("uploadType")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "uploadType", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("$.xgafv")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = newJString("1"))
  if valid_579826 != nil:
    section.add "$.xgafv", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
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

proc call*(call_579851: Call_AppengineAppsCreate_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_AppengineAppsCreate_579690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsCreate
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579923 = newJObject()
  var body_579925 = newJObject()
  add(query_579923, "upload_protocol", newJString(uploadProtocol))
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "callback", newJString(callback))
  add(query_579923, "access_token", newJString(accessToken))
  add(query_579923, "uploadType", newJString(uploadType))
  add(query_579923, "key", newJString(key))
  add(query_579923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579925 = body
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, body_579925)

var appengineAppsCreate* = Call_AppengineAppsCreate_579690(
    name: "appengineAppsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps",
    validator: validate_AppengineAppsCreate_579691, base: "/",
    url: url_AppengineAppsCreate_579692, schemes: {Scheme.Https})
type
  Call_AppengineAppsGet_579964 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsGet_579966(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsGet_579965(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets information about an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Application resource to get. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579981 = path.getOrDefault("appsId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "appsId", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_AppengineAppsGet_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_AppengineAppsGet_579964; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsGet
  ## Gets information about an application.
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
  ##         : Part of `name`. Name of the Application resource to get. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(path_579995, "appsId", newJString(appsId))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_579964(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}", validator: validate_AppengineAppsGet_579965,
    base: "/", url: url_AppengineAppsGet_579966, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_579997 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsPatch_579999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_579998(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580000 = path.getOrDefault("appsId")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "appsId", valid_580000
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
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  var valid_580012 = query.getOrDefault("updateMask")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "updateMask", valid_580012
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

proc call*(call_580014: Call_AppengineAppsPatch_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_AppengineAppsPatch_579997; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## appengineAppsPatch
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
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
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  var body_580018 = newJObject()
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "key", newJString(key))
  add(path_580016, "appsId", newJString(appsId))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580018 = body
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "updateMask", newJString(updateMask))
  result = call_580015.call(path_580016, query_580017, nil, nil, body_580018)

var appengineAppsPatch* = Call_AppengineAppsPatch_579997(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}",
    validator: validate_AppengineAppsPatch_579998, base: "/",
    url: url_AppengineAppsPatch_579999, schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesCreate_580041 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedCertificatesCreate_580043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesCreate_580042(path: JsonNode;
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
  var valid_580044 = path.getOrDefault("appsId")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "appsId", valid_580044
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
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("callback")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "callback", valid_580050
  var valid_580051 = query.getOrDefault("access_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "access_token", valid_580051
  var valid_580052 = query.getOrDefault("uploadType")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "uploadType", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
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

proc call*(call_580057: Call_AppengineAppsAuthorizedCertificatesCreate_580041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_AppengineAppsAuthorizedCertificatesCreate_580041;
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
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(path_580059, "appsId", newJString(appsId))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, body_580061)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_580041(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_580042,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_580043,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_580019 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedCertificatesList_580021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesList_580020(path: JsonNode;
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
  var valid_580022 = path.getOrDefault("appsId")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "appsId", valid_580022
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
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("pageToken")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "pageToken", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("view")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_580027 != nil:
    section.add "view", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("access_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "access_token", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("pageSize")
  valid_580035 = validateParameter(valid_580035, JInt, required = false, default = nil)
  if valid_580035 != nil:
    section.add "pageSize", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580037: Call_AppengineAppsAuthorizedCertificatesList_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_AppengineAppsAuthorizedCertificatesList_580019;
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
  var path_580039 = newJObject()
  var query_580040 = newJObject()
  add(query_580040, "upload_protocol", newJString(uploadProtocol))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "pageToken", newJString(pageToken))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "view", newJString(view))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "callback", newJString(callback))
  add(query_580040, "access_token", newJString(accessToken))
  add(query_580040, "uploadType", newJString(uploadType))
  add(query_580040, "key", newJString(key))
  add(path_580039, "appsId", newJString(appsId))
  add(query_580040, "$.xgafv", newJString(Xgafv))
  add(query_580040, "pageSize", newJInt(pageSize))
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580038.call(path_580039, query_580040, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_580019(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_580020, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_580021,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_580062 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedCertificatesGet_580064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesGet_580063(path: JsonNode;
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
  var valid_580065 = path.getOrDefault("appsId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "appsId", valid_580065
  var valid_580066 = path.getOrDefault("authorizedCertificatesId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "authorizedCertificatesId", valid_580066
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
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("view")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_580069 != nil:
    section.add "view", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("callback")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "callback", valid_580073
  var valid_580074 = query.getOrDefault("access_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "access_token", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580079: Call_AppengineAppsAuthorizedCertificatesGet_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_AppengineAppsAuthorizedCertificatesGet_580062;
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
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "upload_protocol", newJString(uploadProtocol))
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "view", newJString(view))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "callback", newJString(callback))
  add(query_580082, "access_token", newJString(accessToken))
  add(query_580082, "uploadType", newJString(uploadType))
  add(query_580082, "key", newJString(key))
  add(path_580081, "appsId", newJString(appsId))
  add(query_580082, "$.xgafv", newJString(Xgafv))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(path_580081, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_580062(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_580063, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_580064,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_580103 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedCertificatesPatch_580105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesPatch_580104(path: JsonNode;
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
  var valid_580106 = path.getOrDefault("appsId")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "appsId", valid_580106
  var valid_580107 = path.getOrDefault("authorizedCertificatesId")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "authorizedCertificatesId", valid_580107
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
  var valid_580108 = query.getOrDefault("upload_protocol")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "upload_protocol", valid_580108
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  var valid_580110 = query.getOrDefault("quotaUser")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "quotaUser", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("oauth_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "oauth_token", valid_580112
  var valid_580113 = query.getOrDefault("callback")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "callback", valid_580113
  var valid_580114 = query.getOrDefault("access_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "access_token", valid_580114
  var valid_580115 = query.getOrDefault("uploadType")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "uploadType", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("$.xgafv")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("1"))
  if valid_580117 != nil:
    section.add "$.xgafv", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("updateMask")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "updateMask", valid_580119
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

proc call*(call_580121: Call_AppengineAppsAuthorizedCertificatesPatch_580103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_AppengineAppsAuthorizedCertificatesPatch_580103;
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "key", newJString(key))
  add(path_580123, "appsId", newJString(appsId))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580125 = body
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  add(query_580124, "updateMask", newJString(updateMask))
  add(path_580123, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_580103(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_580104,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_580105,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_580083 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedCertificatesDelete_580085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesDelete_580084(path: JsonNode;
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
  var valid_580086 = path.getOrDefault("appsId")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "appsId", valid_580086
  var valid_580087 = path.getOrDefault("authorizedCertificatesId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "authorizedCertificatesId", valid_580087
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
  var valid_580088 = query.getOrDefault("upload_protocol")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "upload_protocol", valid_580088
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("quotaUser")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "quotaUser", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("callback")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "callback", valid_580093
  var valid_580094 = query.getOrDefault("access_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "access_token", valid_580094
  var valid_580095 = query.getOrDefault("uploadType")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "uploadType", valid_580095
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("$.xgafv")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("1"))
  if valid_580097 != nil:
    section.add "$.xgafv", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580099: Call_AppengineAppsAuthorizedCertificatesDelete_580083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_AppengineAppsAuthorizedCertificatesDelete_580083;
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
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  add(query_580102, "upload_protocol", newJString(uploadProtocol))
  add(query_580102, "fields", newJString(fields))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(query_580102, "callback", newJString(callback))
  add(query_580102, "access_token", newJString(accessToken))
  add(query_580102, "uploadType", newJString(uploadType))
  add(query_580102, "key", newJString(key))
  add(path_580101, "appsId", newJString(appsId))
  add(query_580102, "$.xgafv", newJString(Xgafv))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  add(path_580101, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_580100.call(path_580101, query_580102, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_580083(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_580084,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_580085,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_580126 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsAuthorizedDomainsList_580128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedDomainsList_580127(path: JsonNode;
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
  var valid_580129 = path.getOrDefault("appsId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "appsId", valid_580129
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
  var valid_580130 = query.getOrDefault("upload_protocol")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "upload_protocol", valid_580130
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("pageToken")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "pageToken", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("callback")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "callback", valid_580136
  var valid_580137 = query.getOrDefault("access_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "access_token", valid_580137
  var valid_580138 = query.getOrDefault("uploadType")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "uploadType", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("pageSize")
  valid_580141 = validateParameter(valid_580141, JInt, required = false, default = nil)
  if valid_580141 != nil:
    section.add "pageSize", valid_580141
  var valid_580142 = query.getOrDefault("prettyPrint")
  valid_580142 = validateParameter(valid_580142, JBool, required = false,
                                 default = newJBool(true))
  if valid_580142 != nil:
    section.add "prettyPrint", valid_580142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580143: Call_AppengineAppsAuthorizedDomainsList_580126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_AppengineAppsAuthorizedDomainsList_580126;
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
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "pageToken", newJString(pageToken))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "callback", newJString(callback))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "key", newJString(key))
  add(path_580145, "appsId", newJString(appsId))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  add(query_580146, "pageSize", newJInt(pageSize))
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  result = call_580144.call(path_580145, query_580146, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_580126(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_580127, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_580128, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_580168 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsDomainMappingsCreate_580170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsCreate_580169(path: JsonNode;
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
  var valid_580171 = path.getOrDefault("appsId")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "appsId", valid_580171
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
  ##   overrideStrategy: JString
  ##                   : Whether the domain creation should override any existing mappings for this domain. By default, overrides are rejected.
  section = newJObject()
  var valid_580172 = query.getOrDefault("upload_protocol")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "upload_protocol", valid_580172
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  var valid_580174 = query.getOrDefault("quotaUser")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "quotaUser", valid_580174
  var valid_580175 = query.getOrDefault("alt")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("json"))
  if valid_580175 != nil:
    section.add "alt", valid_580175
  var valid_580176 = query.getOrDefault("oauth_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "oauth_token", valid_580176
  var valid_580177 = query.getOrDefault("callback")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "callback", valid_580177
  var valid_580178 = query.getOrDefault("access_token")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "access_token", valid_580178
  var valid_580179 = query.getOrDefault("uploadType")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "uploadType", valid_580179
  var valid_580180 = query.getOrDefault("key")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "key", valid_580180
  var valid_580181 = query.getOrDefault("$.xgafv")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("1"))
  if valid_580181 != nil:
    section.add "$.xgafv", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("overrideStrategy")
  valid_580183 = validateParameter(valid_580183, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_580183 != nil:
    section.add "overrideStrategy", valid_580183
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

proc call*(call_580185: Call_AppengineAppsDomainMappingsCreate_580168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_AppengineAppsDomainMappingsCreate_580168;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true;
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
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  var body_580189 = newJObject()
  add(query_580188, "upload_protocol", newJString(uploadProtocol))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "callback", newJString(callback))
  add(query_580188, "access_token", newJString(accessToken))
  add(query_580188, "uploadType", newJString(uploadType))
  add(query_580188, "key", newJString(key))
  add(path_580187, "appsId", newJString(appsId))
  add(query_580188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580189 = body
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  add(query_580188, "overrideStrategy", newJString(overrideStrategy))
  result = call_580186.call(path_580187, query_580188, nil, nil, body_580189)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_580168(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_580169, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_580170, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_580147 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsDomainMappingsList_580149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsList_580148(path: JsonNode;
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
  var valid_580150 = path.getOrDefault("appsId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "appsId", valid_580150
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
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("pageToken")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "pageToken", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("callback")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "callback", valid_580157
  var valid_580158 = query.getOrDefault("access_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "access_token", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("pageSize")
  valid_580162 = validateParameter(valid_580162, JInt, required = false, default = nil)
  if valid_580162 != nil:
    section.add "pageSize", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580164: Call_AppengineAppsDomainMappingsList_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_AppengineAppsDomainMappingsList_580147;
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
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  add(query_580167, "upload_protocol", newJString(uploadProtocol))
  add(query_580167, "fields", newJString(fields))
  add(query_580167, "pageToken", newJString(pageToken))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(query_580167, "alt", newJString(alt))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "callback", newJString(callback))
  add(query_580167, "access_token", newJString(accessToken))
  add(query_580167, "uploadType", newJString(uploadType))
  add(query_580167, "key", newJString(key))
  add(path_580166, "appsId", newJString(appsId))
  add(query_580167, "$.xgafv", newJString(Xgafv))
  add(query_580167, "pageSize", newJInt(pageSize))
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  result = call_580165.call(path_580166, query_580167, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_580147(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_580148, base: "/",
    url: url_AppengineAppsDomainMappingsList_580149, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_580190 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsDomainMappingsGet_580192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsGet_580191(path: JsonNode;
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
  var valid_580193 = path.getOrDefault("appsId")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "appsId", valid_580193
  var valid_580194 = path.getOrDefault("domainMappingsId")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "domainMappingsId", valid_580194
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
  var valid_580195 = query.getOrDefault("upload_protocol")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "upload_protocol", valid_580195
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("alt")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("json"))
  if valid_580198 != nil:
    section.add "alt", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("callback")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "callback", valid_580200
  var valid_580201 = query.getOrDefault("access_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "access_token", valid_580201
  var valid_580202 = query.getOrDefault("uploadType")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "uploadType", valid_580202
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("$.xgafv")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("1"))
  if valid_580204 != nil:
    section.add "$.xgafv", valid_580204
  var valid_580205 = query.getOrDefault("prettyPrint")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "prettyPrint", valid_580205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580206: Call_AppengineAppsDomainMappingsGet_580190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_580206.validator(path, query, header, formData, body)
  let scheme = call_580206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580206.url(scheme.get, call_580206.host, call_580206.base,
                         call_580206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580206, url, valid)

proc call*(call_580207: Call_AppengineAppsDomainMappingsGet_580190; appsId: string;
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
  var path_580208 = newJObject()
  var query_580209 = newJObject()
  add(query_580209, "upload_protocol", newJString(uploadProtocol))
  add(query_580209, "fields", newJString(fields))
  add(query_580209, "quotaUser", newJString(quotaUser))
  add(query_580209, "alt", newJString(alt))
  add(query_580209, "oauth_token", newJString(oauthToken))
  add(query_580209, "callback", newJString(callback))
  add(query_580209, "access_token", newJString(accessToken))
  add(query_580209, "uploadType", newJString(uploadType))
  add(query_580209, "key", newJString(key))
  add(path_580208, "appsId", newJString(appsId))
  add(query_580209, "$.xgafv", newJString(Xgafv))
  add(query_580209, "prettyPrint", newJBool(prettyPrint))
  add(path_580208, "domainMappingsId", newJString(domainMappingsId))
  result = call_580207.call(path_580208, query_580209, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_580190(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_580191, base: "/",
    url: url_AppengineAppsDomainMappingsGet_580192, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_580230 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsDomainMappingsPatch_580232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsPatch_580231(path: JsonNode;
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
  var valid_580233 = path.getOrDefault("appsId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "appsId", valid_580233
  var valid_580234 = path.getOrDefault("domainMappingsId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "domainMappingsId", valid_580234
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
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("callback")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "callback", valid_580240
  var valid_580241 = query.getOrDefault("access_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "access_token", valid_580241
  var valid_580242 = query.getOrDefault("uploadType")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "uploadType", valid_580242
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("$.xgafv")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("1"))
  if valid_580244 != nil:
    section.add "$.xgafv", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  var valid_580246 = query.getOrDefault("updateMask")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "updateMask", valid_580246
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

proc call*(call_580248: Call_AppengineAppsDomainMappingsPatch_580230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_AppengineAppsDomainMappingsPatch_580230;
          appsId: string; domainMappingsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
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
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  var body_580252 = newJObject()
  add(query_580251, "upload_protocol", newJString(uploadProtocol))
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "callback", newJString(callback))
  add(query_580251, "access_token", newJString(accessToken))
  add(query_580251, "uploadType", newJString(uploadType))
  add(query_580251, "key", newJString(key))
  add(path_580250, "appsId", newJString(appsId))
  add(query_580251, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580252 = body
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  add(path_580250, "domainMappingsId", newJString(domainMappingsId))
  add(query_580251, "updateMask", newJString(updateMask))
  result = call_580249.call(path_580250, query_580251, nil, nil, body_580252)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_580230(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_580231, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_580232, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_580210 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsDomainMappingsDelete_580212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsDelete_580211(path: JsonNode;
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
  var valid_580213 = path.getOrDefault("appsId")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "appsId", valid_580213
  var valid_580214 = path.getOrDefault("domainMappingsId")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "domainMappingsId", valid_580214
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
  var valid_580215 = query.getOrDefault("upload_protocol")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "upload_protocol", valid_580215
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("quotaUser")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "quotaUser", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("callback")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "callback", valid_580220
  var valid_580221 = query.getOrDefault("access_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "access_token", valid_580221
  var valid_580222 = query.getOrDefault("uploadType")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "uploadType", valid_580222
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("$.xgafv")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("1"))
  if valid_580224 != nil:
    section.add "$.xgafv", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_AppengineAppsDomainMappingsDelete_580210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_AppengineAppsDomainMappingsDelete_580210;
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
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "upload_protocol", newJString(uploadProtocol))
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "callback", newJString(callback))
  add(query_580229, "access_token", newJString(accessToken))
  add(query_580229, "uploadType", newJString(uploadType))
  add(query_580229, "key", newJString(key))
  add(path_580228, "appsId", newJString(appsId))
  add(query_580229, "$.xgafv", newJString(Xgafv))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  add(path_580228, "domainMappingsId", newJString(domainMappingsId))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_580210(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_580211, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_580212, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesCreate_580275 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesCreate_580277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesCreate_580276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a firewall rule for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Firewall collection in which to create a new rule. Example: apps/myapp/firewall/ingressRules.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580278 = path.getOrDefault("appsId")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "appsId", valid_580278
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
  var valid_580279 = query.getOrDefault("upload_protocol")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "upload_protocol", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("oauth_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "oauth_token", valid_580283
  var valid_580284 = query.getOrDefault("callback")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "callback", valid_580284
  var valid_580285 = query.getOrDefault("access_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "access_token", valid_580285
  var valid_580286 = query.getOrDefault("uploadType")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "uploadType", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("prettyPrint")
  valid_580289 = validateParameter(valid_580289, JBool, required = false,
                                 default = newJBool(true))
  if valid_580289 != nil:
    section.add "prettyPrint", valid_580289
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

proc call*(call_580291: Call_AppengineAppsFirewallIngressRulesCreate_580275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a firewall rule for the application.
  ## 
  let valid = call_580291.validator(path, query, header, formData, body)
  let scheme = call_580291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580291.url(scheme.get, call_580291.host, call_580291.base,
                         call_580291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580291, url, valid)

proc call*(call_580292: Call_AppengineAppsFirewallIngressRulesCreate_580275;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsFirewallIngressRulesCreate
  ## Creates a firewall rule for the application.
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
  ##         : Part of `parent`. Name of the parent Firewall collection in which to create a new rule. Example: apps/myapp/firewall/ingressRules.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580293 = newJObject()
  var query_580294 = newJObject()
  var body_580295 = newJObject()
  add(query_580294, "upload_protocol", newJString(uploadProtocol))
  add(query_580294, "fields", newJString(fields))
  add(query_580294, "quotaUser", newJString(quotaUser))
  add(query_580294, "alt", newJString(alt))
  add(query_580294, "oauth_token", newJString(oauthToken))
  add(query_580294, "callback", newJString(callback))
  add(query_580294, "access_token", newJString(accessToken))
  add(query_580294, "uploadType", newJString(uploadType))
  add(query_580294, "key", newJString(key))
  add(path_580293, "appsId", newJString(appsId))
  add(query_580294, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580295 = body
  add(query_580294, "prettyPrint", newJBool(prettyPrint))
  result = call_580292.call(path_580293, query_580294, nil, nil, body_580295)

var appengineAppsFirewallIngressRulesCreate* = Call_AppengineAppsFirewallIngressRulesCreate_580275(
    name: "appengineAppsFirewallIngressRulesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesCreate_580276, base: "/",
    url: url_AppengineAppsFirewallIngressRulesCreate_580277,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesList_580253 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesList_580255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesList_580254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the firewall rules of an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the Firewall collection to retrieve. Example: apps/myapp/firewall/ingressRules.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580256 = path.getOrDefault("appsId")
  valid_580256 = validateParameter(valid_580256, JString, required = true,
                                 default = nil)
  if valid_580256 != nil:
    section.add "appsId", valid_580256
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
  ##   matchingAddress: JString
  ##                  : A valid IP Address. If set, only rules matching this address will be returned. The first returned rule will be the rule that fires on requests from this IP.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580257 = query.getOrDefault("upload_protocol")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "upload_protocol", valid_580257
  var valid_580258 = query.getOrDefault("fields")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "fields", valid_580258
  var valid_580259 = query.getOrDefault("pageToken")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "pageToken", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("callback")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "callback", valid_580263
  var valid_580264 = query.getOrDefault("access_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "access_token", valid_580264
  var valid_580265 = query.getOrDefault("uploadType")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "uploadType", valid_580265
  var valid_580266 = query.getOrDefault("matchingAddress")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "matchingAddress", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("$.xgafv")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("1"))
  if valid_580268 != nil:
    section.add "$.xgafv", valid_580268
  var valid_580269 = query.getOrDefault("pageSize")
  valid_580269 = validateParameter(valid_580269, JInt, required = false, default = nil)
  if valid_580269 != nil:
    section.add "pageSize", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580271: Call_AppengineAppsFirewallIngressRulesList_580253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the firewall rules of an application.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_AppengineAppsFirewallIngressRulesList_580253;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; matchingAddress: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsFirewallIngressRulesList
  ## Lists the firewall rules of an application.
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
  ##   matchingAddress: string
  ##                  : A valid IP Address. If set, only rules matching this address will be returned. The first returned rule will be the rule that fires on requests from this IP.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the Firewall collection to retrieve. Example: apps/myapp/firewall/ingressRules.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  add(query_580274, "upload_protocol", newJString(uploadProtocol))
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "pageToken", newJString(pageToken))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(query_580274, "callback", newJString(callback))
  add(query_580274, "access_token", newJString(accessToken))
  add(query_580274, "uploadType", newJString(uploadType))
  add(query_580274, "matchingAddress", newJString(matchingAddress))
  add(query_580274, "key", newJString(key))
  add(path_580273, "appsId", newJString(appsId))
  add(query_580274, "$.xgafv", newJString(Xgafv))
  add(query_580274, "pageSize", newJInt(pageSize))
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  result = call_580272.call(path_580273, query_580274, nil, nil, nil)

var appengineAppsFirewallIngressRulesList* = Call_AppengineAppsFirewallIngressRulesList_580253(
    name: "appengineAppsFirewallIngressRulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesList_580254, base: "/",
    url: url_AppengineAppsFirewallIngressRulesList_580255, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesGet_580296 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesGet_580298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesGet_580297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to retrieve. Example: apps/myapp/firewall/ingressRules/100.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ingressRulesId` field"
  var valid_580299 = path.getOrDefault("ingressRulesId")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "ingressRulesId", valid_580299
  var valid_580300 = path.getOrDefault("appsId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "appsId", valid_580300
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
  var valid_580301 = query.getOrDefault("upload_protocol")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "upload_protocol", valid_580301
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("callback")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "callback", valid_580306
  var valid_580307 = query.getOrDefault("access_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "access_token", valid_580307
  var valid_580308 = query.getOrDefault("uploadType")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "uploadType", valid_580308
  var valid_580309 = query.getOrDefault("key")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "key", valid_580309
  var valid_580310 = query.getOrDefault("$.xgafv")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("1"))
  if valid_580310 != nil:
    section.add "$.xgafv", valid_580310
  var valid_580311 = query.getOrDefault("prettyPrint")
  valid_580311 = validateParameter(valid_580311, JBool, required = false,
                                 default = newJBool(true))
  if valid_580311 != nil:
    section.add "prettyPrint", valid_580311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580312: Call_AppengineAppsFirewallIngressRulesGet_580296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified firewall rule.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_AppengineAppsFirewallIngressRulesGet_580296;
          ingressRulesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## appengineAppsFirewallIngressRulesGet
  ## Gets the specified firewall rule.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
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
  ##         : Part of `name`. Name of the Firewall resource to retrieve. Example: apps/myapp/firewall/ingressRules/100.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  add(query_580315, "upload_protocol", newJString(uploadProtocol))
  add(path_580314, "ingressRulesId", newJString(ingressRulesId))
  add(query_580315, "fields", newJString(fields))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(query_580315, "callback", newJString(callback))
  add(query_580315, "access_token", newJString(accessToken))
  add(query_580315, "uploadType", newJString(uploadType))
  add(query_580315, "key", newJString(key))
  add(path_580314, "appsId", newJString(appsId))
  add(query_580315, "$.xgafv", newJString(Xgafv))
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  result = call_580313.call(path_580314, query_580315, nil, nil, nil)

var appengineAppsFirewallIngressRulesGet* = Call_AppengineAppsFirewallIngressRulesGet_580296(
    name: "appengineAppsFirewallIngressRulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesGet_580297, base: "/",
    url: url_AppengineAppsFirewallIngressRulesGet_580298, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesPatch_580336 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesPatch_580338(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesPatch_580337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to update. Example: apps/myapp/firewall/ingressRules/100.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ingressRulesId` field"
  var valid_580339 = path.getOrDefault("ingressRulesId")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "ingressRulesId", valid_580339
  var valid_580340 = path.getOrDefault("appsId")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "appsId", valid_580340
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
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_580341 = query.getOrDefault("upload_protocol")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "upload_protocol", valid_580341
  var valid_580342 = query.getOrDefault("fields")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "fields", valid_580342
  var valid_580343 = query.getOrDefault("quotaUser")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "quotaUser", valid_580343
  var valid_580344 = query.getOrDefault("alt")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("json"))
  if valid_580344 != nil:
    section.add "alt", valid_580344
  var valid_580345 = query.getOrDefault("oauth_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "oauth_token", valid_580345
  var valid_580346 = query.getOrDefault("callback")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "callback", valid_580346
  var valid_580347 = query.getOrDefault("access_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "access_token", valid_580347
  var valid_580348 = query.getOrDefault("uploadType")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "uploadType", valid_580348
  var valid_580349 = query.getOrDefault("key")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "key", valid_580349
  var valid_580350 = query.getOrDefault("$.xgafv")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = newJString("1"))
  if valid_580350 != nil:
    section.add "$.xgafv", valid_580350
  var valid_580351 = query.getOrDefault("prettyPrint")
  valid_580351 = validateParameter(valid_580351, JBool, required = false,
                                 default = newJBool(true))
  if valid_580351 != nil:
    section.add "prettyPrint", valid_580351
  var valid_580352 = query.getOrDefault("updateMask")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "updateMask", valid_580352
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

proc call*(call_580354: Call_AppengineAppsFirewallIngressRulesPatch_580336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_AppengineAppsFirewallIngressRulesPatch_580336;
          ingressRulesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesPatch
  ## Updates the specified firewall rule.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
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
  ##         : Part of `name`. Name of the Firewall resource to update. Example: apps/myapp/firewall/ingressRules/100.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  var body_580358 = newJObject()
  add(query_580357, "upload_protocol", newJString(uploadProtocol))
  add(path_580356, "ingressRulesId", newJString(ingressRulesId))
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "callback", newJString(callback))
  add(query_580357, "access_token", newJString(accessToken))
  add(query_580357, "uploadType", newJString(uploadType))
  add(query_580357, "key", newJString(key))
  add(path_580356, "appsId", newJString(appsId))
  add(query_580357, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580358 = body
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  add(query_580357, "updateMask", newJString(updateMask))
  result = call_580355.call(path_580356, query_580357, nil, nil, body_580358)

var appengineAppsFirewallIngressRulesPatch* = Call_AppengineAppsFirewallIngressRulesPatch_580336(
    name: "appengineAppsFirewallIngressRulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesPatch_580337, base: "/",
    url: url_AppengineAppsFirewallIngressRulesPatch_580338,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesDelete_580316 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesDelete_580318(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesDelete_580317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to delete. Example: apps/myapp/firewall/ingressRules/100.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ingressRulesId` field"
  var valid_580319 = path.getOrDefault("ingressRulesId")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "ingressRulesId", valid_580319
  var valid_580320 = path.getOrDefault("appsId")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "appsId", valid_580320
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
  var valid_580321 = query.getOrDefault("upload_protocol")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "upload_protocol", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("quotaUser")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "quotaUser", valid_580323
  var valid_580324 = query.getOrDefault("alt")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = newJString("json"))
  if valid_580324 != nil:
    section.add "alt", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("callback")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "callback", valid_580326
  var valid_580327 = query.getOrDefault("access_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "access_token", valid_580327
  var valid_580328 = query.getOrDefault("uploadType")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "uploadType", valid_580328
  var valid_580329 = query.getOrDefault("key")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "key", valid_580329
  var valid_580330 = query.getOrDefault("$.xgafv")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("1"))
  if valid_580330 != nil:
    section.add "$.xgafv", valid_580330
  var valid_580331 = query.getOrDefault("prettyPrint")
  valid_580331 = validateParameter(valid_580331, JBool, required = false,
                                 default = newJBool(true))
  if valid_580331 != nil:
    section.add "prettyPrint", valid_580331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580332: Call_AppengineAppsFirewallIngressRulesDelete_580316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified firewall rule.
  ## 
  let valid = call_580332.validator(path, query, header, formData, body)
  let scheme = call_580332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580332.url(scheme.get, call_580332.host, call_580332.base,
                         call_580332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580332, url, valid)

proc call*(call_580333: Call_AppengineAppsFirewallIngressRulesDelete_580316;
          ingressRulesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## appengineAppsFirewallIngressRulesDelete
  ## Deletes the specified firewall rule.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
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
  ##         : Part of `name`. Name of the Firewall resource to delete. Example: apps/myapp/firewall/ingressRules/100.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580334 = newJObject()
  var query_580335 = newJObject()
  add(query_580335, "upload_protocol", newJString(uploadProtocol))
  add(path_580334, "ingressRulesId", newJString(ingressRulesId))
  add(query_580335, "fields", newJString(fields))
  add(query_580335, "quotaUser", newJString(quotaUser))
  add(query_580335, "alt", newJString(alt))
  add(query_580335, "oauth_token", newJString(oauthToken))
  add(query_580335, "callback", newJString(callback))
  add(query_580335, "access_token", newJString(accessToken))
  add(query_580335, "uploadType", newJString(uploadType))
  add(query_580335, "key", newJString(key))
  add(path_580334, "appsId", newJString(appsId))
  add(query_580335, "$.xgafv", newJString(Xgafv))
  add(query_580335, "prettyPrint", newJBool(prettyPrint))
  result = call_580333.call(path_580334, query_580335, nil, nil, nil)

var appengineAppsFirewallIngressRulesDelete* = Call_AppengineAppsFirewallIngressRulesDelete_580316(
    name: "appengineAppsFirewallIngressRulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesDelete_580317, base: "/",
    url: url_AppengineAppsFirewallIngressRulesDelete_580318,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesBatchUpdate_580359 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsFirewallIngressRulesBatchUpdate_580361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"), (kind: ConstantSegment,
        value: "/firewall/ingressRules:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesBatchUpdate_580360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall collection to set. Example: apps/myapp/firewall/ingressRules.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580362 = path.getOrDefault("appsId")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "appsId", valid_580362
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
  var valid_580363 = query.getOrDefault("upload_protocol")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "upload_protocol", valid_580363
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("oauth_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "oauth_token", valid_580367
  var valid_580368 = query.getOrDefault("callback")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "callback", valid_580368
  var valid_580369 = query.getOrDefault("access_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "access_token", valid_580369
  var valid_580370 = query.getOrDefault("uploadType")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "uploadType", valid_580370
  var valid_580371 = query.getOrDefault("key")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "key", valid_580371
  var valid_580372 = query.getOrDefault("$.xgafv")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("1"))
  if valid_580372 != nil:
    section.add "$.xgafv", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
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

proc call*(call_580375: Call_AppengineAppsFirewallIngressRulesBatchUpdate_580359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_AppengineAppsFirewallIngressRulesBatchUpdate_580359;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsFirewallIngressRulesBatchUpdate
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
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
  ##         : Part of `name`. Name of the Firewall collection to set. Example: apps/myapp/firewall/ingressRules.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580377 = newJObject()
  var query_580378 = newJObject()
  var body_580379 = newJObject()
  add(query_580378, "upload_protocol", newJString(uploadProtocol))
  add(query_580378, "fields", newJString(fields))
  add(query_580378, "quotaUser", newJString(quotaUser))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "callback", newJString(callback))
  add(query_580378, "access_token", newJString(accessToken))
  add(query_580378, "uploadType", newJString(uploadType))
  add(query_580378, "key", newJString(key))
  add(path_580377, "appsId", newJString(appsId))
  add(query_580378, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580379 = body
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  result = call_580376.call(path_580377, query_580378, nil, nil, body_580379)

var appengineAppsFirewallIngressRulesBatchUpdate* = Call_AppengineAppsFirewallIngressRulesBatchUpdate_580359(
    name: "appengineAppsFirewallIngressRulesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules:batchUpdate",
    validator: validate_AppengineAppsFirewallIngressRulesBatchUpdate_580360,
    base: "/", url: url_AppengineAppsFirewallIngressRulesBatchUpdate_580361,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_580380 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsLocationsList_580382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsList_580381(path: JsonNode; query: JsonNode;
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
  var valid_580383 = path.getOrDefault("appsId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "appsId", valid_580383
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
  var valid_580384 = query.getOrDefault("upload_protocol")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "upload_protocol", valid_580384
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  var valid_580386 = query.getOrDefault("pageToken")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "pageToken", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("callback")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "callback", valid_580390
  var valid_580391 = query.getOrDefault("access_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "access_token", valid_580391
  var valid_580392 = query.getOrDefault("uploadType")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "uploadType", valid_580392
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("$.xgafv")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = newJString("1"))
  if valid_580394 != nil:
    section.add "$.xgafv", valid_580394
  var valid_580395 = query.getOrDefault("pageSize")
  valid_580395 = validateParameter(valid_580395, JInt, required = false, default = nil)
  if valid_580395 != nil:
    section.add "pageSize", valid_580395
  var valid_580396 = query.getOrDefault("prettyPrint")
  valid_580396 = validateParameter(valid_580396, JBool, required = false,
                                 default = newJBool(true))
  if valid_580396 != nil:
    section.add "prettyPrint", valid_580396
  var valid_580397 = query.getOrDefault("filter")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "filter", valid_580397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580398: Call_AppengineAppsLocationsList_580380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580398.validator(path, query, header, formData, body)
  let scheme = call_580398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580398.url(scheme.get, call_580398.host, call_580398.base,
                         call_580398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580398, url, valid)

proc call*(call_580399: Call_AppengineAppsLocationsList_580380; appsId: string;
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
  var path_580400 = newJObject()
  var query_580401 = newJObject()
  add(query_580401, "upload_protocol", newJString(uploadProtocol))
  add(query_580401, "fields", newJString(fields))
  add(query_580401, "pageToken", newJString(pageToken))
  add(query_580401, "quotaUser", newJString(quotaUser))
  add(query_580401, "alt", newJString(alt))
  add(query_580401, "oauth_token", newJString(oauthToken))
  add(query_580401, "callback", newJString(callback))
  add(query_580401, "access_token", newJString(accessToken))
  add(query_580401, "uploadType", newJString(uploadType))
  add(query_580401, "key", newJString(key))
  add(path_580400, "appsId", newJString(appsId))
  add(query_580401, "$.xgafv", newJString(Xgafv))
  add(query_580401, "pageSize", newJInt(pageSize))
  add(query_580401, "prettyPrint", newJBool(prettyPrint))
  add(query_580401, "filter", newJString(filter))
  result = call_580399.call(path_580400, query_580401, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_580380(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_580381, base: "/",
    url: url_AppengineAppsLocationsList_580382, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_580402 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsLocationsGet_580404(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "locationsId" in path, "`locationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "locationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsGet_580403(path: JsonNode; query: JsonNode;
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
  var valid_580405 = path.getOrDefault("appsId")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "appsId", valid_580405
  var valid_580406 = path.getOrDefault("locationsId")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "locationsId", valid_580406
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
  var valid_580407 = query.getOrDefault("upload_protocol")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "upload_protocol", valid_580407
  var valid_580408 = query.getOrDefault("fields")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "fields", valid_580408
  var valid_580409 = query.getOrDefault("quotaUser")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "quotaUser", valid_580409
  var valid_580410 = query.getOrDefault("alt")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("json"))
  if valid_580410 != nil:
    section.add "alt", valid_580410
  var valid_580411 = query.getOrDefault("oauth_token")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "oauth_token", valid_580411
  var valid_580412 = query.getOrDefault("callback")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "callback", valid_580412
  var valid_580413 = query.getOrDefault("access_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "access_token", valid_580413
  var valid_580414 = query.getOrDefault("uploadType")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "uploadType", valid_580414
  var valid_580415 = query.getOrDefault("key")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "key", valid_580415
  var valid_580416 = query.getOrDefault("$.xgafv")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = newJString("1"))
  if valid_580416 != nil:
    section.add "$.xgafv", valid_580416
  var valid_580417 = query.getOrDefault("prettyPrint")
  valid_580417 = validateParameter(valid_580417, JBool, required = false,
                                 default = newJBool(true))
  if valid_580417 != nil:
    section.add "prettyPrint", valid_580417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580418: Call_AppengineAppsLocationsGet_580402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_580418.validator(path, query, header, formData, body)
  let scheme = call_580418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580418.url(scheme.get, call_580418.host, call_580418.base,
                         call_580418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580418, url, valid)

proc call*(call_580419: Call_AppengineAppsLocationsGet_580402; appsId: string;
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
  var path_580420 = newJObject()
  var query_580421 = newJObject()
  add(query_580421, "upload_protocol", newJString(uploadProtocol))
  add(query_580421, "fields", newJString(fields))
  add(query_580421, "quotaUser", newJString(quotaUser))
  add(query_580421, "alt", newJString(alt))
  add(query_580421, "oauth_token", newJString(oauthToken))
  add(query_580421, "callback", newJString(callback))
  add(query_580421, "access_token", newJString(accessToken))
  add(query_580421, "uploadType", newJString(uploadType))
  add(query_580421, "key", newJString(key))
  add(path_580420, "appsId", newJString(appsId))
  add(query_580421, "$.xgafv", newJString(Xgafv))
  add(query_580421, "prettyPrint", newJBool(prettyPrint))
  add(path_580420, "locationsId", newJString(locationsId))
  result = call_580419.call(path_580420, query_580421, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_580402(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_580403, base: "/",
    url: url_AppengineAppsLocationsGet_580404, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_580422 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsOperationsList_580424(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsList_580423(path: JsonNode; query: JsonNode;
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
  var valid_580425 = path.getOrDefault("appsId")
  valid_580425 = validateParameter(valid_580425, JString, required = true,
                                 default = nil)
  if valid_580425 != nil:
    section.add "appsId", valid_580425
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
  var valid_580426 = query.getOrDefault("upload_protocol")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "upload_protocol", valid_580426
  var valid_580427 = query.getOrDefault("fields")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "fields", valid_580427
  var valid_580428 = query.getOrDefault("pageToken")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "pageToken", valid_580428
  var valid_580429 = query.getOrDefault("quotaUser")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "quotaUser", valid_580429
  var valid_580430 = query.getOrDefault("alt")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("json"))
  if valid_580430 != nil:
    section.add "alt", valid_580430
  var valid_580431 = query.getOrDefault("oauth_token")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "oauth_token", valid_580431
  var valid_580432 = query.getOrDefault("callback")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "callback", valid_580432
  var valid_580433 = query.getOrDefault("access_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "access_token", valid_580433
  var valid_580434 = query.getOrDefault("uploadType")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "uploadType", valid_580434
  var valid_580435 = query.getOrDefault("key")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "key", valid_580435
  var valid_580436 = query.getOrDefault("$.xgafv")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = newJString("1"))
  if valid_580436 != nil:
    section.add "$.xgafv", valid_580436
  var valid_580437 = query.getOrDefault("pageSize")
  valid_580437 = validateParameter(valid_580437, JInt, required = false, default = nil)
  if valid_580437 != nil:
    section.add "pageSize", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
  var valid_580439 = query.getOrDefault("filter")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "filter", valid_580439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580440: Call_AppengineAppsOperationsList_580422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_580440.validator(path, query, header, formData, body)
  let scheme = call_580440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580440.url(scheme.get, call_580440.host, call_580440.base,
                         call_580440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580440, url, valid)

proc call*(call_580441: Call_AppengineAppsOperationsList_580422; appsId: string;
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
  var path_580442 = newJObject()
  var query_580443 = newJObject()
  add(query_580443, "upload_protocol", newJString(uploadProtocol))
  add(query_580443, "fields", newJString(fields))
  add(query_580443, "pageToken", newJString(pageToken))
  add(query_580443, "quotaUser", newJString(quotaUser))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(query_580443, "callback", newJString(callback))
  add(query_580443, "access_token", newJString(accessToken))
  add(query_580443, "uploadType", newJString(uploadType))
  add(query_580443, "key", newJString(key))
  add(path_580442, "appsId", newJString(appsId))
  add(query_580443, "$.xgafv", newJString(Xgafv))
  add(query_580443, "pageSize", newJInt(pageSize))
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  add(query_580443, "filter", newJString(filter))
  result = call_580441.call(path_580442, query_580443, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_580422(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_580423, base: "/",
    url: url_AppengineAppsOperationsList_580424, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_580444 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsOperationsGet_580446(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "operationsId" in path, "`operationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsGet_580445(path: JsonNode; query: JsonNode;
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
  var valid_580447 = path.getOrDefault("appsId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "appsId", valid_580447
  var valid_580448 = path.getOrDefault("operationsId")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "operationsId", valid_580448
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
  var valid_580449 = query.getOrDefault("upload_protocol")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "upload_protocol", valid_580449
  var valid_580450 = query.getOrDefault("fields")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "fields", valid_580450
  var valid_580451 = query.getOrDefault("quotaUser")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "quotaUser", valid_580451
  var valid_580452 = query.getOrDefault("alt")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = newJString("json"))
  if valid_580452 != nil:
    section.add "alt", valid_580452
  var valid_580453 = query.getOrDefault("oauth_token")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "oauth_token", valid_580453
  var valid_580454 = query.getOrDefault("callback")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "callback", valid_580454
  var valid_580455 = query.getOrDefault("access_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "access_token", valid_580455
  var valid_580456 = query.getOrDefault("uploadType")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "uploadType", valid_580456
  var valid_580457 = query.getOrDefault("key")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "key", valid_580457
  var valid_580458 = query.getOrDefault("$.xgafv")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = newJString("1"))
  if valid_580458 != nil:
    section.add "$.xgafv", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580460: Call_AppengineAppsOperationsGet_580444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_580460.validator(path, query, header, formData, body)
  let scheme = call_580460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580460.url(scheme.get, call_580460.host, call_580460.base,
                         call_580460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580460, url, valid)

proc call*(call_580461: Call_AppengineAppsOperationsGet_580444; appsId: string;
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
  var path_580462 = newJObject()
  var query_580463 = newJObject()
  add(query_580463, "upload_protocol", newJString(uploadProtocol))
  add(query_580463, "fields", newJString(fields))
  add(query_580463, "quotaUser", newJString(quotaUser))
  add(query_580463, "alt", newJString(alt))
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "callback", newJString(callback))
  add(query_580463, "access_token", newJString(accessToken))
  add(query_580463, "uploadType", newJString(uploadType))
  add(query_580463, "key", newJString(key))
  add(path_580462, "appsId", newJString(appsId))
  add(query_580463, "$.xgafv", newJString(Xgafv))
  add(path_580462, "operationsId", newJString(operationsId))
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  result = call_580461.call(path_580462, query_580463, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_580444(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_580445, base: "/",
    url: url_AppengineAppsOperationsGet_580446, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_580464 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesList_580466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesList_580465(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the services in the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Application resource. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580467 = path.getOrDefault("appsId")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "appsId", valid_580467
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
  var valid_580468 = query.getOrDefault("upload_protocol")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "upload_protocol", valid_580468
  var valid_580469 = query.getOrDefault("fields")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "fields", valid_580469
  var valid_580470 = query.getOrDefault("pageToken")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "pageToken", valid_580470
  var valid_580471 = query.getOrDefault("quotaUser")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "quotaUser", valid_580471
  var valid_580472 = query.getOrDefault("alt")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = newJString("json"))
  if valid_580472 != nil:
    section.add "alt", valid_580472
  var valid_580473 = query.getOrDefault("oauth_token")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "oauth_token", valid_580473
  var valid_580474 = query.getOrDefault("callback")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "callback", valid_580474
  var valid_580475 = query.getOrDefault("access_token")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "access_token", valid_580475
  var valid_580476 = query.getOrDefault("uploadType")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "uploadType", valid_580476
  var valid_580477 = query.getOrDefault("key")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "key", valid_580477
  var valid_580478 = query.getOrDefault("$.xgafv")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = newJString("1"))
  if valid_580478 != nil:
    section.add "$.xgafv", valid_580478
  var valid_580479 = query.getOrDefault("pageSize")
  valid_580479 = validateParameter(valid_580479, JInt, required = false, default = nil)
  if valid_580479 != nil:
    section.add "pageSize", valid_580479
  var valid_580480 = query.getOrDefault("prettyPrint")
  valid_580480 = validateParameter(valid_580480, JBool, required = false,
                                 default = newJBool(true))
  if valid_580480 != nil:
    section.add "prettyPrint", valid_580480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580481: Call_AppengineAppsServicesList_580464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_580481.validator(path, query, header, formData, body)
  let scheme = call_580481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580481.url(scheme.get, call_580481.host, call_580481.base,
                         call_580481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580481, url, valid)

proc call*(call_580482: Call_AppengineAppsServicesList_580464; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesList
  ## Lists all the services in the application.
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
  var path_580483 = newJObject()
  var query_580484 = newJObject()
  add(query_580484, "upload_protocol", newJString(uploadProtocol))
  add(query_580484, "fields", newJString(fields))
  add(query_580484, "pageToken", newJString(pageToken))
  add(query_580484, "quotaUser", newJString(quotaUser))
  add(query_580484, "alt", newJString(alt))
  add(query_580484, "oauth_token", newJString(oauthToken))
  add(query_580484, "callback", newJString(callback))
  add(query_580484, "access_token", newJString(accessToken))
  add(query_580484, "uploadType", newJString(uploadType))
  add(query_580484, "key", newJString(key))
  add(path_580483, "appsId", newJString(appsId))
  add(query_580484, "$.xgafv", newJString(Xgafv))
  add(query_580484, "pageSize", newJInt(pageSize))
  add(query_580484, "prettyPrint", newJBool(prettyPrint))
  result = call_580482.call(path_580483, query_580484, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_580464(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_580465, base: "/",
    url: url_AppengineAppsServicesList_580466, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_580485 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesGet_580487(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesGet_580486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current configuration of the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_580488 = path.getOrDefault("servicesId")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "servicesId", valid_580488
  var valid_580489 = path.getOrDefault("appsId")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "appsId", valid_580489
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
  var valid_580490 = query.getOrDefault("upload_protocol")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "upload_protocol", valid_580490
  var valid_580491 = query.getOrDefault("fields")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "fields", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  var valid_580493 = query.getOrDefault("alt")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = newJString("json"))
  if valid_580493 != nil:
    section.add "alt", valid_580493
  var valid_580494 = query.getOrDefault("oauth_token")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "oauth_token", valid_580494
  var valid_580495 = query.getOrDefault("callback")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "callback", valid_580495
  var valid_580496 = query.getOrDefault("access_token")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "access_token", valid_580496
  var valid_580497 = query.getOrDefault("uploadType")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "uploadType", valid_580497
  var valid_580498 = query.getOrDefault("key")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "key", valid_580498
  var valid_580499 = query.getOrDefault("$.xgafv")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = newJString("1"))
  if valid_580499 != nil:
    section.add "$.xgafv", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580501: Call_AppengineAppsServicesGet_580485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_580501.validator(path, query, header, formData, body)
  let scheme = call_580501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580501.url(scheme.get, call_580501.host, call_580501.base,
                         call_580501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580501, url, valid)

proc call*(call_580502: Call_AppengineAppsServicesGet_580485; servicesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesGet
  ## Gets the current configuration of the specified service.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580503 = newJObject()
  var query_580504 = newJObject()
  add(query_580504, "upload_protocol", newJString(uploadProtocol))
  add(query_580504, "fields", newJString(fields))
  add(query_580504, "quotaUser", newJString(quotaUser))
  add(query_580504, "alt", newJString(alt))
  add(query_580504, "oauth_token", newJString(oauthToken))
  add(query_580504, "callback", newJString(callback))
  add(query_580504, "access_token", newJString(accessToken))
  add(query_580504, "uploadType", newJString(uploadType))
  add(path_580503, "servicesId", newJString(servicesId))
  add(query_580504, "key", newJString(key))
  add(path_580503, "appsId", newJString(appsId))
  add(query_580504, "$.xgafv", newJString(Xgafv))
  add(query_580504, "prettyPrint", newJBool(prettyPrint))
  result = call_580502.call(path_580503, query_580504, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_580485(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_580486, base: "/",
    url: url_AppengineAppsServicesGet_580487, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_580525 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesPatch_580527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesPatch_580526(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the configuration of the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_580528 = path.getOrDefault("servicesId")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "servicesId", valid_580528
  var valid_580529 = path.getOrDefault("appsId")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "appsId", valid_580529
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
  ##             : Standard field mask for the set of fields to be updated.
  ##   migrateTraffic: JBool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  section = newJObject()
  var valid_580530 = query.getOrDefault("upload_protocol")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "upload_protocol", valid_580530
  var valid_580531 = query.getOrDefault("fields")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "fields", valid_580531
  var valid_580532 = query.getOrDefault("quotaUser")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "quotaUser", valid_580532
  var valid_580533 = query.getOrDefault("alt")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = newJString("json"))
  if valid_580533 != nil:
    section.add "alt", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("callback")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "callback", valid_580535
  var valid_580536 = query.getOrDefault("access_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "access_token", valid_580536
  var valid_580537 = query.getOrDefault("uploadType")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "uploadType", valid_580537
  var valid_580538 = query.getOrDefault("key")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "key", valid_580538
  var valid_580539 = query.getOrDefault("$.xgafv")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = newJString("1"))
  if valid_580539 != nil:
    section.add "$.xgafv", valid_580539
  var valid_580540 = query.getOrDefault("prettyPrint")
  valid_580540 = validateParameter(valid_580540, JBool, required = false,
                                 default = newJBool(true))
  if valid_580540 != nil:
    section.add "prettyPrint", valid_580540
  var valid_580541 = query.getOrDefault("updateMask")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "updateMask", valid_580541
  var valid_580542 = query.getOrDefault("migrateTraffic")
  valid_580542 = validateParameter(valid_580542, JBool, required = false, default = nil)
  if valid_580542 != nil:
    section.add "migrateTraffic", valid_580542
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

proc call*(call_580544: Call_AppengineAppsServicesPatch_580525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_580544.validator(path, query, header, formData, body)
  let scheme = call_580544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580544.url(scheme.get, call_580544.host, call_580544.base,
                         call_580544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580544, url, valid)

proc call*(call_580545: Call_AppengineAppsServicesPatch_580525; servicesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = "";
          migrateTraffic: bool = false): Recallable =
  ## appengineAppsServicesPatch
  ## Updates the configuration of the specified service.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   migrateTraffic: bool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  var path_580546 = newJObject()
  var query_580547 = newJObject()
  var body_580548 = newJObject()
  add(query_580547, "upload_protocol", newJString(uploadProtocol))
  add(query_580547, "fields", newJString(fields))
  add(query_580547, "quotaUser", newJString(quotaUser))
  add(query_580547, "alt", newJString(alt))
  add(query_580547, "oauth_token", newJString(oauthToken))
  add(query_580547, "callback", newJString(callback))
  add(query_580547, "access_token", newJString(accessToken))
  add(query_580547, "uploadType", newJString(uploadType))
  add(path_580546, "servicesId", newJString(servicesId))
  add(query_580547, "key", newJString(key))
  add(path_580546, "appsId", newJString(appsId))
  add(query_580547, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580548 = body
  add(query_580547, "prettyPrint", newJBool(prettyPrint))
  add(query_580547, "updateMask", newJString(updateMask))
  add(query_580547, "migrateTraffic", newJBool(migrateTraffic))
  result = call_580545.call(path_580546, query_580547, nil, nil, body_580548)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_580525(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_580526, base: "/",
    url: url_AppengineAppsServicesPatch_580527, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_580505 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesDelete_580507(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesDelete_580506(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified service and all enclosed versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_580508 = path.getOrDefault("servicesId")
  valid_580508 = validateParameter(valid_580508, JString, required = true,
                                 default = nil)
  if valid_580508 != nil:
    section.add "servicesId", valid_580508
  var valid_580509 = path.getOrDefault("appsId")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "appsId", valid_580509
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
  var valid_580510 = query.getOrDefault("upload_protocol")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "upload_protocol", valid_580510
  var valid_580511 = query.getOrDefault("fields")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "fields", valid_580511
  var valid_580512 = query.getOrDefault("quotaUser")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "quotaUser", valid_580512
  var valid_580513 = query.getOrDefault("alt")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = newJString("json"))
  if valid_580513 != nil:
    section.add "alt", valid_580513
  var valid_580514 = query.getOrDefault("oauth_token")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "oauth_token", valid_580514
  var valid_580515 = query.getOrDefault("callback")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "callback", valid_580515
  var valid_580516 = query.getOrDefault("access_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "access_token", valid_580516
  var valid_580517 = query.getOrDefault("uploadType")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "uploadType", valid_580517
  var valid_580518 = query.getOrDefault("key")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "key", valid_580518
  var valid_580519 = query.getOrDefault("$.xgafv")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("1"))
  if valid_580519 != nil:
    section.add "$.xgafv", valid_580519
  var valid_580520 = query.getOrDefault("prettyPrint")
  valid_580520 = validateParameter(valid_580520, JBool, required = false,
                                 default = newJBool(true))
  if valid_580520 != nil:
    section.add "prettyPrint", valid_580520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580521: Call_AppengineAppsServicesDelete_580505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_580521.validator(path, query, header, formData, body)
  let scheme = call_580521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580521.url(scheme.get, call_580521.host, call_580521.base,
                         call_580521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580521, url, valid)

proc call*(call_580522: Call_AppengineAppsServicesDelete_580505;
          servicesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesDelete
  ## Deletes the specified service and all enclosed versions.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580523 = newJObject()
  var query_580524 = newJObject()
  add(query_580524, "upload_protocol", newJString(uploadProtocol))
  add(query_580524, "fields", newJString(fields))
  add(query_580524, "quotaUser", newJString(quotaUser))
  add(query_580524, "alt", newJString(alt))
  add(query_580524, "oauth_token", newJString(oauthToken))
  add(query_580524, "callback", newJString(callback))
  add(query_580524, "access_token", newJString(accessToken))
  add(query_580524, "uploadType", newJString(uploadType))
  add(path_580523, "servicesId", newJString(servicesId))
  add(query_580524, "key", newJString(key))
  add(path_580523, "appsId", newJString(appsId))
  add(query_580524, "$.xgafv", newJString(Xgafv))
  add(query_580524, "prettyPrint", newJBool(prettyPrint))
  result = call_580522.call(path_580523, query_580524, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_580505(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_580506, base: "/",
    url: url_AppengineAppsServicesDelete_580507, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_580572 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsCreate_580574(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsCreate_580573(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deploys code and resource files to a new version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent resource to create this version under. Example: apps/myapp/services/default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_580575 = path.getOrDefault("servicesId")
  valid_580575 = validateParameter(valid_580575, JString, required = true,
                                 default = nil)
  if valid_580575 != nil:
    section.add "servicesId", valid_580575
  var valid_580576 = path.getOrDefault("appsId")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = nil)
  if valid_580576 != nil:
    section.add "appsId", valid_580576
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
  var valid_580577 = query.getOrDefault("upload_protocol")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "upload_protocol", valid_580577
  var valid_580578 = query.getOrDefault("fields")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "fields", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  var valid_580580 = query.getOrDefault("alt")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = newJString("json"))
  if valid_580580 != nil:
    section.add "alt", valid_580580
  var valid_580581 = query.getOrDefault("oauth_token")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "oauth_token", valid_580581
  var valid_580582 = query.getOrDefault("callback")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "callback", valid_580582
  var valid_580583 = query.getOrDefault("access_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "access_token", valid_580583
  var valid_580584 = query.getOrDefault("uploadType")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "uploadType", valid_580584
  var valid_580585 = query.getOrDefault("key")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "key", valid_580585
  var valid_580586 = query.getOrDefault("$.xgafv")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("1"))
  if valid_580586 != nil:
    section.add "$.xgafv", valid_580586
  var valid_580587 = query.getOrDefault("prettyPrint")
  valid_580587 = validateParameter(valid_580587, JBool, required = false,
                                 default = newJBool(true))
  if valid_580587 != nil:
    section.add "prettyPrint", valid_580587
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

proc call*(call_580589: Call_AppengineAppsServicesVersionsCreate_580572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_580589.validator(path, query, header, formData, body)
  let scheme = call_580589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580589.url(scheme.get, call_580589.host, call_580589.base,
                         call_580589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580589, url, valid)

proc call*(call_580590: Call_AppengineAppsServicesVersionsCreate_580572;
          servicesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsCreate
  ## Deploys code and resource files to a new version.
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
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent resource to create this version under. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580591 = newJObject()
  var query_580592 = newJObject()
  var body_580593 = newJObject()
  add(query_580592, "upload_protocol", newJString(uploadProtocol))
  add(query_580592, "fields", newJString(fields))
  add(query_580592, "quotaUser", newJString(quotaUser))
  add(query_580592, "alt", newJString(alt))
  add(query_580592, "oauth_token", newJString(oauthToken))
  add(query_580592, "callback", newJString(callback))
  add(query_580592, "access_token", newJString(accessToken))
  add(query_580592, "uploadType", newJString(uploadType))
  add(path_580591, "servicesId", newJString(servicesId))
  add(query_580592, "key", newJString(key))
  add(path_580591, "appsId", newJString(appsId))
  add(query_580592, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580593 = body
  add(query_580592, "prettyPrint", newJBool(prettyPrint))
  result = call_580590.call(path_580591, query_580592, nil, nil, body_580593)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_580572(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_580573, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_580574, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_580549 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsList_580551(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsList_580550(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the versions of a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Service resource. Example: apps/myapp/services/default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_580552 = path.getOrDefault("servicesId")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "servicesId", valid_580552
  var valid_580553 = path.getOrDefault("appsId")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "appsId", valid_580553
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
  ##       : Controls the set of fields returned in the List response.
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
  var valid_580554 = query.getOrDefault("upload_protocol")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "upload_protocol", valid_580554
  var valid_580555 = query.getOrDefault("fields")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "fields", valid_580555
  var valid_580556 = query.getOrDefault("pageToken")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "pageToken", valid_580556
  var valid_580557 = query.getOrDefault("quotaUser")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "quotaUser", valid_580557
  var valid_580558 = query.getOrDefault("view")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580558 != nil:
    section.add "view", valid_580558
  var valid_580559 = query.getOrDefault("alt")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = newJString("json"))
  if valid_580559 != nil:
    section.add "alt", valid_580559
  var valid_580560 = query.getOrDefault("oauth_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "oauth_token", valid_580560
  var valid_580561 = query.getOrDefault("callback")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "callback", valid_580561
  var valid_580562 = query.getOrDefault("access_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "access_token", valid_580562
  var valid_580563 = query.getOrDefault("uploadType")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "uploadType", valid_580563
  var valid_580564 = query.getOrDefault("key")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "key", valid_580564
  var valid_580565 = query.getOrDefault("$.xgafv")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = newJString("1"))
  if valid_580565 != nil:
    section.add "$.xgafv", valid_580565
  var valid_580566 = query.getOrDefault("pageSize")
  valid_580566 = validateParameter(valid_580566, JInt, required = false, default = nil)
  if valid_580566 != nil:
    section.add "pageSize", valid_580566
  var valid_580567 = query.getOrDefault("prettyPrint")
  valid_580567 = validateParameter(valid_580567, JBool, required = false,
                                 default = newJBool(true))
  if valid_580567 != nil:
    section.add "prettyPrint", valid_580567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580568: Call_AppengineAppsServicesVersionsList_580549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_580568.validator(path, query, header, formData, body)
  let scheme = call_580568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580568.url(scheme.get, call_580568.host, call_580568.base,
                         call_580568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580568, url, valid)

proc call*(call_580569: Call_AppengineAppsServicesVersionsList_580549;
          servicesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "BASIC"; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsList
  ## Lists the versions of a service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Controls the set of fields returned in the List response.
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
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Service resource. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580570 = newJObject()
  var query_580571 = newJObject()
  add(query_580571, "upload_protocol", newJString(uploadProtocol))
  add(query_580571, "fields", newJString(fields))
  add(query_580571, "pageToken", newJString(pageToken))
  add(query_580571, "quotaUser", newJString(quotaUser))
  add(query_580571, "view", newJString(view))
  add(query_580571, "alt", newJString(alt))
  add(query_580571, "oauth_token", newJString(oauthToken))
  add(query_580571, "callback", newJString(callback))
  add(query_580571, "access_token", newJString(accessToken))
  add(query_580571, "uploadType", newJString(uploadType))
  add(path_580570, "servicesId", newJString(servicesId))
  add(query_580571, "key", newJString(key))
  add(path_580570, "appsId", newJString(appsId))
  add(query_580571, "$.xgafv", newJString(Xgafv))
  add(query_580571, "pageSize", newJInt(pageSize))
  add(query_580571, "prettyPrint", newJBool(prettyPrint))
  result = call_580569.call(path_580570, query_580571, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_580549(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_580550, base: "/",
    url: url_AppengineAppsServicesVersionsList_580551, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_580594 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsGet_580596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsGet_580595(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580597 = path.getOrDefault("versionsId")
  valid_580597 = validateParameter(valid_580597, JString, required = true,
                                 default = nil)
  if valid_580597 != nil:
    section.add "versionsId", valid_580597
  var valid_580598 = path.getOrDefault("servicesId")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "servicesId", valid_580598
  var valid_580599 = path.getOrDefault("appsId")
  valid_580599 = validateParameter(valid_580599, JString, required = true,
                                 default = nil)
  if valid_580599 != nil:
    section.add "appsId", valid_580599
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Controls the set of fields returned in the Get response.
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
  var valid_580600 = query.getOrDefault("upload_protocol")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "upload_protocol", valid_580600
  var valid_580601 = query.getOrDefault("fields")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "fields", valid_580601
  var valid_580602 = query.getOrDefault("view")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580602 != nil:
    section.add "view", valid_580602
  var valid_580603 = query.getOrDefault("quotaUser")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "quotaUser", valid_580603
  var valid_580604 = query.getOrDefault("alt")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = newJString("json"))
  if valid_580604 != nil:
    section.add "alt", valid_580604
  var valid_580605 = query.getOrDefault("oauth_token")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "oauth_token", valid_580605
  var valid_580606 = query.getOrDefault("callback")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "callback", valid_580606
  var valid_580607 = query.getOrDefault("access_token")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "access_token", valid_580607
  var valid_580608 = query.getOrDefault("uploadType")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "uploadType", valid_580608
  var valid_580609 = query.getOrDefault("key")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "key", valid_580609
  var valid_580610 = query.getOrDefault("$.xgafv")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = newJString("1"))
  if valid_580610 != nil:
    section.add "$.xgafv", valid_580610
  var valid_580611 = query.getOrDefault("prettyPrint")
  valid_580611 = validateParameter(valid_580611, JBool, required = false,
                                 default = newJBool(true))
  if valid_580611 != nil:
    section.add "prettyPrint", valid_580611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580612: Call_AppengineAppsServicesVersionsGet_580594;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_580612.validator(path, query, header, formData, body)
  let scheme = call_580612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580612.url(scheme.get, call_580612.host, call_580612.base,
                         call_580612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580612, url, valid)

proc call*(call_580613: Call_AppengineAppsServicesVersionsGet_580594;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsGet
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Controls the set of fields returned in the Get response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580614 = newJObject()
  var query_580615 = newJObject()
  add(query_580615, "upload_protocol", newJString(uploadProtocol))
  add(query_580615, "fields", newJString(fields))
  add(query_580615, "view", newJString(view))
  add(query_580615, "quotaUser", newJString(quotaUser))
  add(path_580614, "versionsId", newJString(versionsId))
  add(query_580615, "alt", newJString(alt))
  add(query_580615, "oauth_token", newJString(oauthToken))
  add(query_580615, "callback", newJString(callback))
  add(query_580615, "access_token", newJString(accessToken))
  add(query_580615, "uploadType", newJString(uploadType))
  add(path_580614, "servicesId", newJString(servicesId))
  add(query_580615, "key", newJString(key))
  add(path_580614, "appsId", newJString(appsId))
  add(query_580615, "$.xgafv", newJString(Xgafv))
  add(query_580615, "prettyPrint", newJBool(prettyPrint))
  result = call_580613.call(path_580614, query_580615, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_580594(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_580595, base: "/",
    url: url_AppengineAppsServicesVersionsGet_580596, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_580637 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsPatch_580639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsPatch_580638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default/versions/1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580640 = path.getOrDefault("versionsId")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = nil)
  if valid_580640 != nil:
    section.add "versionsId", valid_580640
  var valid_580641 = path.getOrDefault("servicesId")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "servicesId", valid_580641
  var valid_580642 = path.getOrDefault("appsId")
  valid_580642 = validateParameter(valid_580642, JString, required = true,
                                 default = nil)
  if valid_580642 != nil:
    section.add "appsId", valid_580642
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
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_580643 = query.getOrDefault("upload_protocol")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "upload_protocol", valid_580643
  var valid_580644 = query.getOrDefault("fields")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "fields", valid_580644
  var valid_580645 = query.getOrDefault("quotaUser")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "quotaUser", valid_580645
  var valid_580646 = query.getOrDefault("alt")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = newJString("json"))
  if valid_580646 != nil:
    section.add "alt", valid_580646
  var valid_580647 = query.getOrDefault("oauth_token")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "oauth_token", valid_580647
  var valid_580648 = query.getOrDefault("callback")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "callback", valid_580648
  var valid_580649 = query.getOrDefault("access_token")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "access_token", valid_580649
  var valid_580650 = query.getOrDefault("uploadType")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "uploadType", valid_580650
  var valid_580651 = query.getOrDefault("key")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "key", valid_580651
  var valid_580652 = query.getOrDefault("$.xgafv")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = newJString("1"))
  if valid_580652 != nil:
    section.add "$.xgafv", valid_580652
  var valid_580653 = query.getOrDefault("prettyPrint")
  valid_580653 = validateParameter(valid_580653, JBool, required = false,
                                 default = newJBool(true))
  if valid_580653 != nil:
    section.add "prettyPrint", valid_580653
  var valid_580654 = query.getOrDefault("updateMask")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "updateMask", valid_580654
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

proc call*(call_580656: Call_AppengineAppsServicesVersionsPatch_580637;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## 
  let valid = call_580656.validator(path, query, header, formData, body)
  let scheme = call_580656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580656.url(scheme.get, call_580656.host, call_580656.base,
                         call_580656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580656, url, valid)

proc call*(call_580657: Call_AppengineAppsServicesVersionsPatch_580637;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## appengineAppsServicesVersionsPatch
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#Version.FIELDS.automatic_scaling)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default/versions/1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_580658 = newJObject()
  var query_580659 = newJObject()
  var body_580660 = newJObject()
  add(query_580659, "upload_protocol", newJString(uploadProtocol))
  add(query_580659, "fields", newJString(fields))
  add(query_580659, "quotaUser", newJString(quotaUser))
  add(path_580658, "versionsId", newJString(versionsId))
  add(query_580659, "alt", newJString(alt))
  add(query_580659, "oauth_token", newJString(oauthToken))
  add(query_580659, "callback", newJString(callback))
  add(query_580659, "access_token", newJString(accessToken))
  add(query_580659, "uploadType", newJString(uploadType))
  add(path_580658, "servicesId", newJString(servicesId))
  add(query_580659, "key", newJString(key))
  add(path_580658, "appsId", newJString(appsId))
  add(query_580659, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580660 = body
  add(query_580659, "prettyPrint", newJBool(prettyPrint))
  add(query_580659, "updateMask", newJString(updateMask))
  result = call_580657.call(path_580658, query_580659, nil, nil, body_580660)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_580637(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_580638, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_580639, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_580616 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsDelete_580618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsDelete_580617(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580619 = path.getOrDefault("versionsId")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "versionsId", valid_580619
  var valid_580620 = path.getOrDefault("servicesId")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "servicesId", valid_580620
  var valid_580621 = path.getOrDefault("appsId")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "appsId", valid_580621
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
  var valid_580622 = query.getOrDefault("upload_protocol")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "upload_protocol", valid_580622
  var valid_580623 = query.getOrDefault("fields")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "fields", valid_580623
  var valid_580624 = query.getOrDefault("quotaUser")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "quotaUser", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("oauth_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "oauth_token", valid_580626
  var valid_580627 = query.getOrDefault("callback")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "callback", valid_580627
  var valid_580628 = query.getOrDefault("access_token")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "access_token", valid_580628
  var valid_580629 = query.getOrDefault("uploadType")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "uploadType", valid_580629
  var valid_580630 = query.getOrDefault("key")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "key", valid_580630
  var valid_580631 = query.getOrDefault("$.xgafv")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = newJString("1"))
  if valid_580631 != nil:
    section.add "$.xgafv", valid_580631
  var valid_580632 = query.getOrDefault("prettyPrint")
  valid_580632 = validateParameter(valid_580632, JBool, required = false,
                                 default = newJBool(true))
  if valid_580632 != nil:
    section.add "prettyPrint", valid_580632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580633: Call_AppengineAppsServicesVersionsDelete_580616;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Version resource.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_AppengineAppsServicesVersionsDelete_580616;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsDelete
  ## Deletes an existing Version resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
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
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  add(query_580636, "upload_protocol", newJString(uploadProtocol))
  add(query_580636, "fields", newJString(fields))
  add(query_580636, "quotaUser", newJString(quotaUser))
  add(path_580635, "versionsId", newJString(versionsId))
  add(query_580636, "alt", newJString(alt))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "callback", newJString(callback))
  add(query_580636, "access_token", newJString(accessToken))
  add(query_580636, "uploadType", newJString(uploadType))
  add(path_580635, "servicesId", newJString(servicesId))
  add(query_580636, "key", newJString(key))
  add(path_580635, "appsId", newJString(appsId))
  add(query_580636, "$.xgafv", newJString(Xgafv))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  result = call_580634.call(path_580635, query_580636, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_580616(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_580617, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_580618, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_580661 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsInstancesList_580663(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsInstancesList_580662(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Version resource. Example: apps/myapp/services/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580664 = path.getOrDefault("versionsId")
  valid_580664 = validateParameter(valid_580664, JString, required = true,
                                 default = nil)
  if valid_580664 != nil:
    section.add "versionsId", valid_580664
  var valid_580665 = path.getOrDefault("servicesId")
  valid_580665 = validateParameter(valid_580665, JString, required = true,
                                 default = nil)
  if valid_580665 != nil:
    section.add "servicesId", valid_580665
  var valid_580666 = path.getOrDefault("appsId")
  valid_580666 = validateParameter(valid_580666, JString, required = true,
                                 default = nil)
  if valid_580666 != nil:
    section.add "appsId", valid_580666
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
  var valid_580667 = query.getOrDefault("upload_protocol")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "upload_protocol", valid_580667
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
  var valid_580669 = query.getOrDefault("pageToken")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "pageToken", valid_580669
  var valid_580670 = query.getOrDefault("quotaUser")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "quotaUser", valid_580670
  var valid_580671 = query.getOrDefault("alt")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("json"))
  if valid_580671 != nil:
    section.add "alt", valid_580671
  var valid_580672 = query.getOrDefault("oauth_token")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "oauth_token", valid_580672
  var valid_580673 = query.getOrDefault("callback")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "callback", valid_580673
  var valid_580674 = query.getOrDefault("access_token")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "access_token", valid_580674
  var valid_580675 = query.getOrDefault("uploadType")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "uploadType", valid_580675
  var valid_580676 = query.getOrDefault("key")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "key", valid_580676
  var valid_580677 = query.getOrDefault("$.xgafv")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = newJString("1"))
  if valid_580677 != nil:
    section.add "$.xgafv", valid_580677
  var valid_580678 = query.getOrDefault("pageSize")
  valid_580678 = validateParameter(valid_580678, JInt, required = false, default = nil)
  if valid_580678 != nil:
    section.add "pageSize", valid_580678
  var valid_580679 = query.getOrDefault("prettyPrint")
  valid_580679 = validateParameter(valid_580679, JBool, required = false,
                                 default = newJBool(true))
  if valid_580679 != nil:
    section.add "prettyPrint", valid_580679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580680: Call_AppengineAppsServicesVersionsInstancesList_580661;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_580680.validator(path, query, header, formData, body)
  let scheme = call_580680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580680.url(scheme.get, call_580680.host, call_580680.base,
                         call_580680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580680, url, valid)

proc call*(call_580681: Call_AppengineAppsServicesVersionsInstancesList_580661;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsInstancesList
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
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
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Version resource. Example: apps/myapp/services/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580682 = newJObject()
  var query_580683 = newJObject()
  add(query_580683, "upload_protocol", newJString(uploadProtocol))
  add(query_580683, "fields", newJString(fields))
  add(query_580683, "pageToken", newJString(pageToken))
  add(query_580683, "quotaUser", newJString(quotaUser))
  add(path_580682, "versionsId", newJString(versionsId))
  add(query_580683, "alt", newJString(alt))
  add(query_580683, "oauth_token", newJString(oauthToken))
  add(query_580683, "callback", newJString(callback))
  add(query_580683, "access_token", newJString(accessToken))
  add(query_580683, "uploadType", newJString(uploadType))
  add(path_580682, "servicesId", newJString(servicesId))
  add(query_580683, "key", newJString(key))
  add(path_580682, "appsId", newJString(appsId))
  add(query_580683, "$.xgafv", newJString(Xgafv))
  add(query_580683, "pageSize", newJInt(pageSize))
  add(query_580683, "prettyPrint", newJBool(prettyPrint))
  result = call_580681.call(path_580682, query_580683, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_580661(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_580662,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_580663,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_580684 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsInstancesGet_580686(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsInstancesGet_580685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets instance information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580687 = path.getOrDefault("versionsId")
  valid_580687 = validateParameter(valid_580687, JString, required = true,
                                 default = nil)
  if valid_580687 != nil:
    section.add "versionsId", valid_580687
  var valid_580688 = path.getOrDefault("instancesId")
  valid_580688 = validateParameter(valid_580688, JString, required = true,
                                 default = nil)
  if valid_580688 != nil:
    section.add "instancesId", valid_580688
  var valid_580689 = path.getOrDefault("servicesId")
  valid_580689 = validateParameter(valid_580689, JString, required = true,
                                 default = nil)
  if valid_580689 != nil:
    section.add "servicesId", valid_580689
  var valid_580690 = path.getOrDefault("appsId")
  valid_580690 = validateParameter(valid_580690, JString, required = true,
                                 default = nil)
  if valid_580690 != nil:
    section.add "appsId", valid_580690
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
  var valid_580691 = query.getOrDefault("upload_protocol")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "upload_protocol", valid_580691
  var valid_580692 = query.getOrDefault("fields")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "fields", valid_580692
  var valid_580693 = query.getOrDefault("quotaUser")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "quotaUser", valid_580693
  var valid_580694 = query.getOrDefault("alt")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = newJString("json"))
  if valid_580694 != nil:
    section.add "alt", valid_580694
  var valid_580695 = query.getOrDefault("oauth_token")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "oauth_token", valid_580695
  var valid_580696 = query.getOrDefault("callback")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "callback", valid_580696
  var valid_580697 = query.getOrDefault("access_token")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "access_token", valid_580697
  var valid_580698 = query.getOrDefault("uploadType")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "uploadType", valid_580698
  var valid_580699 = query.getOrDefault("key")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "key", valid_580699
  var valid_580700 = query.getOrDefault("$.xgafv")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = newJString("1"))
  if valid_580700 != nil:
    section.add "$.xgafv", valid_580700
  var valid_580701 = query.getOrDefault("prettyPrint")
  valid_580701 = validateParameter(valid_580701, JBool, required = false,
                                 default = newJBool(true))
  if valid_580701 != nil:
    section.add "prettyPrint", valid_580701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580702: Call_AppengineAppsServicesVersionsInstancesGet_580684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_580702.validator(path, query, header, formData, body)
  let scheme = call_580702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580702.url(scheme.get, call_580702.host, call_580702.base,
                         call_580702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580702, url, valid)

proc call*(call_580703: Call_AppengineAppsServicesVersionsInstancesGet_580684;
          versionsId: string; instancesId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsInstancesGet
  ## Gets instance information.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580704 = newJObject()
  var query_580705 = newJObject()
  add(query_580705, "upload_protocol", newJString(uploadProtocol))
  add(query_580705, "fields", newJString(fields))
  add(query_580705, "quotaUser", newJString(quotaUser))
  add(path_580704, "versionsId", newJString(versionsId))
  add(query_580705, "alt", newJString(alt))
  add(path_580704, "instancesId", newJString(instancesId))
  add(query_580705, "oauth_token", newJString(oauthToken))
  add(query_580705, "callback", newJString(callback))
  add(query_580705, "access_token", newJString(accessToken))
  add(query_580705, "uploadType", newJString(uploadType))
  add(path_580704, "servicesId", newJString(servicesId))
  add(query_580705, "key", newJString(key))
  add(path_580704, "appsId", newJString(appsId))
  add(query_580705, "$.xgafv", newJString(Xgafv))
  add(query_580705, "prettyPrint", newJBool(prettyPrint))
  result = call_580703.call(path_580704, query_580705, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_580684(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_580685,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_580686,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_580706 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsInstancesDelete_580708(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsInstancesDelete_580707(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a running instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580709 = path.getOrDefault("versionsId")
  valid_580709 = validateParameter(valid_580709, JString, required = true,
                                 default = nil)
  if valid_580709 != nil:
    section.add "versionsId", valid_580709
  var valid_580710 = path.getOrDefault("instancesId")
  valid_580710 = validateParameter(valid_580710, JString, required = true,
                                 default = nil)
  if valid_580710 != nil:
    section.add "instancesId", valid_580710
  var valid_580711 = path.getOrDefault("servicesId")
  valid_580711 = validateParameter(valid_580711, JString, required = true,
                                 default = nil)
  if valid_580711 != nil:
    section.add "servicesId", valid_580711
  var valid_580712 = path.getOrDefault("appsId")
  valid_580712 = validateParameter(valid_580712, JString, required = true,
                                 default = nil)
  if valid_580712 != nil:
    section.add "appsId", valid_580712
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
  var valid_580713 = query.getOrDefault("upload_protocol")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "upload_protocol", valid_580713
  var valid_580714 = query.getOrDefault("fields")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "fields", valid_580714
  var valid_580715 = query.getOrDefault("quotaUser")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "quotaUser", valid_580715
  var valid_580716 = query.getOrDefault("alt")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = newJString("json"))
  if valid_580716 != nil:
    section.add "alt", valid_580716
  var valid_580717 = query.getOrDefault("oauth_token")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "oauth_token", valid_580717
  var valid_580718 = query.getOrDefault("callback")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "callback", valid_580718
  var valid_580719 = query.getOrDefault("access_token")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "access_token", valid_580719
  var valid_580720 = query.getOrDefault("uploadType")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "uploadType", valid_580720
  var valid_580721 = query.getOrDefault("key")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "key", valid_580721
  var valid_580722 = query.getOrDefault("$.xgafv")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = newJString("1"))
  if valid_580722 != nil:
    section.add "$.xgafv", valid_580722
  var valid_580723 = query.getOrDefault("prettyPrint")
  valid_580723 = validateParameter(valid_580723, JBool, required = false,
                                 default = newJBool(true))
  if valid_580723 != nil:
    section.add "prettyPrint", valid_580723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580724: Call_AppengineAppsServicesVersionsInstancesDelete_580706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_580724.validator(path, query, header, formData, body)
  let scheme = call_580724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580724.url(scheme.get, call_580724.host, call_580724.base,
                         call_580724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580724, url, valid)

proc call*(call_580725: Call_AppengineAppsServicesVersionsInstancesDelete_580706;
          versionsId: string; instancesId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsInstancesDelete
  ## Stops a running instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580726 = newJObject()
  var query_580727 = newJObject()
  add(query_580727, "upload_protocol", newJString(uploadProtocol))
  add(query_580727, "fields", newJString(fields))
  add(query_580727, "quotaUser", newJString(quotaUser))
  add(path_580726, "versionsId", newJString(versionsId))
  add(query_580727, "alt", newJString(alt))
  add(path_580726, "instancesId", newJString(instancesId))
  add(query_580727, "oauth_token", newJString(oauthToken))
  add(query_580727, "callback", newJString(callback))
  add(query_580727, "access_token", newJString(accessToken))
  add(query_580727, "uploadType", newJString(uploadType))
  add(path_580726, "servicesId", newJString(servicesId))
  add(query_580727, "key", newJString(key))
  add(path_580726, "appsId", newJString(appsId))
  add(query_580727, "$.xgafv", newJString(Xgafv))
  add(query_580727, "prettyPrint", newJBool(prettyPrint))
  result = call_580725.call(path_580726, query_580727, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_580706(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_580707,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_580708,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_580728 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsServicesVersionsInstancesDebug_580730(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId"),
               (kind: ConstantSegment, value: ":debug")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsInstancesDebug_580729(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580731 = path.getOrDefault("versionsId")
  valid_580731 = validateParameter(valid_580731, JString, required = true,
                                 default = nil)
  if valid_580731 != nil:
    section.add "versionsId", valid_580731
  var valid_580732 = path.getOrDefault("instancesId")
  valid_580732 = validateParameter(valid_580732, JString, required = true,
                                 default = nil)
  if valid_580732 != nil:
    section.add "instancesId", valid_580732
  var valid_580733 = path.getOrDefault("servicesId")
  valid_580733 = validateParameter(valid_580733, JString, required = true,
                                 default = nil)
  if valid_580733 != nil:
    section.add "servicesId", valid_580733
  var valid_580734 = path.getOrDefault("appsId")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "appsId", valid_580734
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
  var valid_580735 = query.getOrDefault("upload_protocol")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "upload_protocol", valid_580735
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  var valid_580737 = query.getOrDefault("quotaUser")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "quotaUser", valid_580737
  var valid_580738 = query.getOrDefault("alt")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = newJString("json"))
  if valid_580738 != nil:
    section.add "alt", valid_580738
  var valid_580739 = query.getOrDefault("oauth_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "oauth_token", valid_580739
  var valid_580740 = query.getOrDefault("callback")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "callback", valid_580740
  var valid_580741 = query.getOrDefault("access_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "access_token", valid_580741
  var valid_580742 = query.getOrDefault("uploadType")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "uploadType", valid_580742
  var valid_580743 = query.getOrDefault("key")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "key", valid_580743
  var valid_580744 = query.getOrDefault("$.xgafv")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = newJString("1"))
  if valid_580744 != nil:
    section.add "$.xgafv", valid_580744
  var valid_580745 = query.getOrDefault("prettyPrint")
  valid_580745 = validateParameter(valid_580745, JBool, required = false,
                                 default = newJBool(true))
  if valid_580745 != nil:
    section.add "prettyPrint", valid_580745
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

proc call*(call_580747: Call_AppengineAppsServicesVersionsInstancesDebug_580728;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_AppengineAppsServicesVersionsInstancesDebug_580728;
          versionsId: string; instancesId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsInstancesDebug
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  var body_580751 = newJObject()
  add(query_580750, "upload_protocol", newJString(uploadProtocol))
  add(query_580750, "fields", newJString(fields))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(path_580749, "versionsId", newJString(versionsId))
  add(query_580750, "alt", newJString(alt))
  add(path_580749, "instancesId", newJString(instancesId))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "callback", newJString(callback))
  add(query_580750, "access_token", newJString(accessToken))
  add(query_580750, "uploadType", newJString(uploadType))
  add(path_580749, "servicesId", newJString(servicesId))
  add(query_580750, "key", newJString(key))
  add(path_580749, "appsId", newJString(appsId))
  add(query_580750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580751 = body
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  result = call_580748.call(path_580749, query_580750, nil, nil, body_580751)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_580728(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_580729,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_580730,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsRepair_580752 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsRepair_580754(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: ":repair")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsRepair_580753(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the application to repair. Example: apps/myapp
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580755 = path.getOrDefault("appsId")
  valid_580755 = validateParameter(valid_580755, JString, required = true,
                                 default = nil)
  if valid_580755 != nil:
    section.add "appsId", valid_580755
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
  var valid_580756 = query.getOrDefault("upload_protocol")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "upload_protocol", valid_580756
  var valid_580757 = query.getOrDefault("fields")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "fields", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("alt")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = newJString("json"))
  if valid_580759 != nil:
    section.add "alt", valid_580759
  var valid_580760 = query.getOrDefault("oauth_token")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "oauth_token", valid_580760
  var valid_580761 = query.getOrDefault("callback")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "callback", valid_580761
  var valid_580762 = query.getOrDefault("access_token")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "access_token", valid_580762
  var valid_580763 = query.getOrDefault("uploadType")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "uploadType", valid_580763
  var valid_580764 = query.getOrDefault("key")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "key", valid_580764
  var valid_580765 = query.getOrDefault("$.xgafv")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = newJString("1"))
  if valid_580765 != nil:
    section.add "$.xgafv", valid_580765
  var valid_580766 = query.getOrDefault("prettyPrint")
  valid_580766 = validateParameter(valid_580766, JBool, required = false,
                                 default = newJBool(true))
  if valid_580766 != nil:
    section.add "prettyPrint", valid_580766
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

proc call*(call_580768: Call_AppengineAppsRepair_580752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_AppengineAppsRepair_580752; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsRepair
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
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
  ##         : Part of `name`. Name of the application to repair. Example: apps/myapp
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  var body_580772 = newJObject()
  add(query_580771, "upload_protocol", newJString(uploadProtocol))
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "callback", newJString(callback))
  add(query_580771, "access_token", newJString(accessToken))
  add(query_580771, "uploadType", newJString(uploadType))
  add(query_580771, "key", newJString(key))
  add(path_580770, "appsId", newJString(appsId))
  add(query_580771, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580772 = body
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  result = call_580769.call(path_580770, query_580771, nil, nil, body_580772)

var appengineAppsRepair* = Call_AppengineAppsRepair_580752(
    name: "appengineAppsRepair", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}:repair",
    validator: validate_AppengineAppsRepair_580753, base: "/",
    url: url_AppengineAppsRepair_580754, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
