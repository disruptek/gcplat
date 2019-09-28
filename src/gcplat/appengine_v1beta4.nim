
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: App Engine Admin
## version: v1beta4
## termsOfService: (not provided)
## license: (not provided)
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
    host: "appengine.googleapis.com", route: "/v1beta4/apps",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
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
  ##   ensureResourcesExist: JBool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete.
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
  var valid_579993 = query.getOrDefault("ensureResourcesExist")
  valid_579993 = validateParameter(valid_579993, JBool, required = false, default = nil)
  if valid_579993 != nil:
    section.add "ensureResourcesExist", valid_579993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_AppengineAppsGet_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_AppengineAppsGet_579964; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true;
          ensureResourcesExist: bool = false): Recallable =
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ensureResourcesExist: bool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete.
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  add(query_579997, "upload_protocol", newJString(uploadProtocol))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "callback", newJString(callback))
  add(query_579997, "access_token", newJString(accessToken))
  add(query_579997, "uploadType", newJString(uploadType))
  add(query_579997, "key", newJString(key))
  add(path_579996, "appsId", newJString(appsId))
  add(query_579997, "$.xgafv", newJString(Xgafv))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  add(query_579997, "ensureResourcesExist", newJBool(ensureResourcesExist))
  result = call_579995.call(path_579996, query_579997, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_579964(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}", validator: validate_AppengineAppsGet_579965,
    base: "/", url: url_AppengineAppsGet_579966, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_579998 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsPatch_580000(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_579999(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580001 = path.getOrDefault("appsId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "appsId", valid_580001
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
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580002 = query.getOrDefault("upload_protocol")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "upload_protocol", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("alt")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("json"))
  if valid_580005 != nil:
    section.add "alt", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("callback")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "callback", valid_580007
  var valid_580008 = query.getOrDefault("access_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "access_token", valid_580008
  var valid_580009 = query.getOrDefault("uploadType")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "uploadType", valid_580009
  var valid_580010 = query.getOrDefault("mask")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "mask", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("$.xgafv")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("1"))
  if valid_580012 != nil:
    section.add "$.xgafv", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
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

proc call*(call_580015: Call_AppengineAppsPatch_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_AppengineAppsPatch_579998; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; mask: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsPatch
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.default_cookie_expiration)
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  var body_580019 = newJObject()
  add(query_580018, "upload_protocol", newJString(uploadProtocol))
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "callback", newJString(callback))
  add(query_580018, "access_token", newJString(accessToken))
  add(query_580018, "uploadType", newJString(uploadType))
  add(query_580018, "mask", newJString(mask))
  add(query_580018, "key", newJString(key))
  add(path_580017, "appsId", newJString(appsId))
  add(query_580018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580019 = body
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, body_580019)

var appengineAppsPatch* = Call_AppengineAppsPatch_579998(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}",
    validator: validate_AppengineAppsPatch_579999, base: "/",
    url: url_AppengineAppsPatch_580000, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_580020 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsLocationsList_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsList_580021(path: JsonNode; query: JsonNode;
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
  var valid_580023 = path.getOrDefault("appsId")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "appsId", valid_580023
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
  var valid_580024 = query.getOrDefault("upload_protocol")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "upload_protocol", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("pageToken")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "pageToken", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
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
  var valid_580037 = query.getOrDefault("filter")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "filter", valid_580037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_AppengineAppsLocationsList_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_AppengineAppsLocationsList_580020; appsId: string;
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
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "pageToken", newJString(pageToken))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "key", newJString(key))
  add(path_580040, "appsId", newJString(appsId))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "pageSize", newJInt(pageSize))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "filter", newJString(filter))
  result = call_580039.call(path_580040, query_580041, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_580020(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_580021, base: "/",
    url: url_AppengineAppsLocationsList_580022, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_580042 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsLocationsGet_580044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "locationsId" in path, "`locationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "locationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsGet_580043(path: JsonNode; query: JsonNode;
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
  var valid_580045 = path.getOrDefault("appsId")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "appsId", valid_580045
  var valid_580046 = path.getOrDefault("locationsId")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "locationsId", valid_580046
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
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("access_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "access_token", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580058: Call_AppengineAppsLocationsGet_580042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_AppengineAppsLocationsGet_580042; appsId: string;
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
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  add(query_580061, "upload_protocol", newJString(uploadProtocol))
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "callback", newJString(callback))
  add(query_580061, "access_token", newJString(accessToken))
  add(query_580061, "uploadType", newJString(uploadType))
  add(query_580061, "key", newJString(key))
  add(path_580060, "appsId", newJString(appsId))
  add(query_580061, "$.xgafv", newJString(Xgafv))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  add(path_580060, "locationsId", newJString(locationsId))
  result = call_580059.call(path_580060, query_580061, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_580042(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_580043, base: "/",
    url: url_AppengineAppsLocationsGet_580044, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesList_580062 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesList_580064(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesList_580063(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the modules in the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_580065 = path.getOrDefault("appsId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "appsId", valid_580065
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
  var valid_580066 = query.getOrDefault("upload_protocol")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "upload_protocol", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("pageToken")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "pageToken", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("alt")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("json"))
  if valid_580070 != nil:
    section.add "alt", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("callback")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "callback", valid_580072
  var valid_580073 = query.getOrDefault("access_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "access_token", valid_580073
  var valid_580074 = query.getOrDefault("uploadType")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "uploadType", valid_580074
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("$.xgafv")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("1"))
  if valid_580076 != nil:
    section.add "$.xgafv", valid_580076
  var valid_580077 = query.getOrDefault("pageSize")
  valid_580077 = validateParameter(valid_580077, JInt, required = false, default = nil)
  if valid_580077 != nil:
    section.add "pageSize", valid_580077
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

proc call*(call_580079: Call_AppengineAppsModulesList_580062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the modules in the application.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_AppengineAppsModulesList_580062; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesList
  ## Lists all the modules in the application.
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "upload_protocol", newJString(uploadProtocol))
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "pageToken", newJString(pageToken))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "callback", newJString(callback))
  add(query_580082, "access_token", newJString(accessToken))
  add(query_580082, "uploadType", newJString(uploadType))
  add(query_580082, "key", newJString(key))
  add(path_580081, "appsId", newJString(appsId))
  add(query_580082, "$.xgafv", newJString(Xgafv))
  add(query_580082, "pageSize", newJInt(pageSize))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var appengineAppsModulesList* = Call_AppengineAppsModulesList_580062(
    name: "appengineAppsModulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules",
    validator: validate_AppengineAppsModulesList_580063, base: "/",
    url: url_AppengineAppsModulesList_580064, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesGet_580083 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesGet_580085(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesGet_580084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current configuration of the specified module.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `modulesId` field"
  var valid_580086 = path.getOrDefault("modulesId")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "modulesId", valid_580086
  var valid_580087 = path.getOrDefault("appsId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "appsId", valid_580087
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

proc call*(call_580099: Call_AppengineAppsModulesGet_580083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified module.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_AppengineAppsModulesGet_580083; modulesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesGet
  ## Gets the current configuration of the specified module.
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  add(path_580101, "modulesId", newJString(modulesId))
  add(query_580102, "key", newJString(key))
  add(path_580101, "appsId", newJString(appsId))
  add(query_580102, "$.xgafv", newJString(Xgafv))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  result = call_580100.call(path_580101, query_580102, nil, nil, nil)

var appengineAppsModulesGet* = Call_AppengineAppsModulesGet_580083(
    name: "appengineAppsModulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesGet_580084, base: "/",
    url: url_AppengineAppsModulesGet_580085, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesPatch_580123 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesPatch_580125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesPatch_580124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the configuration of the specified module.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `modulesId` field"
  var valid_580126 = path.getOrDefault("modulesId")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "modulesId", valid_580126
  var valid_580127 = path.getOrDefault("appsId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "appsId", valid_580127
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
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   migrateTraffic: JBool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules#shardby) field in the Module resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  section = newJObject()
  var valid_580128 = query.getOrDefault("upload_protocol")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "upload_protocol", valid_580128
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("callback")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "callback", valid_580133
  var valid_580134 = query.getOrDefault("access_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "access_token", valid_580134
  var valid_580135 = query.getOrDefault("uploadType")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "uploadType", valid_580135
  var valid_580136 = query.getOrDefault("mask")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "mask", valid_580136
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("$.xgafv")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("1"))
  if valid_580138 != nil:
    section.add "$.xgafv", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
  var valid_580140 = query.getOrDefault("migrateTraffic")
  valid_580140 = validateParameter(valid_580140, JBool, required = false, default = nil)
  if valid_580140 != nil:
    section.add "migrateTraffic", valid_580140
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

proc call*(call_580142: Call_AppengineAppsModulesPatch_580123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified module.
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_AppengineAppsModulesPatch_580123; modulesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          mask: string = ""; key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; migrateTraffic: bool = false): Recallable =
  ## appengineAppsModulesPatch
  ## Updates the configuration of the specified module.
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   migrateTraffic: bool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules#shardby) field in the Module resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  var body_580146 = newJObject()
  add(query_580145, "upload_protocol", newJString(uploadProtocol))
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "callback", newJString(callback))
  add(query_580145, "access_token", newJString(accessToken))
  add(query_580145, "uploadType", newJString(uploadType))
  add(query_580145, "mask", newJString(mask))
  add(path_580144, "modulesId", newJString(modulesId))
  add(query_580145, "key", newJString(key))
  add(path_580144, "appsId", newJString(appsId))
  add(query_580145, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580146 = body
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  add(query_580145, "migrateTraffic", newJBool(migrateTraffic))
  result = call_580143.call(path_580144, query_580145, nil, nil, body_580146)

var appengineAppsModulesPatch* = Call_AppengineAppsModulesPatch_580123(
    name: "appengineAppsModulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesPatch_580124, base: "/",
    url: url_AppengineAppsModulesPatch_580125, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesDelete_580103 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesDelete_580105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesDelete_580104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified module and all enclosed versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `modulesId` field"
  var valid_580106 = path.getOrDefault("modulesId")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "modulesId", valid_580106
  var valid_580107 = path.getOrDefault("appsId")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "appsId", valid_580107
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_AppengineAppsModulesDelete_580103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified module and all enclosed versions.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_AppengineAppsModulesDelete_580103; modulesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesDelete
  ## Deletes the specified module and all enclosed versions.
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "upload_protocol", newJString(uploadProtocol))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "callback", newJString(callback))
  add(query_580122, "access_token", newJString(accessToken))
  add(query_580122, "uploadType", newJString(uploadType))
  add(path_580121, "modulesId", newJString(modulesId))
  add(query_580122, "key", newJString(key))
  add(path_580121, "appsId", newJString(appsId))
  add(query_580122, "$.xgafv", newJString(Xgafv))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var appengineAppsModulesDelete* = Call_AppengineAppsModulesDelete_580103(
    name: "appengineAppsModulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesDelete_580104, base: "/",
    url: url_AppengineAppsModulesDelete_580105, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsCreate_580170 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsCreate_580172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsCreate_580171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deploys code and resource files to a new version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `modulesId` field"
  var valid_580173 = path.getOrDefault("modulesId")
  valid_580173 = validateParameter(valid_580173, JString, required = true,
                                 default = nil)
  if valid_580173 != nil:
    section.add "modulesId", valid_580173
  var valid_580174 = path.getOrDefault("appsId")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "appsId", valid_580174
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
  var valid_580175 = query.getOrDefault("upload_protocol")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "upload_protocol", valid_580175
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("quotaUser")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "quotaUser", valid_580177
  var valid_580178 = query.getOrDefault("alt")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("json"))
  if valid_580178 != nil:
    section.add "alt", valid_580178
  var valid_580179 = query.getOrDefault("oauth_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "oauth_token", valid_580179
  var valid_580180 = query.getOrDefault("callback")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "callback", valid_580180
  var valid_580181 = query.getOrDefault("access_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "access_token", valid_580181
  var valid_580182 = query.getOrDefault("uploadType")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "uploadType", valid_580182
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("$.xgafv")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("1"))
  if valid_580184 != nil:
    section.add "$.xgafv", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
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

proc call*(call_580187: Call_AppengineAppsModulesVersionsCreate_580170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_580187.validator(path, query, header, formData, body)
  let scheme = call_580187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580187.url(scheme.get, call_580187.host, call_580187.base,
                         call_580187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580187, url, valid)

proc call*(call_580188: Call_AppengineAppsModulesVersionsCreate_580170;
          modulesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsCreate
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580189 = newJObject()
  var query_580190 = newJObject()
  var body_580191 = newJObject()
  add(query_580190, "upload_protocol", newJString(uploadProtocol))
  add(query_580190, "fields", newJString(fields))
  add(query_580190, "quotaUser", newJString(quotaUser))
  add(query_580190, "alt", newJString(alt))
  add(query_580190, "oauth_token", newJString(oauthToken))
  add(query_580190, "callback", newJString(callback))
  add(query_580190, "access_token", newJString(accessToken))
  add(query_580190, "uploadType", newJString(uploadType))
  add(path_580189, "modulesId", newJString(modulesId))
  add(query_580190, "key", newJString(key))
  add(path_580189, "appsId", newJString(appsId))
  add(query_580190, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580191 = body
  add(query_580190, "prettyPrint", newJBool(prettyPrint))
  result = call_580188.call(path_580189, query_580190, nil, nil, body_580191)

var appengineAppsModulesVersionsCreate* = Call_AppengineAppsModulesVersionsCreate_580170(
    name: "appengineAppsModulesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsCreate_580171, base: "/",
    url: url_AppengineAppsModulesVersionsCreate_580172, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsList_580147 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsList_580149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsList_580148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the versions of a module.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `modulesId` field"
  var valid_580150 = path.getOrDefault("modulesId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "modulesId", valid_580150
  var valid_580151 = path.getOrDefault("appsId")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "appsId", valid_580151
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
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
  var valid_580154 = query.getOrDefault("pageToken")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "pageToken", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("view")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580156 != nil:
    section.add "view", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("callback")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "callback", valid_580159
  var valid_580160 = query.getOrDefault("access_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "access_token", valid_580160
  var valid_580161 = query.getOrDefault("uploadType")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "uploadType", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("$.xgafv")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("1"))
  if valid_580163 != nil:
    section.add "$.xgafv", valid_580163
  var valid_580164 = query.getOrDefault("pageSize")
  valid_580164 = validateParameter(valid_580164, JInt, required = false, default = nil)
  if valid_580164 != nil:
    section.add "pageSize", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580166: Call_AppengineAppsModulesVersionsList_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a module.
  ## 
  let valid = call_580166.validator(path, query, header, formData, body)
  let scheme = call_580166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580166.url(scheme.get, call_580166.host, call_580166.base,
                         call_580166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580166, url, valid)

proc call*(call_580167: Call_AppengineAppsModulesVersionsList_580147;
          modulesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "BASIC"; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsList
  ## Lists the versions of a module.
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580168 = newJObject()
  var query_580169 = newJObject()
  add(query_580169, "upload_protocol", newJString(uploadProtocol))
  add(query_580169, "fields", newJString(fields))
  add(query_580169, "pageToken", newJString(pageToken))
  add(query_580169, "quotaUser", newJString(quotaUser))
  add(query_580169, "view", newJString(view))
  add(query_580169, "alt", newJString(alt))
  add(query_580169, "oauth_token", newJString(oauthToken))
  add(query_580169, "callback", newJString(callback))
  add(query_580169, "access_token", newJString(accessToken))
  add(query_580169, "uploadType", newJString(uploadType))
  add(path_580168, "modulesId", newJString(modulesId))
  add(query_580169, "key", newJString(key))
  add(path_580168, "appsId", newJString(appsId))
  add(query_580169, "$.xgafv", newJString(Xgafv))
  add(query_580169, "pageSize", newJInt(pageSize))
  add(query_580169, "prettyPrint", newJBool(prettyPrint))
  result = call_580167.call(path_580168, query_580169, nil, nil, nil)

var appengineAppsModulesVersionsList* = Call_AppengineAppsModulesVersionsList_580147(
    name: "appengineAppsModulesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsList_580148, base: "/",
    url: url_AppengineAppsModulesVersionsList_580149, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsGet_580192 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsGet_580194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsGet_580193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580195 = path.getOrDefault("versionsId")
  valid_580195 = validateParameter(valid_580195, JString, required = true,
                                 default = nil)
  if valid_580195 != nil:
    section.add "versionsId", valid_580195
  var valid_580196 = path.getOrDefault("modulesId")
  valid_580196 = validateParameter(valid_580196, JString, required = true,
                                 default = nil)
  if valid_580196 != nil:
    section.add "modulesId", valid_580196
  var valid_580197 = path.getOrDefault("appsId")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = nil)
  if valid_580197 != nil:
    section.add "appsId", valid_580197
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
  var valid_580198 = query.getOrDefault("upload_protocol")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "upload_protocol", valid_580198
  var valid_580199 = query.getOrDefault("fields")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "fields", valid_580199
  var valid_580200 = query.getOrDefault("view")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580200 != nil:
    section.add "view", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("callback")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "callback", valid_580204
  var valid_580205 = query.getOrDefault("access_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "access_token", valid_580205
  var valid_580206 = query.getOrDefault("uploadType")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "uploadType", valid_580206
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("$.xgafv")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("1"))
  if valid_580208 != nil:
    section.add "$.xgafv", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_AppengineAppsModulesVersionsGet_580192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_AppengineAppsModulesVersionsGet_580192;
          versionsId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; view: string = "BASIC";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsGet
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  add(query_580213, "upload_protocol", newJString(uploadProtocol))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "view", newJString(view))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(path_580212, "versionsId", newJString(versionsId))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "callback", newJString(callback))
  add(query_580213, "access_token", newJString(accessToken))
  add(query_580213, "uploadType", newJString(uploadType))
  add(path_580212, "modulesId", newJString(modulesId))
  add(query_580213, "key", newJString(key))
  add(path_580212, "appsId", newJString(appsId))
  add(query_580213, "$.xgafv", newJString(Xgafv))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  result = call_580211.call(path_580212, query_580213, nil, nil, nil)

var appengineAppsModulesVersionsGet* = Call_AppengineAppsModulesVersionsGet_580192(
    name: "appengineAppsModulesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsGet_580193, base: "/",
    url: url_AppengineAppsModulesVersionsGet_580194, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsPatch_580235 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsPatch_580237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsPatch_580236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default/versions/1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580238 = path.getOrDefault("versionsId")
  valid_580238 = validateParameter(valid_580238, JString, required = true,
                                 default = nil)
  if valid_580238 != nil:
    section.add "versionsId", valid_580238
  var valid_580239 = path.getOrDefault("modulesId")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "modulesId", valid_580239
  var valid_580240 = path.getOrDefault("appsId")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "appsId", valid_580240
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
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580241 = query.getOrDefault("upload_protocol")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "upload_protocol", valid_580241
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("callback")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "callback", valid_580246
  var valid_580247 = query.getOrDefault("access_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "access_token", valid_580247
  var valid_580248 = query.getOrDefault("uploadType")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "uploadType", valid_580248
  var valid_580249 = query.getOrDefault("mask")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "mask", valid_580249
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("$.xgafv")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("1"))
  if valid_580251 != nil:
    section.add "$.xgafv", valid_580251
  var valid_580252 = query.getOrDefault("prettyPrint")
  valid_580252 = validateParameter(valid_580252, JBool, required = false,
                                 default = newJBool(true))
  if valid_580252 != nil:
    section.add "prettyPrint", valid_580252
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

proc call*(call_580254: Call_AppengineAppsModulesVersionsPatch_580235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_AppengineAppsModulesVersionsPatch_580235;
          versionsId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; mask: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsPatch
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/modules/default/versions/1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  var body_580258 = newJObject()
  add(query_580257, "upload_protocol", newJString(uploadProtocol))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(path_580256, "versionsId", newJString(versionsId))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "callback", newJString(callback))
  add(query_580257, "access_token", newJString(accessToken))
  add(query_580257, "uploadType", newJString(uploadType))
  add(query_580257, "mask", newJString(mask))
  add(path_580256, "modulesId", newJString(modulesId))
  add(query_580257, "key", newJString(key))
  add(path_580256, "appsId", newJString(appsId))
  add(query_580257, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580258 = body
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  result = call_580255.call(path_580256, query_580257, nil, nil, body_580258)

var appengineAppsModulesVersionsPatch* = Call_AppengineAppsModulesVersionsPatch_580235(
    name: "appengineAppsModulesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsPatch_580236, base: "/",
    url: url_AppengineAppsModulesVersionsPatch_580237, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsDelete_580214 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsDelete_580216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsDelete_580215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580217 = path.getOrDefault("versionsId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "versionsId", valid_580217
  var valid_580218 = path.getOrDefault("modulesId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "modulesId", valid_580218
  var valid_580219 = path.getOrDefault("appsId")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "appsId", valid_580219
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
  var valid_580220 = query.getOrDefault("upload_protocol")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "upload_protocol", valid_580220
  var valid_580221 = query.getOrDefault("fields")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "fields", valid_580221
  var valid_580222 = query.getOrDefault("quotaUser")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "quotaUser", valid_580222
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("oauth_token")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "oauth_token", valid_580224
  var valid_580225 = query.getOrDefault("callback")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "callback", valid_580225
  var valid_580226 = query.getOrDefault("access_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "access_token", valid_580226
  var valid_580227 = query.getOrDefault("uploadType")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "uploadType", valid_580227
  var valid_580228 = query.getOrDefault("key")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "key", valid_580228
  var valid_580229 = query.getOrDefault("$.xgafv")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("1"))
  if valid_580229 != nil:
    section.add "$.xgafv", valid_580229
  var valid_580230 = query.getOrDefault("prettyPrint")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(true))
  if valid_580230 != nil:
    section.add "prettyPrint", valid_580230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580231: Call_AppengineAppsModulesVersionsDelete_580214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing version.
  ## 
  let valid = call_580231.validator(path, query, header, formData, body)
  let scheme = call_580231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580231.url(scheme.get, call_580231.host, call_580231.base,
                         call_580231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580231, url, valid)

proc call*(call_580232: Call_AppengineAppsModulesVersionsDelete_580214;
          versionsId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsDelete
  ## Deletes an existing version.
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580233 = newJObject()
  var query_580234 = newJObject()
  add(query_580234, "upload_protocol", newJString(uploadProtocol))
  add(query_580234, "fields", newJString(fields))
  add(query_580234, "quotaUser", newJString(quotaUser))
  add(path_580233, "versionsId", newJString(versionsId))
  add(query_580234, "alt", newJString(alt))
  add(query_580234, "oauth_token", newJString(oauthToken))
  add(query_580234, "callback", newJString(callback))
  add(query_580234, "access_token", newJString(accessToken))
  add(query_580234, "uploadType", newJString(uploadType))
  add(path_580233, "modulesId", newJString(modulesId))
  add(query_580234, "key", newJString(key))
  add(path_580233, "appsId", newJString(appsId))
  add(query_580234, "$.xgafv", newJString(Xgafv))
  add(query_580234, "prettyPrint", newJBool(prettyPrint))
  result = call_580232.call(path_580233, query_580234, nil, nil, nil)

var appengineAppsModulesVersionsDelete* = Call_AppengineAppsModulesVersionsDelete_580214(
    name: "appengineAppsModulesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsDelete_580215, base: "/",
    url: url_AppengineAppsModulesVersionsDelete_580216, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesList_580259 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsInstancesList_580261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsInstancesList_580260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580262 = path.getOrDefault("versionsId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "versionsId", valid_580262
  var valid_580263 = path.getOrDefault("modulesId")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "modulesId", valid_580263
  var valid_580264 = path.getOrDefault("appsId")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "appsId", valid_580264
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
  var valid_580265 = query.getOrDefault("upload_protocol")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "upload_protocol", valid_580265
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("pageToken")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "pageToken", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("callback")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "callback", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("uploadType")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "uploadType", valid_580273
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("$.xgafv")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("1"))
  if valid_580275 != nil:
    section.add "$.xgafv", valid_580275
  var valid_580276 = query.getOrDefault("pageSize")
  valid_580276 = validateParameter(valid_580276, JInt, required = false, default = nil)
  if valid_580276 != nil:
    section.add "pageSize", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_AppengineAppsModulesVersionsInstancesList_580259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_AppengineAppsModulesVersionsInstancesList_580259;
          versionsId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsInstancesList
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  add(query_580281, "upload_protocol", newJString(uploadProtocol))
  add(query_580281, "fields", newJString(fields))
  add(query_580281, "pageToken", newJString(pageToken))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(path_580280, "versionsId", newJString(versionsId))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "callback", newJString(callback))
  add(query_580281, "access_token", newJString(accessToken))
  add(query_580281, "uploadType", newJString(uploadType))
  add(path_580280, "modulesId", newJString(modulesId))
  add(query_580281, "key", newJString(key))
  add(path_580280, "appsId", newJString(appsId))
  add(query_580281, "$.xgafv", newJString(Xgafv))
  add(query_580281, "pageSize", newJInt(pageSize))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(path_580280, query_580281, nil, nil, nil)

var appengineAppsModulesVersionsInstancesList* = Call_AppengineAppsModulesVersionsInstancesList_580259(
    name: "appengineAppsModulesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsModulesVersionsInstancesList_580260,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesList_580261,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesGet_580282 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsInstancesGet_580284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsInstancesGet_580283(path: JsonNode;
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
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580285 = path.getOrDefault("versionsId")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "versionsId", valid_580285
  var valid_580286 = path.getOrDefault("instancesId")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "instancesId", valid_580286
  var valid_580287 = path.getOrDefault("modulesId")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "modulesId", valid_580287
  var valid_580288 = path.getOrDefault("appsId")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "appsId", valid_580288
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
  var valid_580289 = query.getOrDefault("upload_protocol")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "upload_protocol", valid_580289
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("callback")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "callback", valid_580294
  var valid_580295 = query.getOrDefault("access_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "access_token", valid_580295
  var valid_580296 = query.getOrDefault("uploadType")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "uploadType", valid_580296
  var valid_580297 = query.getOrDefault("key")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "key", valid_580297
  var valid_580298 = query.getOrDefault("$.xgafv")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("1"))
  if valid_580298 != nil:
    section.add "$.xgafv", valid_580298
  var valid_580299 = query.getOrDefault("prettyPrint")
  valid_580299 = validateParameter(valid_580299, JBool, required = false,
                                 default = newJBool(true))
  if valid_580299 != nil:
    section.add "prettyPrint", valid_580299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580300: Call_AppengineAppsModulesVersionsInstancesGet_580282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_AppengineAppsModulesVersionsInstancesGet_580282;
          versionsId: string; instancesId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsInstancesGet
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  add(query_580303, "upload_protocol", newJString(uploadProtocol))
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(path_580302, "versionsId", newJString(versionsId))
  add(query_580303, "alt", newJString(alt))
  add(path_580302, "instancesId", newJString(instancesId))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "callback", newJString(callback))
  add(query_580303, "access_token", newJString(accessToken))
  add(query_580303, "uploadType", newJString(uploadType))
  add(path_580302, "modulesId", newJString(modulesId))
  add(query_580303, "key", newJString(key))
  add(path_580302, "appsId", newJString(appsId))
  add(query_580303, "$.xgafv", newJString(Xgafv))
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  result = call_580301.call(path_580302, query_580303, nil, nil, nil)

var appengineAppsModulesVersionsInstancesGet* = Call_AppengineAppsModulesVersionsInstancesGet_580282(
    name: "appengineAppsModulesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesGet_580283,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesGet_580284,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDelete_580304 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsInstancesDelete_580306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsInstancesDelete_580305(path: JsonNode;
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
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580307 = path.getOrDefault("versionsId")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "versionsId", valid_580307
  var valid_580308 = path.getOrDefault("instancesId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "instancesId", valid_580308
  var valid_580309 = path.getOrDefault("modulesId")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "modulesId", valid_580309
  var valid_580310 = path.getOrDefault("appsId")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "appsId", valid_580310
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
  var valid_580311 = query.getOrDefault("upload_protocol")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "upload_protocol", valid_580311
  var valid_580312 = query.getOrDefault("fields")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "fields", valid_580312
  var valid_580313 = query.getOrDefault("quotaUser")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "quotaUser", valid_580313
  var valid_580314 = query.getOrDefault("alt")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("json"))
  if valid_580314 != nil:
    section.add "alt", valid_580314
  var valid_580315 = query.getOrDefault("oauth_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "oauth_token", valid_580315
  var valid_580316 = query.getOrDefault("callback")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "callback", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("uploadType")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "uploadType", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("$.xgafv")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("1"))
  if valid_580320 != nil:
    section.add "$.xgafv", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580322: Call_AppengineAppsModulesVersionsInstancesDelete_580304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_580322.validator(path, query, header, formData, body)
  let scheme = call_580322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580322.url(scheme.get, call_580322.host, call_580322.base,
                         call_580322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580322, url, valid)

proc call*(call_580323: Call_AppengineAppsModulesVersionsInstancesDelete_580304;
          versionsId: string; instancesId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsInstancesDelete
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580324 = newJObject()
  var query_580325 = newJObject()
  add(query_580325, "upload_protocol", newJString(uploadProtocol))
  add(query_580325, "fields", newJString(fields))
  add(query_580325, "quotaUser", newJString(quotaUser))
  add(path_580324, "versionsId", newJString(versionsId))
  add(query_580325, "alt", newJString(alt))
  add(path_580324, "instancesId", newJString(instancesId))
  add(query_580325, "oauth_token", newJString(oauthToken))
  add(query_580325, "callback", newJString(callback))
  add(query_580325, "access_token", newJString(accessToken))
  add(query_580325, "uploadType", newJString(uploadType))
  add(path_580324, "modulesId", newJString(modulesId))
  add(query_580325, "key", newJString(key))
  add(path_580324, "appsId", newJString(appsId))
  add(query_580325, "$.xgafv", newJString(Xgafv))
  add(query_580325, "prettyPrint", newJBool(prettyPrint))
  result = call_580323.call(path_580324, query_580325, nil, nil, nil)

var appengineAppsModulesVersionsInstancesDelete* = Call_AppengineAppsModulesVersionsInstancesDelete_580304(
    name: "appengineAppsModulesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesDelete_580305,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDelete_580306,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDebug_580326 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsModulesVersionsInstancesDebug_580328(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "modulesId" in path, "`modulesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  assert "instancesId" in path, "`instancesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/modules/"),
               (kind: VariableSegment, value: "modulesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instancesId"),
               (kind: ConstantSegment, value: ":debug")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsModulesVersionsInstancesDebug_580327(path: JsonNode;
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
  ##   modulesId: JString (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_580329 = path.getOrDefault("versionsId")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "versionsId", valid_580329
  var valid_580330 = path.getOrDefault("instancesId")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "instancesId", valid_580330
  var valid_580331 = path.getOrDefault("modulesId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "modulesId", valid_580331
  var valid_580332 = path.getOrDefault("appsId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "appsId", valid_580332
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
  var valid_580333 = query.getOrDefault("upload_protocol")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "upload_protocol", valid_580333
  var valid_580334 = query.getOrDefault("fields")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "fields", valid_580334
  var valid_580335 = query.getOrDefault("quotaUser")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "quotaUser", valid_580335
  var valid_580336 = query.getOrDefault("alt")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = newJString("json"))
  if valid_580336 != nil:
    section.add "alt", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("callback")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "callback", valid_580338
  var valid_580339 = query.getOrDefault("access_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "access_token", valid_580339
  var valid_580340 = query.getOrDefault("uploadType")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "uploadType", valid_580340
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("$.xgafv")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("1"))
  if valid_580342 != nil:
    section.add "$.xgafv", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
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

proc call*(call_580345: Call_AppengineAppsModulesVersionsInstancesDebug_580326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_AppengineAppsModulesVersionsInstancesDebug_580326;
          versionsId: string; instancesId: string; modulesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsModulesVersionsInstancesDebug
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
  ##   modulesId: string (required)
  ##            : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/modules/default/versions/v1/instances/instance-1.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  var body_580349 = newJObject()
  add(query_580348, "upload_protocol", newJString(uploadProtocol))
  add(query_580348, "fields", newJString(fields))
  add(query_580348, "quotaUser", newJString(quotaUser))
  add(path_580347, "versionsId", newJString(versionsId))
  add(query_580348, "alt", newJString(alt))
  add(path_580347, "instancesId", newJString(instancesId))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "callback", newJString(callback))
  add(query_580348, "access_token", newJString(accessToken))
  add(query_580348, "uploadType", newJString(uploadType))
  add(path_580347, "modulesId", newJString(modulesId))
  add(query_580348, "key", newJString(key))
  add(path_580347, "appsId", newJString(appsId))
  add(query_580348, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580349 = body
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  result = call_580346.call(path_580347, query_580348, nil, nil, body_580349)

var appengineAppsModulesVersionsInstancesDebug* = Call_AppengineAppsModulesVersionsInstancesDebug_580326(
    name: "appengineAppsModulesVersionsInstancesDebug", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsModulesVersionsInstancesDebug_580327,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDebug_580328,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_580350 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsOperationsList_580352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsList_580351(path: JsonNode; query: JsonNode;
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
  var valid_580353 = path.getOrDefault("appsId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "appsId", valid_580353
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
  var valid_580354 = query.getOrDefault("upload_protocol")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "upload_protocol", valid_580354
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  var valid_580356 = query.getOrDefault("pageToken")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "pageToken", valid_580356
  var valid_580357 = query.getOrDefault("quotaUser")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "quotaUser", valid_580357
  var valid_580358 = query.getOrDefault("alt")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("json"))
  if valid_580358 != nil:
    section.add "alt", valid_580358
  var valid_580359 = query.getOrDefault("oauth_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "oauth_token", valid_580359
  var valid_580360 = query.getOrDefault("callback")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "callback", valid_580360
  var valid_580361 = query.getOrDefault("access_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "access_token", valid_580361
  var valid_580362 = query.getOrDefault("uploadType")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "uploadType", valid_580362
  var valid_580363 = query.getOrDefault("key")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "key", valid_580363
  var valid_580364 = query.getOrDefault("$.xgafv")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("1"))
  if valid_580364 != nil:
    section.add "$.xgafv", valid_580364
  var valid_580365 = query.getOrDefault("pageSize")
  valid_580365 = validateParameter(valid_580365, JInt, required = false, default = nil)
  if valid_580365 != nil:
    section.add "pageSize", valid_580365
  var valid_580366 = query.getOrDefault("prettyPrint")
  valid_580366 = validateParameter(valid_580366, JBool, required = false,
                                 default = newJBool(true))
  if valid_580366 != nil:
    section.add "prettyPrint", valid_580366
  var valid_580367 = query.getOrDefault("filter")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "filter", valid_580367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580368: Call_AppengineAppsOperationsList_580350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_580368.validator(path, query, header, formData, body)
  let scheme = call_580368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580368.url(scheme.get, call_580368.host, call_580368.base,
                         call_580368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580368, url, valid)

proc call*(call_580369: Call_AppengineAppsOperationsList_580350; appsId: string;
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
  var path_580370 = newJObject()
  var query_580371 = newJObject()
  add(query_580371, "upload_protocol", newJString(uploadProtocol))
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "pageToken", newJString(pageToken))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "callback", newJString(callback))
  add(query_580371, "access_token", newJString(accessToken))
  add(query_580371, "uploadType", newJString(uploadType))
  add(query_580371, "key", newJString(key))
  add(path_580370, "appsId", newJString(appsId))
  add(query_580371, "$.xgafv", newJString(Xgafv))
  add(query_580371, "pageSize", newJInt(pageSize))
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  add(query_580371, "filter", newJString(filter))
  result = call_580369.call(path_580370, query_580371, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_580350(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_580351, base: "/",
    url: url_AppengineAppsOperationsList_580352, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_580372 = ref object of OpenApiRestCall_579421
proc url_AppengineAppsOperationsGet_580374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "operationsId" in path, "`operationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsGet_580373(path: JsonNode; query: JsonNode;
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
  var valid_580375 = path.getOrDefault("appsId")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "appsId", valid_580375
  var valid_580376 = path.getOrDefault("operationsId")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "operationsId", valid_580376
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
  var valid_580377 = query.getOrDefault("upload_protocol")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "upload_protocol", valid_580377
  var valid_580378 = query.getOrDefault("fields")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "fields", valid_580378
  var valid_580379 = query.getOrDefault("quotaUser")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "quotaUser", valid_580379
  var valid_580380 = query.getOrDefault("alt")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("json"))
  if valid_580380 != nil:
    section.add "alt", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("callback")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "callback", valid_580382
  var valid_580383 = query.getOrDefault("access_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "access_token", valid_580383
  var valid_580384 = query.getOrDefault("uploadType")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "uploadType", valid_580384
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("$.xgafv")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("1"))
  if valid_580386 != nil:
    section.add "$.xgafv", valid_580386
  var valid_580387 = query.getOrDefault("prettyPrint")
  valid_580387 = validateParameter(valid_580387, JBool, required = false,
                                 default = newJBool(true))
  if valid_580387 != nil:
    section.add "prettyPrint", valid_580387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580388: Call_AppengineAppsOperationsGet_580372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_580388.validator(path, query, header, formData, body)
  let scheme = call_580388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580388.url(scheme.get, call_580388.host, call_580388.base,
                         call_580388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580388, url, valid)

proc call*(call_580389: Call_AppengineAppsOperationsGet_580372; appsId: string;
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
  var path_580390 = newJObject()
  var query_580391 = newJObject()
  add(query_580391, "upload_protocol", newJString(uploadProtocol))
  add(query_580391, "fields", newJString(fields))
  add(query_580391, "quotaUser", newJString(quotaUser))
  add(query_580391, "alt", newJString(alt))
  add(query_580391, "oauth_token", newJString(oauthToken))
  add(query_580391, "callback", newJString(callback))
  add(query_580391, "access_token", newJString(accessToken))
  add(query_580391, "uploadType", newJString(uploadType))
  add(query_580391, "key", newJString(key))
  add(path_580390, "appsId", newJString(appsId))
  add(query_580391, "$.xgafv", newJString(Xgafv))
  add(path_580390, "operationsId", newJString(operationsId))
  add(query_580391, "prettyPrint", newJBool(prettyPrint))
  result = call_580389.call(path_580390, query_580391, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_580372(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_580373, base: "/",
    url: url_AppengineAppsOperationsGet_580374, schemes: {Scheme.Https})
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
