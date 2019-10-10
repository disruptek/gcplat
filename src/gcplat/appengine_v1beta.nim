
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: App Engine Admin
## version: v1beta
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "appengine"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppengineAppsCreate_588719 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsCreate_588721(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppengineAppsCreate_588720(path: JsonNode; query: JsonNode;
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
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("quotaUser")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "quotaUser", valid_588835
  var valid_588849 = query.getOrDefault("alt")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("json"))
  if valid_588849 != nil:
    section.add "alt", valid_588849
  var valid_588850 = query.getOrDefault("oauth_token")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "oauth_token", valid_588850
  var valid_588851 = query.getOrDefault("callback")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "callback", valid_588851
  var valid_588852 = query.getOrDefault("access_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "access_token", valid_588852
  var valid_588853 = query.getOrDefault("uploadType")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "uploadType", valid_588853
  var valid_588854 = query.getOrDefault("key")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "key", valid_588854
  var valid_588855 = query.getOrDefault("$.xgafv")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("1"))
  if valid_588855 != nil:
    section.add "$.xgafv", valid_588855
  var valid_588856 = query.getOrDefault("prettyPrint")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "prettyPrint", valid_588856
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

proc call*(call_588880: Call_AppengineAppsCreate_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_AppengineAppsCreate_588719;
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
  var query_588952 = newJObject()
  var body_588954 = newJObject()
  add(query_588952, "upload_protocol", newJString(uploadProtocol))
  add(query_588952, "fields", newJString(fields))
  add(query_588952, "quotaUser", newJString(quotaUser))
  add(query_588952, "alt", newJString(alt))
  add(query_588952, "oauth_token", newJString(oauthToken))
  add(query_588952, "callback", newJString(callback))
  add(query_588952, "access_token", newJString(accessToken))
  add(query_588952, "uploadType", newJString(uploadType))
  add(query_588952, "key", newJString(key))
  add(query_588952, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588954 = body
  add(query_588952, "prettyPrint", newJBool(prettyPrint))
  result = call_588951.call(nil, query_588952, nil, nil, body_588954)

var appengineAppsCreate* = Call_AppengineAppsCreate_588719(
    name: "appengineAppsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta/apps",
    validator: validate_AppengineAppsCreate_588720, base: "/",
    url: url_AppengineAppsCreate_588721, schemes: {Scheme.Https})
type
  Call_AppengineAppsGet_588993 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsGet_588995(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsGet_588994(path: JsonNode; query: JsonNode;
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
  var valid_589010 = path.getOrDefault("appsId")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "appsId", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_AppengineAppsGet_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_AppengineAppsGet_588993; appsId: string;
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(path_589024, "appsId", newJString(appsId))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_588993(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}", validator: validate_AppengineAppsGet_588994,
    base: "/", url: url_AppengineAppsGet_588995, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_589026 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsPatch_589028(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_589027(path: JsonNode; query: JsonNode;
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
  var valid_589029 = path.getOrDefault("appsId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "appsId", valid_589029
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
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  var valid_589041 = query.getOrDefault("updateMask")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "updateMask", valid_589041
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

proc call*(call_589043: Call_AppengineAppsPatch_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_AppengineAppsPatch_589026; appsId: string;
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(query_589046, "upload_protocol", newJString(uploadProtocol))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "callback", newJString(callback))
  add(query_589046, "access_token", newJString(accessToken))
  add(query_589046, "uploadType", newJString(uploadType))
  add(query_589046, "key", newJString(key))
  add(path_589045, "appsId", newJString(appsId))
  add(query_589046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(query_589046, "updateMask", newJString(updateMask))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var appengineAppsPatch* = Call_AppengineAppsPatch_589026(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}",
    validator: validate_AppengineAppsPatch_589027, base: "/",
    url: url_AppengineAppsPatch_589028, schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesCreate_589070 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedCertificatesCreate_589072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesCreate_589071(path: JsonNode;
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
  var valid_589073 = path.getOrDefault("appsId")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "appsId", valid_589073
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
  var valid_589074 = query.getOrDefault("upload_protocol")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "upload_protocol", valid_589074
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("callback")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "callback", valid_589079
  var valid_589080 = query.getOrDefault("access_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "access_token", valid_589080
  var valid_589081 = query.getOrDefault("uploadType")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "uploadType", valid_589081
  var valid_589082 = query.getOrDefault("key")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "key", valid_589082
  var valid_589083 = query.getOrDefault("$.xgafv")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("1"))
  if valid_589083 != nil:
    section.add "$.xgafv", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
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

proc call*(call_589086: Call_AppengineAppsAuthorizedCertificatesCreate_589070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_AppengineAppsAuthorizedCertificatesCreate_589070;
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
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(query_589089, "upload_protocol", newJString(uploadProtocol))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "callback", newJString(callback))
  add(query_589089, "access_token", newJString(accessToken))
  add(query_589089, "uploadType", newJString(uploadType))
  add(query_589089, "key", newJString(key))
  add(path_589088, "appsId", newJString(appsId))
  add(query_589089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589087.call(path_589088, query_589089, nil, nil, body_589090)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_589070(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_589071,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_589072,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_589048 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedCertificatesList_589050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesList_589049(path: JsonNode;
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
  var valid_589051 = path.getOrDefault("appsId")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "appsId", valid_589051
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
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("pageToken")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "pageToken", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("view")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_589056 != nil:
    section.add "view", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("callback")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "callback", valid_589059
  var valid_589060 = query.getOrDefault("access_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "access_token", valid_589060
  var valid_589061 = query.getOrDefault("uploadType")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "uploadType", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("pageSize")
  valid_589064 = validateParameter(valid_589064, JInt, required = false, default = nil)
  if valid_589064 != nil:
    section.add "pageSize", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_AppengineAppsAuthorizedCertificatesList_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_AppengineAppsAuthorizedCertificatesList_589048;
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
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "pageToken", newJString(pageToken))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "view", newJString(view))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "key", newJString(key))
  add(path_589068, "appsId", newJString(appsId))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  add(query_589069, "pageSize", newJInt(pageSize))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589067.call(path_589068, query_589069, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_589048(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_589049, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_589050,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_589091 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedCertificatesGet_589093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesGet_589092(path: JsonNode;
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
  var valid_589094 = path.getOrDefault("appsId")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "appsId", valid_589094
  var valid_589095 = path.getOrDefault("authorizedCertificatesId")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "authorizedCertificatesId", valid_589095
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
  var valid_589096 = query.getOrDefault("upload_protocol")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "upload_protocol", valid_589096
  var valid_589097 = query.getOrDefault("fields")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "fields", valid_589097
  var valid_589098 = query.getOrDefault("view")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_589098 != nil:
    section.add "view", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("callback")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "callback", valid_589102
  var valid_589103 = query.getOrDefault("access_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "access_token", valid_589103
  var valid_589104 = query.getOrDefault("uploadType")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "uploadType", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("$.xgafv")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("1"))
  if valid_589106 != nil:
    section.add "$.xgafv", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_AppengineAppsAuthorizedCertificatesGet_589091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_AppengineAppsAuthorizedCertificatesGet_589091;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "upload_protocol", newJString(uploadProtocol))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "view", newJString(view))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "callback", newJString(callback))
  add(query_589111, "access_token", newJString(accessToken))
  add(query_589111, "uploadType", newJString(uploadType))
  add(query_589111, "key", newJString(key))
  add(path_589110, "appsId", newJString(appsId))
  add(query_589111, "$.xgafv", newJString(Xgafv))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  add(path_589110, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_589091(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_589092, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_589093,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_589132 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedCertificatesPatch_589134(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesPatch_589133(path: JsonNode;
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
  var valid_589135 = path.getOrDefault("appsId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "appsId", valid_589135
  var valid_589136 = path.getOrDefault("authorizedCertificatesId")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "authorizedCertificatesId", valid_589136
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
  var valid_589137 = query.getOrDefault("upload_protocol")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "upload_protocol", valid_589137
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("callback")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "callback", valid_589142
  var valid_589143 = query.getOrDefault("access_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "access_token", valid_589143
  var valid_589144 = query.getOrDefault("uploadType")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "uploadType", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("$.xgafv")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("1"))
  if valid_589146 != nil:
    section.add "$.xgafv", valid_589146
  var valid_589147 = query.getOrDefault("prettyPrint")
  valid_589147 = validateParameter(valid_589147, JBool, required = false,
                                 default = newJBool(true))
  if valid_589147 != nil:
    section.add "prettyPrint", valid_589147
  var valid_589148 = query.getOrDefault("updateMask")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "updateMask", valid_589148
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

proc call*(call_589150: Call_AppengineAppsAuthorizedCertificatesPatch_589132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_AppengineAppsAuthorizedCertificatesPatch_589132;
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
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  var body_589154 = newJObject()
  add(query_589153, "upload_protocol", newJString(uploadProtocol))
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "callback", newJString(callback))
  add(query_589153, "access_token", newJString(accessToken))
  add(query_589153, "uploadType", newJString(uploadType))
  add(query_589153, "key", newJString(key))
  add(path_589152, "appsId", newJString(appsId))
  add(query_589153, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589154 = body
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  add(query_589153, "updateMask", newJString(updateMask))
  add(path_589152, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_589151.call(path_589152, query_589153, nil, nil, body_589154)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_589132(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_589133,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_589134,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_589112 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedCertificatesDelete_589114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "authorizedCertificatesId" in path,
        "`authorizedCertificatesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedCertificates/"),
               (kind: VariableSegment, value: "authorizedCertificatesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedCertificatesDelete_589113(path: JsonNode;
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
  var valid_589115 = path.getOrDefault("appsId")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "appsId", valid_589115
  var valid_589116 = path.getOrDefault("authorizedCertificatesId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "authorizedCertificatesId", valid_589116
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
  var valid_589117 = query.getOrDefault("upload_protocol")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "upload_protocol", valid_589117
  var valid_589118 = query.getOrDefault("fields")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "fields", valid_589118
  var valid_589119 = query.getOrDefault("quotaUser")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "quotaUser", valid_589119
  var valid_589120 = query.getOrDefault("alt")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("json"))
  if valid_589120 != nil:
    section.add "alt", valid_589120
  var valid_589121 = query.getOrDefault("oauth_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "oauth_token", valid_589121
  var valid_589122 = query.getOrDefault("callback")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "callback", valid_589122
  var valid_589123 = query.getOrDefault("access_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "access_token", valid_589123
  var valid_589124 = query.getOrDefault("uploadType")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "uploadType", valid_589124
  var valid_589125 = query.getOrDefault("key")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "key", valid_589125
  var valid_589126 = query.getOrDefault("$.xgafv")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("1"))
  if valid_589126 != nil:
    section.add "$.xgafv", valid_589126
  var valid_589127 = query.getOrDefault("prettyPrint")
  valid_589127 = validateParameter(valid_589127, JBool, required = false,
                                 default = newJBool(true))
  if valid_589127 != nil:
    section.add "prettyPrint", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_AppengineAppsAuthorizedCertificatesDelete_589112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_AppengineAppsAuthorizedCertificatesDelete_589112;
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
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  add(query_589131, "upload_protocol", newJString(uploadProtocol))
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "callback", newJString(callback))
  add(query_589131, "access_token", newJString(accessToken))
  add(query_589131, "uploadType", newJString(uploadType))
  add(query_589131, "key", newJString(key))
  add(path_589130, "appsId", newJString(appsId))
  add(query_589131, "$.xgafv", newJString(Xgafv))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  add(path_589130, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_589112(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_589113,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_589114,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_589155 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsAuthorizedDomainsList_589157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/authorizedDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsAuthorizedDomainsList_589156(path: JsonNode;
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
  var valid_589158 = path.getOrDefault("appsId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "appsId", valid_589158
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
  var valid_589159 = query.getOrDefault("upload_protocol")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "upload_protocol", valid_589159
  var valid_589160 = query.getOrDefault("fields")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "fields", valid_589160
  var valid_589161 = query.getOrDefault("pageToken")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "pageToken", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("callback")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "callback", valid_589165
  var valid_589166 = query.getOrDefault("access_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "access_token", valid_589166
  var valid_589167 = query.getOrDefault("uploadType")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "uploadType", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("$.xgafv")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("1"))
  if valid_589169 != nil:
    section.add "$.xgafv", valid_589169
  var valid_589170 = query.getOrDefault("pageSize")
  valid_589170 = validateParameter(valid_589170, JInt, required = false, default = nil)
  if valid_589170 != nil:
    section.add "pageSize", valid_589170
  var valid_589171 = query.getOrDefault("prettyPrint")
  valid_589171 = validateParameter(valid_589171, JBool, required = false,
                                 default = newJBool(true))
  if valid_589171 != nil:
    section.add "prettyPrint", valid_589171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589172: Call_AppengineAppsAuthorizedDomainsList_589155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_589172.validator(path, query, header, formData, body)
  let scheme = call_589172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589172.url(scheme.get, call_589172.host, call_589172.base,
                         call_589172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589172, url, valid)

proc call*(call_589173: Call_AppengineAppsAuthorizedDomainsList_589155;
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
  var path_589174 = newJObject()
  var query_589175 = newJObject()
  add(query_589175, "upload_protocol", newJString(uploadProtocol))
  add(query_589175, "fields", newJString(fields))
  add(query_589175, "pageToken", newJString(pageToken))
  add(query_589175, "quotaUser", newJString(quotaUser))
  add(query_589175, "alt", newJString(alt))
  add(query_589175, "oauth_token", newJString(oauthToken))
  add(query_589175, "callback", newJString(callback))
  add(query_589175, "access_token", newJString(accessToken))
  add(query_589175, "uploadType", newJString(uploadType))
  add(query_589175, "key", newJString(key))
  add(path_589174, "appsId", newJString(appsId))
  add(query_589175, "$.xgafv", newJString(Xgafv))
  add(query_589175, "pageSize", newJInt(pageSize))
  add(query_589175, "prettyPrint", newJBool(prettyPrint))
  result = call_589173.call(path_589174, query_589175, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_589155(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_589156, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_589157, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_589197 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsDomainMappingsCreate_589199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsCreate_589198(path: JsonNode;
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
  var valid_589200 = path.getOrDefault("appsId")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "appsId", valid_589200
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
  var valid_589201 = query.getOrDefault("upload_protocol")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "upload_protocol", valid_589201
  var valid_589202 = query.getOrDefault("fields")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "fields", valid_589202
  var valid_589203 = query.getOrDefault("quotaUser")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "quotaUser", valid_589203
  var valid_589204 = query.getOrDefault("alt")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = newJString("json"))
  if valid_589204 != nil:
    section.add "alt", valid_589204
  var valid_589205 = query.getOrDefault("oauth_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "oauth_token", valid_589205
  var valid_589206 = query.getOrDefault("callback")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "callback", valid_589206
  var valid_589207 = query.getOrDefault("access_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "access_token", valid_589207
  var valid_589208 = query.getOrDefault("uploadType")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "uploadType", valid_589208
  var valid_589209 = query.getOrDefault("key")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "key", valid_589209
  var valid_589210 = query.getOrDefault("$.xgafv")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("1"))
  if valid_589210 != nil:
    section.add "$.xgafv", valid_589210
  var valid_589211 = query.getOrDefault("prettyPrint")
  valid_589211 = validateParameter(valid_589211, JBool, required = false,
                                 default = newJBool(true))
  if valid_589211 != nil:
    section.add "prettyPrint", valid_589211
  var valid_589212 = query.getOrDefault("overrideStrategy")
  valid_589212 = validateParameter(valid_589212, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_589212 != nil:
    section.add "overrideStrategy", valid_589212
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

proc call*(call_589214: Call_AppengineAppsDomainMappingsCreate_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_589214.validator(path, query, header, formData, body)
  let scheme = call_589214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589214.url(scheme.get, call_589214.host, call_589214.base,
                         call_589214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589214, url, valid)

proc call*(call_589215: Call_AppengineAppsDomainMappingsCreate_589197;
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
  var path_589216 = newJObject()
  var query_589217 = newJObject()
  var body_589218 = newJObject()
  add(query_589217, "upload_protocol", newJString(uploadProtocol))
  add(query_589217, "fields", newJString(fields))
  add(query_589217, "quotaUser", newJString(quotaUser))
  add(query_589217, "alt", newJString(alt))
  add(query_589217, "oauth_token", newJString(oauthToken))
  add(query_589217, "callback", newJString(callback))
  add(query_589217, "access_token", newJString(accessToken))
  add(query_589217, "uploadType", newJString(uploadType))
  add(query_589217, "key", newJString(key))
  add(path_589216, "appsId", newJString(appsId))
  add(query_589217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589218 = body
  add(query_589217, "prettyPrint", newJBool(prettyPrint))
  add(query_589217, "overrideStrategy", newJString(overrideStrategy))
  result = call_589215.call(path_589216, query_589217, nil, nil, body_589218)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_589197(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_589198, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_589199, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_589176 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsDomainMappingsList_589178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsList_589177(path: JsonNode;
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
  var valid_589179 = path.getOrDefault("appsId")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "appsId", valid_589179
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
  var valid_589180 = query.getOrDefault("upload_protocol")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "upload_protocol", valid_589180
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("pageToken")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "pageToken", valid_589182
  var valid_589183 = query.getOrDefault("quotaUser")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "quotaUser", valid_589183
  var valid_589184 = query.getOrDefault("alt")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("json"))
  if valid_589184 != nil:
    section.add "alt", valid_589184
  var valid_589185 = query.getOrDefault("oauth_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "oauth_token", valid_589185
  var valid_589186 = query.getOrDefault("callback")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "callback", valid_589186
  var valid_589187 = query.getOrDefault("access_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "access_token", valid_589187
  var valid_589188 = query.getOrDefault("uploadType")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "uploadType", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("$.xgafv")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("1"))
  if valid_589190 != nil:
    section.add "$.xgafv", valid_589190
  var valid_589191 = query.getOrDefault("pageSize")
  valid_589191 = validateParameter(valid_589191, JInt, required = false, default = nil)
  if valid_589191 != nil:
    section.add "pageSize", valid_589191
  var valid_589192 = query.getOrDefault("prettyPrint")
  valid_589192 = validateParameter(valid_589192, JBool, required = false,
                                 default = newJBool(true))
  if valid_589192 != nil:
    section.add "prettyPrint", valid_589192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589193: Call_AppengineAppsDomainMappingsList_589176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_AppengineAppsDomainMappingsList_589176;
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
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  add(query_589196, "upload_protocol", newJString(uploadProtocol))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "pageToken", newJString(pageToken))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "callback", newJString(callback))
  add(query_589196, "access_token", newJString(accessToken))
  add(query_589196, "uploadType", newJString(uploadType))
  add(query_589196, "key", newJString(key))
  add(path_589195, "appsId", newJString(appsId))
  add(query_589196, "$.xgafv", newJString(Xgafv))
  add(query_589196, "pageSize", newJInt(pageSize))
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  result = call_589194.call(path_589195, query_589196, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_589176(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_589177, base: "/",
    url: url_AppengineAppsDomainMappingsList_589178, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_589219 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsDomainMappingsGet_589221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsGet_589220(path: JsonNode;
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
  var valid_589222 = path.getOrDefault("appsId")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "appsId", valid_589222
  var valid_589223 = path.getOrDefault("domainMappingsId")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "domainMappingsId", valid_589223
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
  var valid_589224 = query.getOrDefault("upload_protocol")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "upload_protocol", valid_589224
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("alt")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("json"))
  if valid_589227 != nil:
    section.add "alt", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("callback")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "callback", valid_589229
  var valid_589230 = query.getOrDefault("access_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "access_token", valid_589230
  var valid_589231 = query.getOrDefault("uploadType")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "uploadType", valid_589231
  var valid_589232 = query.getOrDefault("key")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "key", valid_589232
  var valid_589233 = query.getOrDefault("$.xgafv")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("1"))
  if valid_589233 != nil:
    section.add "$.xgafv", valid_589233
  var valid_589234 = query.getOrDefault("prettyPrint")
  valid_589234 = validateParameter(valid_589234, JBool, required = false,
                                 default = newJBool(true))
  if valid_589234 != nil:
    section.add "prettyPrint", valid_589234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589235: Call_AppengineAppsDomainMappingsGet_589219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_589235.validator(path, query, header, formData, body)
  let scheme = call_589235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589235.url(scheme.get, call_589235.host, call_589235.base,
                         call_589235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589235, url, valid)

proc call*(call_589236: Call_AppengineAppsDomainMappingsGet_589219; appsId: string;
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
  var path_589237 = newJObject()
  var query_589238 = newJObject()
  add(query_589238, "upload_protocol", newJString(uploadProtocol))
  add(query_589238, "fields", newJString(fields))
  add(query_589238, "quotaUser", newJString(quotaUser))
  add(query_589238, "alt", newJString(alt))
  add(query_589238, "oauth_token", newJString(oauthToken))
  add(query_589238, "callback", newJString(callback))
  add(query_589238, "access_token", newJString(accessToken))
  add(query_589238, "uploadType", newJString(uploadType))
  add(query_589238, "key", newJString(key))
  add(path_589237, "appsId", newJString(appsId))
  add(query_589238, "$.xgafv", newJString(Xgafv))
  add(query_589238, "prettyPrint", newJBool(prettyPrint))
  add(path_589237, "domainMappingsId", newJString(domainMappingsId))
  result = call_589236.call(path_589237, query_589238, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_589219(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_589220, base: "/",
    url: url_AppengineAppsDomainMappingsGet_589221, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_589259 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsDomainMappingsPatch_589261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsPatch_589260(path: JsonNode;
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
  var valid_589262 = path.getOrDefault("appsId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "appsId", valid_589262
  var valid_589263 = path.getOrDefault("domainMappingsId")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "domainMappingsId", valid_589263
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
  var valid_589264 = query.getOrDefault("upload_protocol")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "upload_protocol", valid_589264
  var valid_589265 = query.getOrDefault("fields")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "fields", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("callback")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "callback", valid_589269
  var valid_589270 = query.getOrDefault("access_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "access_token", valid_589270
  var valid_589271 = query.getOrDefault("uploadType")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "uploadType", valid_589271
  var valid_589272 = query.getOrDefault("key")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "key", valid_589272
  var valid_589273 = query.getOrDefault("$.xgafv")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("1"))
  if valid_589273 != nil:
    section.add "$.xgafv", valid_589273
  var valid_589274 = query.getOrDefault("prettyPrint")
  valid_589274 = validateParameter(valid_589274, JBool, required = false,
                                 default = newJBool(true))
  if valid_589274 != nil:
    section.add "prettyPrint", valid_589274
  var valid_589275 = query.getOrDefault("updateMask")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "updateMask", valid_589275
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

proc call*(call_589277: Call_AppengineAppsDomainMappingsPatch_589259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_589277.validator(path, query, header, formData, body)
  let scheme = call_589277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589277.url(scheme.get, call_589277.host, call_589277.base,
                         call_589277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589277, url, valid)

proc call*(call_589278: Call_AppengineAppsDomainMappingsPatch_589259;
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
  var path_589279 = newJObject()
  var query_589280 = newJObject()
  var body_589281 = newJObject()
  add(query_589280, "upload_protocol", newJString(uploadProtocol))
  add(query_589280, "fields", newJString(fields))
  add(query_589280, "quotaUser", newJString(quotaUser))
  add(query_589280, "alt", newJString(alt))
  add(query_589280, "oauth_token", newJString(oauthToken))
  add(query_589280, "callback", newJString(callback))
  add(query_589280, "access_token", newJString(accessToken))
  add(query_589280, "uploadType", newJString(uploadType))
  add(query_589280, "key", newJString(key))
  add(path_589279, "appsId", newJString(appsId))
  add(query_589280, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589281 = body
  add(query_589280, "prettyPrint", newJBool(prettyPrint))
  add(path_589279, "domainMappingsId", newJString(domainMappingsId))
  add(query_589280, "updateMask", newJString(updateMask))
  result = call_589278.call(path_589279, query_589280, nil, nil, body_589281)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_589259(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_589260, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_589261, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_589239 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsDomainMappingsDelete_589241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "domainMappingsId" in path,
        "`domainMappingsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/domainMappings/"),
               (kind: VariableSegment, value: "domainMappingsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsDomainMappingsDelete_589240(path: JsonNode;
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
  var valid_589242 = path.getOrDefault("appsId")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = nil)
  if valid_589242 != nil:
    section.add "appsId", valid_589242
  var valid_589243 = path.getOrDefault("domainMappingsId")
  valid_589243 = validateParameter(valid_589243, JString, required = true,
                                 default = nil)
  if valid_589243 != nil:
    section.add "domainMappingsId", valid_589243
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
  var valid_589244 = query.getOrDefault("upload_protocol")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "upload_protocol", valid_589244
  var valid_589245 = query.getOrDefault("fields")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "fields", valid_589245
  var valid_589246 = query.getOrDefault("quotaUser")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "quotaUser", valid_589246
  var valid_589247 = query.getOrDefault("alt")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("json"))
  if valid_589247 != nil:
    section.add "alt", valid_589247
  var valid_589248 = query.getOrDefault("oauth_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "oauth_token", valid_589248
  var valid_589249 = query.getOrDefault("callback")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "callback", valid_589249
  var valid_589250 = query.getOrDefault("access_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "access_token", valid_589250
  var valid_589251 = query.getOrDefault("uploadType")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "uploadType", valid_589251
  var valid_589252 = query.getOrDefault("key")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "key", valid_589252
  var valid_589253 = query.getOrDefault("$.xgafv")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = newJString("1"))
  if valid_589253 != nil:
    section.add "$.xgafv", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_AppengineAppsDomainMappingsDelete_589239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_AppengineAppsDomainMappingsDelete_589239;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "upload_protocol", newJString(uploadProtocol))
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "callback", newJString(callback))
  add(query_589258, "access_token", newJString(accessToken))
  add(query_589258, "uploadType", newJString(uploadType))
  add(query_589258, "key", newJString(key))
  add(path_589257, "appsId", newJString(appsId))
  add(query_589258, "$.xgafv", newJString(Xgafv))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  add(path_589257, "domainMappingsId", newJString(domainMappingsId))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_589239(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_589240, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_589241, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesCreate_589304 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesCreate_589306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesCreate_589305(path: JsonNode;
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
  var valid_589307 = path.getOrDefault("appsId")
  valid_589307 = validateParameter(valid_589307, JString, required = true,
                                 default = nil)
  if valid_589307 != nil:
    section.add "appsId", valid_589307
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
  var valid_589308 = query.getOrDefault("upload_protocol")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "upload_protocol", valid_589308
  var valid_589309 = query.getOrDefault("fields")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "fields", valid_589309
  var valid_589310 = query.getOrDefault("quotaUser")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "quotaUser", valid_589310
  var valid_589311 = query.getOrDefault("alt")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = newJString("json"))
  if valid_589311 != nil:
    section.add "alt", valid_589311
  var valid_589312 = query.getOrDefault("oauth_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "oauth_token", valid_589312
  var valid_589313 = query.getOrDefault("callback")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "callback", valid_589313
  var valid_589314 = query.getOrDefault("access_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "access_token", valid_589314
  var valid_589315 = query.getOrDefault("uploadType")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "uploadType", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("$.xgafv")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("1"))
  if valid_589317 != nil:
    section.add "$.xgafv", valid_589317
  var valid_589318 = query.getOrDefault("prettyPrint")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(true))
  if valid_589318 != nil:
    section.add "prettyPrint", valid_589318
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

proc call*(call_589320: Call_AppengineAppsFirewallIngressRulesCreate_589304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a firewall rule for the application.
  ## 
  let valid = call_589320.validator(path, query, header, formData, body)
  let scheme = call_589320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589320.url(scheme.get, call_589320.host, call_589320.base,
                         call_589320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589320, url, valid)

proc call*(call_589321: Call_AppengineAppsFirewallIngressRulesCreate_589304;
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
  var path_589322 = newJObject()
  var query_589323 = newJObject()
  var body_589324 = newJObject()
  add(query_589323, "upload_protocol", newJString(uploadProtocol))
  add(query_589323, "fields", newJString(fields))
  add(query_589323, "quotaUser", newJString(quotaUser))
  add(query_589323, "alt", newJString(alt))
  add(query_589323, "oauth_token", newJString(oauthToken))
  add(query_589323, "callback", newJString(callback))
  add(query_589323, "access_token", newJString(accessToken))
  add(query_589323, "uploadType", newJString(uploadType))
  add(query_589323, "key", newJString(key))
  add(path_589322, "appsId", newJString(appsId))
  add(query_589323, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589324 = body
  add(query_589323, "prettyPrint", newJBool(prettyPrint))
  result = call_589321.call(path_589322, query_589323, nil, nil, body_589324)

var appengineAppsFirewallIngressRulesCreate* = Call_AppengineAppsFirewallIngressRulesCreate_589304(
    name: "appengineAppsFirewallIngressRulesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesCreate_589305, base: "/",
    url: url_AppengineAppsFirewallIngressRulesCreate_589306,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesList_589282 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesList_589284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesList_589283(path: JsonNode;
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
  var valid_589285 = path.getOrDefault("appsId")
  valid_589285 = validateParameter(valid_589285, JString, required = true,
                                 default = nil)
  if valid_589285 != nil:
    section.add "appsId", valid_589285
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
  var valid_589286 = query.getOrDefault("upload_protocol")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "upload_protocol", valid_589286
  var valid_589287 = query.getOrDefault("fields")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "fields", valid_589287
  var valid_589288 = query.getOrDefault("pageToken")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "pageToken", valid_589288
  var valid_589289 = query.getOrDefault("quotaUser")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "quotaUser", valid_589289
  var valid_589290 = query.getOrDefault("alt")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("json"))
  if valid_589290 != nil:
    section.add "alt", valid_589290
  var valid_589291 = query.getOrDefault("oauth_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "oauth_token", valid_589291
  var valid_589292 = query.getOrDefault("callback")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "callback", valid_589292
  var valid_589293 = query.getOrDefault("access_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "access_token", valid_589293
  var valid_589294 = query.getOrDefault("uploadType")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "uploadType", valid_589294
  var valid_589295 = query.getOrDefault("matchingAddress")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "matchingAddress", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("$.xgafv")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("1"))
  if valid_589297 != nil:
    section.add "$.xgafv", valid_589297
  var valid_589298 = query.getOrDefault("pageSize")
  valid_589298 = validateParameter(valid_589298, JInt, required = false, default = nil)
  if valid_589298 != nil:
    section.add "pageSize", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589300: Call_AppengineAppsFirewallIngressRulesList_589282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the firewall rules of an application.
  ## 
  let valid = call_589300.validator(path, query, header, formData, body)
  let scheme = call_589300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589300.url(scheme.get, call_589300.host, call_589300.base,
                         call_589300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589300, url, valid)

proc call*(call_589301: Call_AppengineAppsFirewallIngressRulesList_589282;
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
  var path_589302 = newJObject()
  var query_589303 = newJObject()
  add(query_589303, "upload_protocol", newJString(uploadProtocol))
  add(query_589303, "fields", newJString(fields))
  add(query_589303, "pageToken", newJString(pageToken))
  add(query_589303, "quotaUser", newJString(quotaUser))
  add(query_589303, "alt", newJString(alt))
  add(query_589303, "oauth_token", newJString(oauthToken))
  add(query_589303, "callback", newJString(callback))
  add(query_589303, "access_token", newJString(accessToken))
  add(query_589303, "uploadType", newJString(uploadType))
  add(query_589303, "matchingAddress", newJString(matchingAddress))
  add(query_589303, "key", newJString(key))
  add(path_589302, "appsId", newJString(appsId))
  add(query_589303, "$.xgafv", newJString(Xgafv))
  add(query_589303, "pageSize", newJInt(pageSize))
  add(query_589303, "prettyPrint", newJBool(prettyPrint))
  result = call_589301.call(path_589302, query_589303, nil, nil, nil)

var appengineAppsFirewallIngressRulesList* = Call_AppengineAppsFirewallIngressRulesList_589282(
    name: "appengineAppsFirewallIngressRulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesList_589283, base: "/",
    url: url_AppengineAppsFirewallIngressRulesList_589284, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesGet_589325 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesGet_589327(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesGet_589326(path: JsonNode;
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
  var valid_589328 = path.getOrDefault("ingressRulesId")
  valid_589328 = validateParameter(valid_589328, JString, required = true,
                                 default = nil)
  if valid_589328 != nil:
    section.add "ingressRulesId", valid_589328
  var valid_589329 = path.getOrDefault("appsId")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "appsId", valid_589329
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
  var valid_589330 = query.getOrDefault("upload_protocol")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "upload_protocol", valid_589330
  var valid_589331 = query.getOrDefault("fields")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "fields", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("callback")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "callback", valid_589335
  var valid_589336 = query.getOrDefault("access_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "access_token", valid_589336
  var valid_589337 = query.getOrDefault("uploadType")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "uploadType", valid_589337
  var valid_589338 = query.getOrDefault("key")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "key", valid_589338
  var valid_589339 = query.getOrDefault("$.xgafv")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("1"))
  if valid_589339 != nil:
    section.add "$.xgafv", valid_589339
  var valid_589340 = query.getOrDefault("prettyPrint")
  valid_589340 = validateParameter(valid_589340, JBool, required = false,
                                 default = newJBool(true))
  if valid_589340 != nil:
    section.add "prettyPrint", valid_589340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589341: Call_AppengineAppsFirewallIngressRulesGet_589325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified firewall rule.
  ## 
  let valid = call_589341.validator(path, query, header, formData, body)
  let scheme = call_589341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589341.url(scheme.get, call_589341.host, call_589341.base,
                         call_589341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589341, url, valid)

proc call*(call_589342: Call_AppengineAppsFirewallIngressRulesGet_589325;
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
  var path_589343 = newJObject()
  var query_589344 = newJObject()
  add(query_589344, "upload_protocol", newJString(uploadProtocol))
  add(path_589343, "ingressRulesId", newJString(ingressRulesId))
  add(query_589344, "fields", newJString(fields))
  add(query_589344, "quotaUser", newJString(quotaUser))
  add(query_589344, "alt", newJString(alt))
  add(query_589344, "oauth_token", newJString(oauthToken))
  add(query_589344, "callback", newJString(callback))
  add(query_589344, "access_token", newJString(accessToken))
  add(query_589344, "uploadType", newJString(uploadType))
  add(query_589344, "key", newJString(key))
  add(path_589343, "appsId", newJString(appsId))
  add(query_589344, "$.xgafv", newJString(Xgafv))
  add(query_589344, "prettyPrint", newJBool(prettyPrint))
  result = call_589342.call(path_589343, query_589344, nil, nil, nil)

var appengineAppsFirewallIngressRulesGet* = Call_AppengineAppsFirewallIngressRulesGet_589325(
    name: "appengineAppsFirewallIngressRulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesGet_589326, base: "/",
    url: url_AppengineAppsFirewallIngressRulesGet_589327, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesPatch_589365 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesPatch_589367(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesPatch_589366(path: JsonNode;
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
  var valid_589368 = path.getOrDefault("ingressRulesId")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "ingressRulesId", valid_589368
  var valid_589369 = path.getOrDefault("appsId")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "appsId", valid_589369
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
  var valid_589370 = query.getOrDefault("upload_protocol")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "upload_protocol", valid_589370
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("quotaUser")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "quotaUser", valid_589372
  var valid_589373 = query.getOrDefault("alt")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("json"))
  if valid_589373 != nil:
    section.add "alt", valid_589373
  var valid_589374 = query.getOrDefault("oauth_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "oauth_token", valid_589374
  var valid_589375 = query.getOrDefault("callback")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "callback", valid_589375
  var valid_589376 = query.getOrDefault("access_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "access_token", valid_589376
  var valid_589377 = query.getOrDefault("uploadType")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "uploadType", valid_589377
  var valid_589378 = query.getOrDefault("key")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "key", valid_589378
  var valid_589379 = query.getOrDefault("$.xgafv")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = newJString("1"))
  if valid_589379 != nil:
    section.add "$.xgafv", valid_589379
  var valid_589380 = query.getOrDefault("prettyPrint")
  valid_589380 = validateParameter(valid_589380, JBool, required = false,
                                 default = newJBool(true))
  if valid_589380 != nil:
    section.add "prettyPrint", valid_589380
  var valid_589381 = query.getOrDefault("updateMask")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "updateMask", valid_589381
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

proc call*(call_589383: Call_AppengineAppsFirewallIngressRulesPatch_589365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_589383.validator(path, query, header, formData, body)
  let scheme = call_589383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589383.url(scheme.get, call_589383.host, call_589383.base,
                         call_589383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589383, url, valid)

proc call*(call_589384: Call_AppengineAppsFirewallIngressRulesPatch_589365;
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
  var path_589385 = newJObject()
  var query_589386 = newJObject()
  var body_589387 = newJObject()
  add(query_589386, "upload_protocol", newJString(uploadProtocol))
  add(path_589385, "ingressRulesId", newJString(ingressRulesId))
  add(query_589386, "fields", newJString(fields))
  add(query_589386, "quotaUser", newJString(quotaUser))
  add(query_589386, "alt", newJString(alt))
  add(query_589386, "oauth_token", newJString(oauthToken))
  add(query_589386, "callback", newJString(callback))
  add(query_589386, "access_token", newJString(accessToken))
  add(query_589386, "uploadType", newJString(uploadType))
  add(query_589386, "key", newJString(key))
  add(path_589385, "appsId", newJString(appsId))
  add(query_589386, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589387 = body
  add(query_589386, "prettyPrint", newJBool(prettyPrint))
  add(query_589386, "updateMask", newJString(updateMask))
  result = call_589384.call(path_589385, query_589386, nil, nil, body_589387)

var appengineAppsFirewallIngressRulesPatch* = Call_AppengineAppsFirewallIngressRulesPatch_589365(
    name: "appengineAppsFirewallIngressRulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesPatch_589366, base: "/",
    url: url_AppengineAppsFirewallIngressRulesPatch_589367,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesDelete_589345 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesDelete_589347(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "ingressRulesId" in path, "`ingressRulesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/firewall/ingressRules/"),
               (kind: VariableSegment, value: "ingressRulesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesDelete_589346(path: JsonNode;
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
  var valid_589348 = path.getOrDefault("ingressRulesId")
  valid_589348 = validateParameter(valid_589348, JString, required = true,
                                 default = nil)
  if valid_589348 != nil:
    section.add "ingressRulesId", valid_589348
  var valid_589349 = path.getOrDefault("appsId")
  valid_589349 = validateParameter(valid_589349, JString, required = true,
                                 default = nil)
  if valid_589349 != nil:
    section.add "appsId", valid_589349
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
  var valid_589350 = query.getOrDefault("upload_protocol")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "upload_protocol", valid_589350
  var valid_589351 = query.getOrDefault("fields")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "fields", valid_589351
  var valid_589352 = query.getOrDefault("quotaUser")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "quotaUser", valid_589352
  var valid_589353 = query.getOrDefault("alt")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("json"))
  if valid_589353 != nil:
    section.add "alt", valid_589353
  var valid_589354 = query.getOrDefault("oauth_token")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "oauth_token", valid_589354
  var valid_589355 = query.getOrDefault("callback")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "callback", valid_589355
  var valid_589356 = query.getOrDefault("access_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "access_token", valid_589356
  var valid_589357 = query.getOrDefault("uploadType")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "uploadType", valid_589357
  var valid_589358 = query.getOrDefault("key")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "key", valid_589358
  var valid_589359 = query.getOrDefault("$.xgafv")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = newJString("1"))
  if valid_589359 != nil:
    section.add "$.xgafv", valid_589359
  var valid_589360 = query.getOrDefault("prettyPrint")
  valid_589360 = validateParameter(valid_589360, JBool, required = false,
                                 default = newJBool(true))
  if valid_589360 != nil:
    section.add "prettyPrint", valid_589360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589361: Call_AppengineAppsFirewallIngressRulesDelete_589345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified firewall rule.
  ## 
  let valid = call_589361.validator(path, query, header, formData, body)
  let scheme = call_589361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589361.url(scheme.get, call_589361.host, call_589361.base,
                         call_589361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589361, url, valid)

proc call*(call_589362: Call_AppengineAppsFirewallIngressRulesDelete_589345;
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
  var path_589363 = newJObject()
  var query_589364 = newJObject()
  add(query_589364, "upload_protocol", newJString(uploadProtocol))
  add(path_589363, "ingressRulesId", newJString(ingressRulesId))
  add(query_589364, "fields", newJString(fields))
  add(query_589364, "quotaUser", newJString(quotaUser))
  add(query_589364, "alt", newJString(alt))
  add(query_589364, "oauth_token", newJString(oauthToken))
  add(query_589364, "callback", newJString(callback))
  add(query_589364, "access_token", newJString(accessToken))
  add(query_589364, "uploadType", newJString(uploadType))
  add(query_589364, "key", newJString(key))
  add(path_589363, "appsId", newJString(appsId))
  add(query_589364, "$.xgafv", newJString(Xgafv))
  add(query_589364, "prettyPrint", newJBool(prettyPrint))
  result = call_589362.call(path_589363, query_589364, nil, nil, nil)

var appengineAppsFirewallIngressRulesDelete* = Call_AppengineAppsFirewallIngressRulesDelete_589345(
    name: "appengineAppsFirewallIngressRulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesDelete_589346, base: "/",
    url: url_AppengineAppsFirewallIngressRulesDelete_589347,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesBatchUpdate_589388 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsFirewallIngressRulesBatchUpdate_589390(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"), (kind: ConstantSegment,
        value: "/firewall/ingressRules:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsFirewallIngressRulesBatchUpdate_589389(path: JsonNode;
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
  var valid_589391 = path.getOrDefault("appsId")
  valid_589391 = validateParameter(valid_589391, JString, required = true,
                                 default = nil)
  if valid_589391 != nil:
    section.add "appsId", valid_589391
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
  var valid_589392 = query.getOrDefault("upload_protocol")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "upload_protocol", valid_589392
  var valid_589393 = query.getOrDefault("fields")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "fields", valid_589393
  var valid_589394 = query.getOrDefault("quotaUser")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "quotaUser", valid_589394
  var valid_589395 = query.getOrDefault("alt")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = newJString("json"))
  if valid_589395 != nil:
    section.add "alt", valid_589395
  var valid_589396 = query.getOrDefault("oauth_token")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "oauth_token", valid_589396
  var valid_589397 = query.getOrDefault("callback")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "callback", valid_589397
  var valid_589398 = query.getOrDefault("access_token")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "access_token", valid_589398
  var valid_589399 = query.getOrDefault("uploadType")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "uploadType", valid_589399
  var valid_589400 = query.getOrDefault("key")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "key", valid_589400
  var valid_589401 = query.getOrDefault("$.xgafv")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = newJString("1"))
  if valid_589401 != nil:
    section.add "$.xgafv", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
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

proc call*(call_589404: Call_AppengineAppsFirewallIngressRulesBatchUpdate_589388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
  ## 
  let valid = call_589404.validator(path, query, header, formData, body)
  let scheme = call_589404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589404.url(scheme.get, call_589404.host, call_589404.base,
                         call_589404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589404, url, valid)

proc call*(call_589405: Call_AppengineAppsFirewallIngressRulesBatchUpdate_589388;
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
  var path_589406 = newJObject()
  var query_589407 = newJObject()
  var body_589408 = newJObject()
  add(query_589407, "upload_protocol", newJString(uploadProtocol))
  add(query_589407, "fields", newJString(fields))
  add(query_589407, "quotaUser", newJString(quotaUser))
  add(query_589407, "alt", newJString(alt))
  add(query_589407, "oauth_token", newJString(oauthToken))
  add(query_589407, "callback", newJString(callback))
  add(query_589407, "access_token", newJString(accessToken))
  add(query_589407, "uploadType", newJString(uploadType))
  add(query_589407, "key", newJString(key))
  add(path_589406, "appsId", newJString(appsId))
  add(query_589407, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589408 = body
  add(query_589407, "prettyPrint", newJBool(prettyPrint))
  result = call_589405.call(path_589406, query_589407, nil, nil, body_589408)

var appengineAppsFirewallIngressRulesBatchUpdate* = Call_AppengineAppsFirewallIngressRulesBatchUpdate_589388(
    name: "appengineAppsFirewallIngressRulesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules:batchUpdate",
    validator: validate_AppengineAppsFirewallIngressRulesBatchUpdate_589389,
    base: "/", url: url_AppengineAppsFirewallIngressRulesBatchUpdate_589390,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_589409 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsLocationsList_589411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsList_589410(path: JsonNode; query: JsonNode;
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
  var valid_589412 = path.getOrDefault("appsId")
  valid_589412 = validateParameter(valid_589412, JString, required = true,
                                 default = nil)
  if valid_589412 != nil:
    section.add "appsId", valid_589412
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
  var valid_589413 = query.getOrDefault("upload_protocol")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "upload_protocol", valid_589413
  var valid_589414 = query.getOrDefault("fields")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "fields", valid_589414
  var valid_589415 = query.getOrDefault("pageToken")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "pageToken", valid_589415
  var valid_589416 = query.getOrDefault("quotaUser")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "quotaUser", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("oauth_token")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "oauth_token", valid_589418
  var valid_589419 = query.getOrDefault("callback")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "callback", valid_589419
  var valid_589420 = query.getOrDefault("access_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "access_token", valid_589420
  var valid_589421 = query.getOrDefault("uploadType")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "uploadType", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("$.xgafv")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = newJString("1"))
  if valid_589423 != nil:
    section.add "$.xgafv", valid_589423
  var valid_589424 = query.getOrDefault("pageSize")
  valid_589424 = validateParameter(valid_589424, JInt, required = false, default = nil)
  if valid_589424 != nil:
    section.add "pageSize", valid_589424
  var valid_589425 = query.getOrDefault("prettyPrint")
  valid_589425 = validateParameter(valid_589425, JBool, required = false,
                                 default = newJBool(true))
  if valid_589425 != nil:
    section.add "prettyPrint", valid_589425
  var valid_589426 = query.getOrDefault("filter")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "filter", valid_589426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589427: Call_AppengineAppsLocationsList_589409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589427.validator(path, query, header, formData, body)
  let scheme = call_589427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589427.url(scheme.get, call_589427.host, call_589427.base,
                         call_589427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589427, url, valid)

proc call*(call_589428: Call_AppengineAppsLocationsList_589409; appsId: string;
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
  var path_589429 = newJObject()
  var query_589430 = newJObject()
  add(query_589430, "upload_protocol", newJString(uploadProtocol))
  add(query_589430, "fields", newJString(fields))
  add(query_589430, "pageToken", newJString(pageToken))
  add(query_589430, "quotaUser", newJString(quotaUser))
  add(query_589430, "alt", newJString(alt))
  add(query_589430, "oauth_token", newJString(oauthToken))
  add(query_589430, "callback", newJString(callback))
  add(query_589430, "access_token", newJString(accessToken))
  add(query_589430, "uploadType", newJString(uploadType))
  add(query_589430, "key", newJString(key))
  add(path_589429, "appsId", newJString(appsId))
  add(query_589430, "$.xgafv", newJString(Xgafv))
  add(query_589430, "pageSize", newJInt(pageSize))
  add(query_589430, "prettyPrint", newJBool(prettyPrint))
  add(query_589430, "filter", newJString(filter))
  result = call_589428.call(path_589429, query_589430, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_589409(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_589410, base: "/",
    url: url_AppengineAppsLocationsList_589411, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_589431 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsLocationsGet_589433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "locationsId" in path, "`locationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "locationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsGet_589432(path: JsonNode; query: JsonNode;
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
  var valid_589434 = path.getOrDefault("appsId")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = nil)
  if valid_589434 != nil:
    section.add "appsId", valid_589434
  var valid_589435 = path.getOrDefault("locationsId")
  valid_589435 = validateParameter(valid_589435, JString, required = true,
                                 default = nil)
  if valid_589435 != nil:
    section.add "locationsId", valid_589435
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
  var valid_589436 = query.getOrDefault("upload_protocol")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "upload_protocol", valid_589436
  var valid_589437 = query.getOrDefault("fields")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "fields", valid_589437
  var valid_589438 = query.getOrDefault("quotaUser")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "quotaUser", valid_589438
  var valid_589439 = query.getOrDefault("alt")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("json"))
  if valid_589439 != nil:
    section.add "alt", valid_589439
  var valid_589440 = query.getOrDefault("oauth_token")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "oauth_token", valid_589440
  var valid_589441 = query.getOrDefault("callback")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "callback", valid_589441
  var valid_589442 = query.getOrDefault("access_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "access_token", valid_589442
  var valid_589443 = query.getOrDefault("uploadType")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "uploadType", valid_589443
  var valid_589444 = query.getOrDefault("key")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "key", valid_589444
  var valid_589445 = query.getOrDefault("$.xgafv")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = newJString("1"))
  if valid_589445 != nil:
    section.add "$.xgafv", valid_589445
  var valid_589446 = query.getOrDefault("prettyPrint")
  valid_589446 = validateParameter(valid_589446, JBool, required = false,
                                 default = newJBool(true))
  if valid_589446 != nil:
    section.add "prettyPrint", valid_589446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589447: Call_AppengineAppsLocationsGet_589431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_589447.validator(path, query, header, formData, body)
  let scheme = call_589447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589447.url(scheme.get, call_589447.host, call_589447.base,
                         call_589447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589447, url, valid)

proc call*(call_589448: Call_AppengineAppsLocationsGet_589431; appsId: string;
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
  var path_589449 = newJObject()
  var query_589450 = newJObject()
  add(query_589450, "upload_protocol", newJString(uploadProtocol))
  add(query_589450, "fields", newJString(fields))
  add(query_589450, "quotaUser", newJString(quotaUser))
  add(query_589450, "alt", newJString(alt))
  add(query_589450, "oauth_token", newJString(oauthToken))
  add(query_589450, "callback", newJString(callback))
  add(query_589450, "access_token", newJString(accessToken))
  add(query_589450, "uploadType", newJString(uploadType))
  add(query_589450, "key", newJString(key))
  add(path_589449, "appsId", newJString(appsId))
  add(query_589450, "$.xgafv", newJString(Xgafv))
  add(query_589450, "prettyPrint", newJBool(prettyPrint))
  add(path_589449, "locationsId", newJString(locationsId))
  result = call_589448.call(path_589449, query_589450, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_589431(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_589432, base: "/",
    url: url_AppengineAppsLocationsGet_589433, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_589451 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsOperationsList_589453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsList_589452(path: JsonNode; query: JsonNode;
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
  var valid_589454 = path.getOrDefault("appsId")
  valid_589454 = validateParameter(valid_589454, JString, required = true,
                                 default = nil)
  if valid_589454 != nil:
    section.add "appsId", valid_589454
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
  var valid_589455 = query.getOrDefault("upload_protocol")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "upload_protocol", valid_589455
  var valid_589456 = query.getOrDefault("fields")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "fields", valid_589456
  var valid_589457 = query.getOrDefault("pageToken")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "pageToken", valid_589457
  var valid_589458 = query.getOrDefault("quotaUser")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "quotaUser", valid_589458
  var valid_589459 = query.getOrDefault("alt")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = newJString("json"))
  if valid_589459 != nil:
    section.add "alt", valid_589459
  var valid_589460 = query.getOrDefault("oauth_token")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "oauth_token", valid_589460
  var valid_589461 = query.getOrDefault("callback")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "callback", valid_589461
  var valid_589462 = query.getOrDefault("access_token")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "access_token", valid_589462
  var valid_589463 = query.getOrDefault("uploadType")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "uploadType", valid_589463
  var valid_589464 = query.getOrDefault("key")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "key", valid_589464
  var valid_589465 = query.getOrDefault("$.xgafv")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = newJString("1"))
  if valid_589465 != nil:
    section.add "$.xgafv", valid_589465
  var valid_589466 = query.getOrDefault("pageSize")
  valid_589466 = validateParameter(valid_589466, JInt, required = false, default = nil)
  if valid_589466 != nil:
    section.add "pageSize", valid_589466
  var valid_589467 = query.getOrDefault("prettyPrint")
  valid_589467 = validateParameter(valid_589467, JBool, required = false,
                                 default = newJBool(true))
  if valid_589467 != nil:
    section.add "prettyPrint", valid_589467
  var valid_589468 = query.getOrDefault("filter")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "filter", valid_589468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589469: Call_AppengineAppsOperationsList_589451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_589469.validator(path, query, header, formData, body)
  let scheme = call_589469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589469.url(scheme.get, call_589469.host, call_589469.base,
                         call_589469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589469, url, valid)

proc call*(call_589470: Call_AppengineAppsOperationsList_589451; appsId: string;
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
  var path_589471 = newJObject()
  var query_589472 = newJObject()
  add(query_589472, "upload_protocol", newJString(uploadProtocol))
  add(query_589472, "fields", newJString(fields))
  add(query_589472, "pageToken", newJString(pageToken))
  add(query_589472, "quotaUser", newJString(quotaUser))
  add(query_589472, "alt", newJString(alt))
  add(query_589472, "oauth_token", newJString(oauthToken))
  add(query_589472, "callback", newJString(callback))
  add(query_589472, "access_token", newJString(accessToken))
  add(query_589472, "uploadType", newJString(uploadType))
  add(query_589472, "key", newJString(key))
  add(path_589471, "appsId", newJString(appsId))
  add(query_589472, "$.xgafv", newJString(Xgafv))
  add(query_589472, "pageSize", newJInt(pageSize))
  add(query_589472, "prettyPrint", newJBool(prettyPrint))
  add(query_589472, "filter", newJString(filter))
  result = call_589470.call(path_589471, query_589472, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_589451(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_589452, base: "/",
    url: url_AppengineAppsOperationsList_589453, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_589473 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsOperationsGet_589475(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "operationsId" in path, "`operationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsGet_589474(path: JsonNode; query: JsonNode;
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
  var valid_589476 = path.getOrDefault("appsId")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "appsId", valid_589476
  var valid_589477 = path.getOrDefault("operationsId")
  valid_589477 = validateParameter(valid_589477, JString, required = true,
                                 default = nil)
  if valid_589477 != nil:
    section.add "operationsId", valid_589477
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
  var valid_589478 = query.getOrDefault("upload_protocol")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "upload_protocol", valid_589478
  var valid_589479 = query.getOrDefault("fields")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "fields", valid_589479
  var valid_589480 = query.getOrDefault("quotaUser")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "quotaUser", valid_589480
  var valid_589481 = query.getOrDefault("alt")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = newJString("json"))
  if valid_589481 != nil:
    section.add "alt", valid_589481
  var valid_589482 = query.getOrDefault("oauth_token")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "oauth_token", valid_589482
  var valid_589483 = query.getOrDefault("callback")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "callback", valid_589483
  var valid_589484 = query.getOrDefault("access_token")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "access_token", valid_589484
  var valid_589485 = query.getOrDefault("uploadType")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "uploadType", valid_589485
  var valid_589486 = query.getOrDefault("key")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "key", valid_589486
  var valid_589487 = query.getOrDefault("$.xgafv")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = newJString("1"))
  if valid_589487 != nil:
    section.add "$.xgafv", valid_589487
  var valid_589488 = query.getOrDefault("prettyPrint")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(true))
  if valid_589488 != nil:
    section.add "prettyPrint", valid_589488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589489: Call_AppengineAppsOperationsGet_589473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_589489.validator(path, query, header, formData, body)
  let scheme = call_589489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589489.url(scheme.get, call_589489.host, call_589489.base,
                         call_589489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589489, url, valid)

proc call*(call_589490: Call_AppengineAppsOperationsGet_589473; appsId: string;
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
  var path_589491 = newJObject()
  var query_589492 = newJObject()
  add(query_589492, "upload_protocol", newJString(uploadProtocol))
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "callback", newJString(callback))
  add(query_589492, "access_token", newJString(accessToken))
  add(query_589492, "uploadType", newJString(uploadType))
  add(query_589492, "key", newJString(key))
  add(path_589491, "appsId", newJString(appsId))
  add(query_589492, "$.xgafv", newJString(Xgafv))
  add(path_589491, "operationsId", newJString(operationsId))
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  result = call_589490.call(path_589491, query_589492, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_589473(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_589474, base: "/",
    url: url_AppengineAppsOperationsGet_589475, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_589493 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesList_589495(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesList_589494(path: JsonNode; query: JsonNode;
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
  var valid_589496 = path.getOrDefault("appsId")
  valid_589496 = validateParameter(valid_589496, JString, required = true,
                                 default = nil)
  if valid_589496 != nil:
    section.add "appsId", valid_589496
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
  var valid_589497 = query.getOrDefault("upload_protocol")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "upload_protocol", valid_589497
  var valid_589498 = query.getOrDefault("fields")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "fields", valid_589498
  var valid_589499 = query.getOrDefault("pageToken")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "pageToken", valid_589499
  var valid_589500 = query.getOrDefault("quotaUser")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "quotaUser", valid_589500
  var valid_589501 = query.getOrDefault("alt")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = newJString("json"))
  if valid_589501 != nil:
    section.add "alt", valid_589501
  var valid_589502 = query.getOrDefault("oauth_token")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "oauth_token", valid_589502
  var valid_589503 = query.getOrDefault("callback")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "callback", valid_589503
  var valid_589504 = query.getOrDefault("access_token")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "access_token", valid_589504
  var valid_589505 = query.getOrDefault("uploadType")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "uploadType", valid_589505
  var valid_589506 = query.getOrDefault("key")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "key", valid_589506
  var valid_589507 = query.getOrDefault("$.xgafv")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = newJString("1"))
  if valid_589507 != nil:
    section.add "$.xgafv", valid_589507
  var valid_589508 = query.getOrDefault("pageSize")
  valid_589508 = validateParameter(valid_589508, JInt, required = false, default = nil)
  if valid_589508 != nil:
    section.add "pageSize", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589510: Call_AppengineAppsServicesList_589493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_589510.validator(path, query, header, formData, body)
  let scheme = call_589510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589510.url(scheme.get, call_589510.host, call_589510.base,
                         call_589510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589510, url, valid)

proc call*(call_589511: Call_AppengineAppsServicesList_589493; appsId: string;
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
  var path_589512 = newJObject()
  var query_589513 = newJObject()
  add(query_589513, "upload_protocol", newJString(uploadProtocol))
  add(query_589513, "fields", newJString(fields))
  add(query_589513, "pageToken", newJString(pageToken))
  add(query_589513, "quotaUser", newJString(quotaUser))
  add(query_589513, "alt", newJString(alt))
  add(query_589513, "oauth_token", newJString(oauthToken))
  add(query_589513, "callback", newJString(callback))
  add(query_589513, "access_token", newJString(accessToken))
  add(query_589513, "uploadType", newJString(uploadType))
  add(query_589513, "key", newJString(key))
  add(path_589512, "appsId", newJString(appsId))
  add(query_589513, "$.xgafv", newJString(Xgafv))
  add(query_589513, "pageSize", newJInt(pageSize))
  add(query_589513, "prettyPrint", newJBool(prettyPrint))
  result = call_589511.call(path_589512, query_589513, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_589493(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_589494, base: "/",
    url: url_AppengineAppsServicesList_589495, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_589514 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesGet_589516(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesGet_589515(path: JsonNode; query: JsonNode;
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
  var valid_589517 = path.getOrDefault("servicesId")
  valid_589517 = validateParameter(valid_589517, JString, required = true,
                                 default = nil)
  if valid_589517 != nil:
    section.add "servicesId", valid_589517
  var valid_589518 = path.getOrDefault("appsId")
  valid_589518 = validateParameter(valid_589518, JString, required = true,
                                 default = nil)
  if valid_589518 != nil:
    section.add "appsId", valid_589518
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
  var valid_589519 = query.getOrDefault("upload_protocol")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "upload_protocol", valid_589519
  var valid_589520 = query.getOrDefault("fields")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "fields", valid_589520
  var valid_589521 = query.getOrDefault("quotaUser")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "quotaUser", valid_589521
  var valid_589522 = query.getOrDefault("alt")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = newJString("json"))
  if valid_589522 != nil:
    section.add "alt", valid_589522
  var valid_589523 = query.getOrDefault("oauth_token")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "oauth_token", valid_589523
  var valid_589524 = query.getOrDefault("callback")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "callback", valid_589524
  var valid_589525 = query.getOrDefault("access_token")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "access_token", valid_589525
  var valid_589526 = query.getOrDefault("uploadType")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "uploadType", valid_589526
  var valid_589527 = query.getOrDefault("key")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "key", valid_589527
  var valid_589528 = query.getOrDefault("$.xgafv")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = newJString("1"))
  if valid_589528 != nil:
    section.add "$.xgafv", valid_589528
  var valid_589529 = query.getOrDefault("prettyPrint")
  valid_589529 = validateParameter(valid_589529, JBool, required = false,
                                 default = newJBool(true))
  if valid_589529 != nil:
    section.add "prettyPrint", valid_589529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589530: Call_AppengineAppsServicesGet_589514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_589530.validator(path, query, header, formData, body)
  let scheme = call_589530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589530.url(scheme.get, call_589530.host, call_589530.base,
                         call_589530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589530, url, valid)

proc call*(call_589531: Call_AppengineAppsServicesGet_589514; servicesId: string;
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
  var path_589532 = newJObject()
  var query_589533 = newJObject()
  add(query_589533, "upload_protocol", newJString(uploadProtocol))
  add(query_589533, "fields", newJString(fields))
  add(query_589533, "quotaUser", newJString(quotaUser))
  add(query_589533, "alt", newJString(alt))
  add(query_589533, "oauth_token", newJString(oauthToken))
  add(query_589533, "callback", newJString(callback))
  add(query_589533, "access_token", newJString(accessToken))
  add(query_589533, "uploadType", newJString(uploadType))
  add(path_589532, "servicesId", newJString(servicesId))
  add(query_589533, "key", newJString(key))
  add(path_589532, "appsId", newJString(appsId))
  add(query_589533, "$.xgafv", newJString(Xgafv))
  add(query_589533, "prettyPrint", newJBool(prettyPrint))
  result = call_589531.call(path_589532, query_589533, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_589514(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_589515, base: "/",
    url: url_AppengineAppsServicesGet_589516, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_589554 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesPatch_589556(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesPatch_589555(path: JsonNode; query: JsonNode;
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
  var valid_589557 = path.getOrDefault("servicesId")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "servicesId", valid_589557
  var valid_589558 = path.getOrDefault("appsId")
  valid_589558 = validateParameter(valid_589558, JString, required = true,
                                 default = nil)
  if valid_589558 != nil:
    section.add "appsId", valid_589558
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
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  section = newJObject()
  var valid_589559 = query.getOrDefault("upload_protocol")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "upload_protocol", valid_589559
  var valid_589560 = query.getOrDefault("fields")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "fields", valid_589560
  var valid_589561 = query.getOrDefault("quotaUser")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "quotaUser", valid_589561
  var valid_589562 = query.getOrDefault("alt")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = newJString("json"))
  if valid_589562 != nil:
    section.add "alt", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("callback")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "callback", valid_589564
  var valid_589565 = query.getOrDefault("access_token")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "access_token", valid_589565
  var valid_589566 = query.getOrDefault("uploadType")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "uploadType", valid_589566
  var valid_589567 = query.getOrDefault("key")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "key", valid_589567
  var valid_589568 = query.getOrDefault("$.xgafv")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = newJString("1"))
  if valid_589568 != nil:
    section.add "$.xgafv", valid_589568
  var valid_589569 = query.getOrDefault("prettyPrint")
  valid_589569 = validateParameter(valid_589569, JBool, required = false,
                                 default = newJBool(true))
  if valid_589569 != nil:
    section.add "prettyPrint", valid_589569
  var valid_589570 = query.getOrDefault("updateMask")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "updateMask", valid_589570
  var valid_589571 = query.getOrDefault("migrateTraffic")
  valid_589571 = validateParameter(valid_589571, JBool, required = false, default = nil)
  if valid_589571 != nil:
    section.add "migrateTraffic", valid_589571
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

proc call*(call_589573: Call_AppengineAppsServicesPatch_589554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_589573.validator(path, query, header, formData, body)
  let scheme = call_589573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589573.url(scheme.get, call_589573.host, call_589573.base,
                         call_589573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589573, url, valid)

proc call*(call_589574: Call_AppengineAppsServicesPatch_589554; servicesId: string;
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
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  var path_589575 = newJObject()
  var query_589576 = newJObject()
  var body_589577 = newJObject()
  add(query_589576, "upload_protocol", newJString(uploadProtocol))
  add(query_589576, "fields", newJString(fields))
  add(query_589576, "quotaUser", newJString(quotaUser))
  add(query_589576, "alt", newJString(alt))
  add(query_589576, "oauth_token", newJString(oauthToken))
  add(query_589576, "callback", newJString(callback))
  add(query_589576, "access_token", newJString(accessToken))
  add(query_589576, "uploadType", newJString(uploadType))
  add(path_589575, "servicesId", newJString(servicesId))
  add(query_589576, "key", newJString(key))
  add(path_589575, "appsId", newJString(appsId))
  add(query_589576, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589577 = body
  add(query_589576, "prettyPrint", newJBool(prettyPrint))
  add(query_589576, "updateMask", newJString(updateMask))
  add(query_589576, "migrateTraffic", newJBool(migrateTraffic))
  result = call_589574.call(path_589575, query_589576, nil, nil, body_589577)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_589554(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_589555, base: "/",
    url: url_AppengineAppsServicesPatch_589556, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_589534 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesDelete_589536(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesDelete_589535(path: JsonNode; query: JsonNode;
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
  var valid_589537 = path.getOrDefault("servicesId")
  valid_589537 = validateParameter(valid_589537, JString, required = true,
                                 default = nil)
  if valid_589537 != nil:
    section.add "servicesId", valid_589537
  var valid_589538 = path.getOrDefault("appsId")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "appsId", valid_589538
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
  var valid_589539 = query.getOrDefault("upload_protocol")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "upload_protocol", valid_589539
  var valid_589540 = query.getOrDefault("fields")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "fields", valid_589540
  var valid_589541 = query.getOrDefault("quotaUser")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "quotaUser", valid_589541
  var valid_589542 = query.getOrDefault("alt")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = newJString("json"))
  if valid_589542 != nil:
    section.add "alt", valid_589542
  var valid_589543 = query.getOrDefault("oauth_token")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "oauth_token", valid_589543
  var valid_589544 = query.getOrDefault("callback")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "callback", valid_589544
  var valid_589545 = query.getOrDefault("access_token")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "access_token", valid_589545
  var valid_589546 = query.getOrDefault("uploadType")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "uploadType", valid_589546
  var valid_589547 = query.getOrDefault("key")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "key", valid_589547
  var valid_589548 = query.getOrDefault("$.xgafv")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = newJString("1"))
  if valid_589548 != nil:
    section.add "$.xgafv", valid_589548
  var valid_589549 = query.getOrDefault("prettyPrint")
  valid_589549 = validateParameter(valid_589549, JBool, required = false,
                                 default = newJBool(true))
  if valid_589549 != nil:
    section.add "prettyPrint", valid_589549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589550: Call_AppengineAppsServicesDelete_589534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_589550.validator(path, query, header, formData, body)
  let scheme = call_589550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589550.url(scheme.get, call_589550.host, call_589550.base,
                         call_589550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589550, url, valid)

proc call*(call_589551: Call_AppengineAppsServicesDelete_589534;
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
  var path_589552 = newJObject()
  var query_589553 = newJObject()
  add(query_589553, "upload_protocol", newJString(uploadProtocol))
  add(query_589553, "fields", newJString(fields))
  add(query_589553, "quotaUser", newJString(quotaUser))
  add(query_589553, "alt", newJString(alt))
  add(query_589553, "oauth_token", newJString(oauthToken))
  add(query_589553, "callback", newJString(callback))
  add(query_589553, "access_token", newJString(accessToken))
  add(query_589553, "uploadType", newJString(uploadType))
  add(path_589552, "servicesId", newJString(servicesId))
  add(query_589553, "key", newJString(key))
  add(path_589552, "appsId", newJString(appsId))
  add(query_589553, "$.xgafv", newJString(Xgafv))
  add(query_589553, "prettyPrint", newJBool(prettyPrint))
  result = call_589551.call(path_589552, query_589553, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_589534(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_589535, base: "/",
    url: url_AppengineAppsServicesDelete_589536, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_589601 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsCreate_589603(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsCreate_589602(path: JsonNode;
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
  var valid_589604 = path.getOrDefault("servicesId")
  valid_589604 = validateParameter(valid_589604, JString, required = true,
                                 default = nil)
  if valid_589604 != nil:
    section.add "servicesId", valid_589604
  var valid_589605 = path.getOrDefault("appsId")
  valid_589605 = validateParameter(valid_589605, JString, required = true,
                                 default = nil)
  if valid_589605 != nil:
    section.add "appsId", valid_589605
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
  var valid_589606 = query.getOrDefault("upload_protocol")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "upload_protocol", valid_589606
  var valid_589607 = query.getOrDefault("fields")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "fields", valid_589607
  var valid_589608 = query.getOrDefault("quotaUser")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "quotaUser", valid_589608
  var valid_589609 = query.getOrDefault("alt")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = newJString("json"))
  if valid_589609 != nil:
    section.add "alt", valid_589609
  var valid_589610 = query.getOrDefault("oauth_token")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "oauth_token", valid_589610
  var valid_589611 = query.getOrDefault("callback")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "callback", valid_589611
  var valid_589612 = query.getOrDefault("access_token")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "access_token", valid_589612
  var valid_589613 = query.getOrDefault("uploadType")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "uploadType", valid_589613
  var valid_589614 = query.getOrDefault("key")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "key", valid_589614
  var valid_589615 = query.getOrDefault("$.xgafv")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = newJString("1"))
  if valid_589615 != nil:
    section.add "$.xgafv", valid_589615
  var valid_589616 = query.getOrDefault("prettyPrint")
  valid_589616 = validateParameter(valid_589616, JBool, required = false,
                                 default = newJBool(true))
  if valid_589616 != nil:
    section.add "prettyPrint", valid_589616
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

proc call*(call_589618: Call_AppengineAppsServicesVersionsCreate_589601;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_589618.validator(path, query, header, formData, body)
  let scheme = call_589618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589618.url(scheme.get, call_589618.host, call_589618.base,
                         call_589618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589618, url, valid)

proc call*(call_589619: Call_AppengineAppsServicesVersionsCreate_589601;
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
  var path_589620 = newJObject()
  var query_589621 = newJObject()
  var body_589622 = newJObject()
  add(query_589621, "upload_protocol", newJString(uploadProtocol))
  add(query_589621, "fields", newJString(fields))
  add(query_589621, "quotaUser", newJString(quotaUser))
  add(query_589621, "alt", newJString(alt))
  add(query_589621, "oauth_token", newJString(oauthToken))
  add(query_589621, "callback", newJString(callback))
  add(query_589621, "access_token", newJString(accessToken))
  add(query_589621, "uploadType", newJString(uploadType))
  add(path_589620, "servicesId", newJString(servicesId))
  add(query_589621, "key", newJString(key))
  add(path_589620, "appsId", newJString(appsId))
  add(query_589621, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589622 = body
  add(query_589621, "prettyPrint", newJBool(prettyPrint))
  result = call_589619.call(path_589620, query_589621, nil, nil, body_589622)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_589601(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_589602, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_589603, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_589578 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsList_589580(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsList_589579(path: JsonNode;
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
  var valid_589581 = path.getOrDefault("servicesId")
  valid_589581 = validateParameter(valid_589581, JString, required = true,
                                 default = nil)
  if valid_589581 != nil:
    section.add "servicesId", valid_589581
  var valid_589582 = path.getOrDefault("appsId")
  valid_589582 = validateParameter(valid_589582, JString, required = true,
                                 default = nil)
  if valid_589582 != nil:
    section.add "appsId", valid_589582
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
  var valid_589583 = query.getOrDefault("upload_protocol")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "upload_protocol", valid_589583
  var valid_589584 = query.getOrDefault("fields")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "fields", valid_589584
  var valid_589585 = query.getOrDefault("pageToken")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "pageToken", valid_589585
  var valid_589586 = query.getOrDefault("quotaUser")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "quotaUser", valid_589586
  var valid_589587 = query.getOrDefault("view")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589587 != nil:
    section.add "view", valid_589587
  var valid_589588 = query.getOrDefault("alt")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = newJString("json"))
  if valid_589588 != nil:
    section.add "alt", valid_589588
  var valid_589589 = query.getOrDefault("oauth_token")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "oauth_token", valid_589589
  var valid_589590 = query.getOrDefault("callback")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "callback", valid_589590
  var valid_589591 = query.getOrDefault("access_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "access_token", valid_589591
  var valid_589592 = query.getOrDefault("uploadType")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "uploadType", valid_589592
  var valid_589593 = query.getOrDefault("key")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "key", valid_589593
  var valid_589594 = query.getOrDefault("$.xgafv")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = newJString("1"))
  if valid_589594 != nil:
    section.add "$.xgafv", valid_589594
  var valid_589595 = query.getOrDefault("pageSize")
  valid_589595 = validateParameter(valid_589595, JInt, required = false, default = nil)
  if valid_589595 != nil:
    section.add "pageSize", valid_589595
  var valid_589596 = query.getOrDefault("prettyPrint")
  valid_589596 = validateParameter(valid_589596, JBool, required = false,
                                 default = newJBool(true))
  if valid_589596 != nil:
    section.add "prettyPrint", valid_589596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589597: Call_AppengineAppsServicesVersionsList_589578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_589597.validator(path, query, header, formData, body)
  let scheme = call_589597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589597.url(scheme.get, call_589597.host, call_589597.base,
                         call_589597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589597, url, valid)

proc call*(call_589598: Call_AppengineAppsServicesVersionsList_589578;
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
  var path_589599 = newJObject()
  var query_589600 = newJObject()
  add(query_589600, "upload_protocol", newJString(uploadProtocol))
  add(query_589600, "fields", newJString(fields))
  add(query_589600, "pageToken", newJString(pageToken))
  add(query_589600, "quotaUser", newJString(quotaUser))
  add(query_589600, "view", newJString(view))
  add(query_589600, "alt", newJString(alt))
  add(query_589600, "oauth_token", newJString(oauthToken))
  add(query_589600, "callback", newJString(callback))
  add(query_589600, "access_token", newJString(accessToken))
  add(query_589600, "uploadType", newJString(uploadType))
  add(path_589599, "servicesId", newJString(servicesId))
  add(query_589600, "key", newJString(key))
  add(path_589599, "appsId", newJString(appsId))
  add(query_589600, "$.xgafv", newJString(Xgafv))
  add(query_589600, "pageSize", newJInt(pageSize))
  add(query_589600, "prettyPrint", newJBool(prettyPrint))
  result = call_589598.call(path_589599, query_589600, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_589578(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_589579, base: "/",
    url: url_AppengineAppsServicesVersionsList_589580, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_589623 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsGet_589625(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsGet_589624(path: JsonNode;
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
  var valid_589626 = path.getOrDefault("versionsId")
  valid_589626 = validateParameter(valid_589626, JString, required = true,
                                 default = nil)
  if valid_589626 != nil:
    section.add "versionsId", valid_589626
  var valid_589627 = path.getOrDefault("servicesId")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "servicesId", valid_589627
  var valid_589628 = path.getOrDefault("appsId")
  valid_589628 = validateParameter(valid_589628, JString, required = true,
                                 default = nil)
  if valid_589628 != nil:
    section.add "appsId", valid_589628
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
  var valid_589629 = query.getOrDefault("upload_protocol")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "upload_protocol", valid_589629
  var valid_589630 = query.getOrDefault("fields")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "fields", valid_589630
  var valid_589631 = query.getOrDefault("view")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589631 != nil:
    section.add "view", valid_589631
  var valid_589632 = query.getOrDefault("quotaUser")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "quotaUser", valid_589632
  var valid_589633 = query.getOrDefault("alt")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = newJString("json"))
  if valid_589633 != nil:
    section.add "alt", valid_589633
  var valid_589634 = query.getOrDefault("oauth_token")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "oauth_token", valid_589634
  var valid_589635 = query.getOrDefault("callback")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "callback", valid_589635
  var valid_589636 = query.getOrDefault("access_token")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "access_token", valid_589636
  var valid_589637 = query.getOrDefault("uploadType")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "uploadType", valid_589637
  var valid_589638 = query.getOrDefault("key")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "key", valid_589638
  var valid_589639 = query.getOrDefault("$.xgafv")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = newJString("1"))
  if valid_589639 != nil:
    section.add "$.xgafv", valid_589639
  var valid_589640 = query.getOrDefault("prettyPrint")
  valid_589640 = validateParameter(valid_589640, JBool, required = false,
                                 default = newJBool(true))
  if valid_589640 != nil:
    section.add "prettyPrint", valid_589640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589641: Call_AppengineAppsServicesVersionsGet_589623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_589641.validator(path, query, header, formData, body)
  let scheme = call_589641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589641.url(scheme.get, call_589641.host, call_589641.base,
                         call_589641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589641, url, valid)

proc call*(call_589642: Call_AppengineAppsServicesVersionsGet_589623;
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
  var path_589643 = newJObject()
  var query_589644 = newJObject()
  add(query_589644, "upload_protocol", newJString(uploadProtocol))
  add(query_589644, "fields", newJString(fields))
  add(query_589644, "view", newJString(view))
  add(query_589644, "quotaUser", newJString(quotaUser))
  add(path_589643, "versionsId", newJString(versionsId))
  add(query_589644, "alt", newJString(alt))
  add(query_589644, "oauth_token", newJString(oauthToken))
  add(query_589644, "callback", newJString(callback))
  add(query_589644, "access_token", newJString(accessToken))
  add(query_589644, "uploadType", newJString(uploadType))
  add(path_589643, "servicesId", newJString(servicesId))
  add(query_589644, "key", newJString(key))
  add(path_589643, "appsId", newJString(appsId))
  add(query_589644, "$.xgafv", newJString(Xgafv))
  add(query_589644, "prettyPrint", newJBool(prettyPrint))
  result = call_589642.call(path_589643, query_589644, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_589623(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_589624, base: "/",
    url: url_AppengineAppsServicesVersionsGet_589625, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_589666 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsPatch_589668(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsPatch_589667(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
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
  var valid_589669 = path.getOrDefault("versionsId")
  valid_589669 = validateParameter(valid_589669, JString, required = true,
                                 default = nil)
  if valid_589669 != nil:
    section.add "versionsId", valid_589669
  var valid_589670 = path.getOrDefault("servicesId")
  valid_589670 = validateParameter(valid_589670, JString, required = true,
                                 default = nil)
  if valid_589670 != nil:
    section.add "servicesId", valid_589670
  var valid_589671 = path.getOrDefault("appsId")
  valid_589671 = validateParameter(valid_589671, JString, required = true,
                                 default = nil)
  if valid_589671 != nil:
    section.add "appsId", valid_589671
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
  var valid_589672 = query.getOrDefault("upload_protocol")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "upload_protocol", valid_589672
  var valid_589673 = query.getOrDefault("fields")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = nil)
  if valid_589673 != nil:
    section.add "fields", valid_589673
  var valid_589674 = query.getOrDefault("quotaUser")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "quotaUser", valid_589674
  var valid_589675 = query.getOrDefault("alt")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = newJString("json"))
  if valid_589675 != nil:
    section.add "alt", valid_589675
  var valid_589676 = query.getOrDefault("oauth_token")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "oauth_token", valid_589676
  var valid_589677 = query.getOrDefault("callback")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "callback", valid_589677
  var valid_589678 = query.getOrDefault("access_token")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "access_token", valid_589678
  var valid_589679 = query.getOrDefault("uploadType")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "uploadType", valid_589679
  var valid_589680 = query.getOrDefault("key")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "key", valid_589680
  var valid_589681 = query.getOrDefault("$.xgafv")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = newJString("1"))
  if valid_589681 != nil:
    section.add "$.xgafv", valid_589681
  var valid_589682 = query.getOrDefault("prettyPrint")
  valid_589682 = validateParameter(valid_589682, JBool, required = false,
                                 default = newJBool(true))
  if valid_589682 != nil:
    section.add "prettyPrint", valid_589682
  var valid_589683 = query.getOrDefault("updateMask")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "updateMask", valid_589683
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

proc call*(call_589685: Call_AppengineAppsServicesVersionsPatch_589666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## 
  let valid = call_589685.validator(path, query, header, formData, body)
  let scheme = call_589685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589685.url(scheme.get, call_589685.host, call_589685.base,
                         call_589685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589685, url, valid)

proc call*(call_589686: Call_AppengineAppsServicesVersionsPatch_589666;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## appengineAppsServicesVersionsPatch
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:Standard environment
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.instance_class)automatic scaling in the standard environment:
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automaticScaling.standard_scheduler_settings.max_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.min_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_cpu_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)
  ## automaticScaling.standard_scheduler_settings.target_throughput_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#StandardSchedulerSettings)basic scaling or manual scaling in the standard environment:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)Flexible environment
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.serving_status)automatic scaling in the flexible environment:
  ## automatic_scaling.min_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.max_total_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cool_down_period_sec (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
  ## automatic_scaling.cpu_utilization.target_utilization (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta/apps.services.versions#Version.FIELDS.automatic_scaling)
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
  var path_589687 = newJObject()
  var query_589688 = newJObject()
  var body_589689 = newJObject()
  add(query_589688, "upload_protocol", newJString(uploadProtocol))
  add(query_589688, "fields", newJString(fields))
  add(query_589688, "quotaUser", newJString(quotaUser))
  add(path_589687, "versionsId", newJString(versionsId))
  add(query_589688, "alt", newJString(alt))
  add(query_589688, "oauth_token", newJString(oauthToken))
  add(query_589688, "callback", newJString(callback))
  add(query_589688, "access_token", newJString(accessToken))
  add(query_589688, "uploadType", newJString(uploadType))
  add(path_589687, "servicesId", newJString(servicesId))
  add(query_589688, "key", newJString(key))
  add(path_589687, "appsId", newJString(appsId))
  add(query_589688, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589689 = body
  add(query_589688, "prettyPrint", newJBool(prettyPrint))
  add(query_589688, "updateMask", newJString(updateMask))
  result = call_589686.call(path_589687, query_589688, nil, nil, body_589689)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_589666(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_589667, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_589668, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_589645 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsDelete_589647(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsDelete_589646(path: JsonNode;
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
  var valid_589648 = path.getOrDefault("versionsId")
  valid_589648 = validateParameter(valid_589648, JString, required = true,
                                 default = nil)
  if valid_589648 != nil:
    section.add "versionsId", valid_589648
  var valid_589649 = path.getOrDefault("servicesId")
  valid_589649 = validateParameter(valid_589649, JString, required = true,
                                 default = nil)
  if valid_589649 != nil:
    section.add "servicesId", valid_589649
  var valid_589650 = path.getOrDefault("appsId")
  valid_589650 = validateParameter(valid_589650, JString, required = true,
                                 default = nil)
  if valid_589650 != nil:
    section.add "appsId", valid_589650
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
  var valid_589651 = query.getOrDefault("upload_protocol")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "upload_protocol", valid_589651
  var valid_589652 = query.getOrDefault("fields")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "fields", valid_589652
  var valid_589653 = query.getOrDefault("quotaUser")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "quotaUser", valid_589653
  var valid_589654 = query.getOrDefault("alt")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = newJString("json"))
  if valid_589654 != nil:
    section.add "alt", valid_589654
  var valid_589655 = query.getOrDefault("oauth_token")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "oauth_token", valid_589655
  var valid_589656 = query.getOrDefault("callback")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "callback", valid_589656
  var valid_589657 = query.getOrDefault("access_token")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "access_token", valid_589657
  var valid_589658 = query.getOrDefault("uploadType")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "uploadType", valid_589658
  var valid_589659 = query.getOrDefault("key")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "key", valid_589659
  var valid_589660 = query.getOrDefault("$.xgafv")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = newJString("1"))
  if valid_589660 != nil:
    section.add "$.xgafv", valid_589660
  var valid_589661 = query.getOrDefault("prettyPrint")
  valid_589661 = validateParameter(valid_589661, JBool, required = false,
                                 default = newJBool(true))
  if valid_589661 != nil:
    section.add "prettyPrint", valid_589661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589662: Call_AppengineAppsServicesVersionsDelete_589645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Version resource.
  ## 
  let valid = call_589662.validator(path, query, header, formData, body)
  let scheme = call_589662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589662.url(scheme.get, call_589662.host, call_589662.base,
                         call_589662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589662, url, valid)

proc call*(call_589663: Call_AppengineAppsServicesVersionsDelete_589645;
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
  var path_589664 = newJObject()
  var query_589665 = newJObject()
  add(query_589665, "upload_protocol", newJString(uploadProtocol))
  add(query_589665, "fields", newJString(fields))
  add(query_589665, "quotaUser", newJString(quotaUser))
  add(path_589664, "versionsId", newJString(versionsId))
  add(query_589665, "alt", newJString(alt))
  add(query_589665, "oauth_token", newJString(oauthToken))
  add(query_589665, "callback", newJString(callback))
  add(query_589665, "access_token", newJString(accessToken))
  add(query_589665, "uploadType", newJString(uploadType))
  add(path_589664, "servicesId", newJString(servicesId))
  add(query_589665, "key", newJString(key))
  add(path_589664, "appsId", newJString(appsId))
  add(query_589665, "$.xgafv", newJString(Xgafv))
  add(query_589665, "prettyPrint", newJBool(prettyPrint))
  result = call_589663.call(path_589664, query_589665, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_589645(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_589646, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_589647, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_589690 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsInstancesList_589692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesList_589691(path: JsonNode;
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
  var valid_589693 = path.getOrDefault("versionsId")
  valid_589693 = validateParameter(valid_589693, JString, required = true,
                                 default = nil)
  if valid_589693 != nil:
    section.add "versionsId", valid_589693
  var valid_589694 = path.getOrDefault("servicesId")
  valid_589694 = validateParameter(valid_589694, JString, required = true,
                                 default = nil)
  if valid_589694 != nil:
    section.add "servicesId", valid_589694
  var valid_589695 = path.getOrDefault("appsId")
  valid_589695 = validateParameter(valid_589695, JString, required = true,
                                 default = nil)
  if valid_589695 != nil:
    section.add "appsId", valid_589695
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
  var valid_589696 = query.getOrDefault("upload_protocol")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "upload_protocol", valid_589696
  var valid_589697 = query.getOrDefault("fields")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "fields", valid_589697
  var valid_589698 = query.getOrDefault("pageToken")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "pageToken", valid_589698
  var valid_589699 = query.getOrDefault("quotaUser")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "quotaUser", valid_589699
  var valid_589700 = query.getOrDefault("alt")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = newJString("json"))
  if valid_589700 != nil:
    section.add "alt", valid_589700
  var valid_589701 = query.getOrDefault("oauth_token")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "oauth_token", valid_589701
  var valid_589702 = query.getOrDefault("callback")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "callback", valid_589702
  var valid_589703 = query.getOrDefault("access_token")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "access_token", valid_589703
  var valid_589704 = query.getOrDefault("uploadType")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "uploadType", valid_589704
  var valid_589705 = query.getOrDefault("key")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "key", valid_589705
  var valid_589706 = query.getOrDefault("$.xgafv")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = newJString("1"))
  if valid_589706 != nil:
    section.add "$.xgafv", valid_589706
  var valid_589707 = query.getOrDefault("pageSize")
  valid_589707 = validateParameter(valid_589707, JInt, required = false, default = nil)
  if valid_589707 != nil:
    section.add "pageSize", valid_589707
  var valid_589708 = query.getOrDefault("prettyPrint")
  valid_589708 = validateParameter(valid_589708, JBool, required = false,
                                 default = newJBool(true))
  if valid_589708 != nil:
    section.add "prettyPrint", valid_589708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589709: Call_AppengineAppsServicesVersionsInstancesList_589690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_589709.validator(path, query, header, formData, body)
  let scheme = call_589709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589709.url(scheme.get, call_589709.host, call_589709.base,
                         call_589709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589709, url, valid)

proc call*(call_589710: Call_AppengineAppsServicesVersionsInstancesList_589690;
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
  var path_589711 = newJObject()
  var query_589712 = newJObject()
  add(query_589712, "upload_protocol", newJString(uploadProtocol))
  add(query_589712, "fields", newJString(fields))
  add(query_589712, "pageToken", newJString(pageToken))
  add(query_589712, "quotaUser", newJString(quotaUser))
  add(path_589711, "versionsId", newJString(versionsId))
  add(query_589712, "alt", newJString(alt))
  add(query_589712, "oauth_token", newJString(oauthToken))
  add(query_589712, "callback", newJString(callback))
  add(query_589712, "access_token", newJString(accessToken))
  add(query_589712, "uploadType", newJString(uploadType))
  add(path_589711, "servicesId", newJString(servicesId))
  add(query_589712, "key", newJString(key))
  add(path_589711, "appsId", newJString(appsId))
  add(query_589712, "$.xgafv", newJString(Xgafv))
  add(query_589712, "pageSize", newJInt(pageSize))
  add(query_589712, "prettyPrint", newJBool(prettyPrint))
  result = call_589710.call(path_589711, query_589712, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_589690(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_589691,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_589692,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_589713 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsInstancesGet_589715(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesGet_589714(path: JsonNode;
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
  var valid_589716 = path.getOrDefault("versionsId")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "versionsId", valid_589716
  var valid_589717 = path.getOrDefault("instancesId")
  valid_589717 = validateParameter(valid_589717, JString, required = true,
                                 default = nil)
  if valid_589717 != nil:
    section.add "instancesId", valid_589717
  var valid_589718 = path.getOrDefault("servicesId")
  valid_589718 = validateParameter(valid_589718, JString, required = true,
                                 default = nil)
  if valid_589718 != nil:
    section.add "servicesId", valid_589718
  var valid_589719 = path.getOrDefault("appsId")
  valid_589719 = validateParameter(valid_589719, JString, required = true,
                                 default = nil)
  if valid_589719 != nil:
    section.add "appsId", valid_589719
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
  var valid_589720 = query.getOrDefault("upload_protocol")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "upload_protocol", valid_589720
  var valid_589721 = query.getOrDefault("fields")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "fields", valid_589721
  var valid_589722 = query.getOrDefault("quotaUser")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "quotaUser", valid_589722
  var valid_589723 = query.getOrDefault("alt")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = newJString("json"))
  if valid_589723 != nil:
    section.add "alt", valid_589723
  var valid_589724 = query.getOrDefault("oauth_token")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "oauth_token", valid_589724
  var valid_589725 = query.getOrDefault("callback")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "callback", valid_589725
  var valid_589726 = query.getOrDefault("access_token")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "access_token", valid_589726
  var valid_589727 = query.getOrDefault("uploadType")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "uploadType", valid_589727
  var valid_589728 = query.getOrDefault("key")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "key", valid_589728
  var valid_589729 = query.getOrDefault("$.xgafv")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = newJString("1"))
  if valid_589729 != nil:
    section.add "$.xgafv", valid_589729
  var valid_589730 = query.getOrDefault("prettyPrint")
  valid_589730 = validateParameter(valid_589730, JBool, required = false,
                                 default = newJBool(true))
  if valid_589730 != nil:
    section.add "prettyPrint", valid_589730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589731: Call_AppengineAppsServicesVersionsInstancesGet_589713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_589731.validator(path, query, header, formData, body)
  let scheme = call_589731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589731.url(scheme.get, call_589731.host, call_589731.base,
                         call_589731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589731, url, valid)

proc call*(call_589732: Call_AppengineAppsServicesVersionsInstancesGet_589713;
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
  var path_589733 = newJObject()
  var query_589734 = newJObject()
  add(query_589734, "upload_protocol", newJString(uploadProtocol))
  add(query_589734, "fields", newJString(fields))
  add(query_589734, "quotaUser", newJString(quotaUser))
  add(path_589733, "versionsId", newJString(versionsId))
  add(query_589734, "alt", newJString(alt))
  add(path_589733, "instancesId", newJString(instancesId))
  add(query_589734, "oauth_token", newJString(oauthToken))
  add(query_589734, "callback", newJString(callback))
  add(query_589734, "access_token", newJString(accessToken))
  add(query_589734, "uploadType", newJString(uploadType))
  add(path_589733, "servicesId", newJString(servicesId))
  add(query_589734, "key", newJString(key))
  add(path_589733, "appsId", newJString(appsId))
  add(query_589734, "$.xgafv", newJString(Xgafv))
  add(query_589734, "prettyPrint", newJBool(prettyPrint))
  result = call_589732.call(path_589733, query_589734, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_589713(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_589714,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_589715,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_589735 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsInstancesDelete_589737(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesDelete_589736(path: JsonNode;
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
  var valid_589738 = path.getOrDefault("versionsId")
  valid_589738 = validateParameter(valid_589738, JString, required = true,
                                 default = nil)
  if valid_589738 != nil:
    section.add "versionsId", valid_589738
  var valid_589739 = path.getOrDefault("instancesId")
  valid_589739 = validateParameter(valid_589739, JString, required = true,
                                 default = nil)
  if valid_589739 != nil:
    section.add "instancesId", valid_589739
  var valid_589740 = path.getOrDefault("servicesId")
  valid_589740 = validateParameter(valid_589740, JString, required = true,
                                 default = nil)
  if valid_589740 != nil:
    section.add "servicesId", valid_589740
  var valid_589741 = path.getOrDefault("appsId")
  valid_589741 = validateParameter(valid_589741, JString, required = true,
                                 default = nil)
  if valid_589741 != nil:
    section.add "appsId", valid_589741
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
  var valid_589742 = query.getOrDefault("upload_protocol")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "upload_protocol", valid_589742
  var valid_589743 = query.getOrDefault("fields")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "fields", valid_589743
  var valid_589744 = query.getOrDefault("quotaUser")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "quotaUser", valid_589744
  var valid_589745 = query.getOrDefault("alt")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = newJString("json"))
  if valid_589745 != nil:
    section.add "alt", valid_589745
  var valid_589746 = query.getOrDefault("oauth_token")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "oauth_token", valid_589746
  var valid_589747 = query.getOrDefault("callback")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "callback", valid_589747
  var valid_589748 = query.getOrDefault("access_token")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "access_token", valid_589748
  var valid_589749 = query.getOrDefault("uploadType")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "uploadType", valid_589749
  var valid_589750 = query.getOrDefault("key")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "key", valid_589750
  var valid_589751 = query.getOrDefault("$.xgafv")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = newJString("1"))
  if valid_589751 != nil:
    section.add "$.xgafv", valid_589751
  var valid_589752 = query.getOrDefault("prettyPrint")
  valid_589752 = validateParameter(valid_589752, JBool, required = false,
                                 default = newJBool(true))
  if valid_589752 != nil:
    section.add "prettyPrint", valid_589752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589753: Call_AppengineAppsServicesVersionsInstancesDelete_589735;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_589753.validator(path, query, header, formData, body)
  let scheme = call_589753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589753.url(scheme.get, call_589753.host, call_589753.base,
                         call_589753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589753, url, valid)

proc call*(call_589754: Call_AppengineAppsServicesVersionsInstancesDelete_589735;
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
  var path_589755 = newJObject()
  var query_589756 = newJObject()
  add(query_589756, "upload_protocol", newJString(uploadProtocol))
  add(query_589756, "fields", newJString(fields))
  add(query_589756, "quotaUser", newJString(quotaUser))
  add(path_589755, "versionsId", newJString(versionsId))
  add(query_589756, "alt", newJString(alt))
  add(path_589755, "instancesId", newJString(instancesId))
  add(query_589756, "oauth_token", newJString(oauthToken))
  add(query_589756, "callback", newJString(callback))
  add(query_589756, "access_token", newJString(accessToken))
  add(query_589756, "uploadType", newJString(uploadType))
  add(path_589755, "servicesId", newJString(servicesId))
  add(query_589756, "key", newJString(key))
  add(path_589755, "appsId", newJString(appsId))
  add(query_589756, "$.xgafv", newJString(Xgafv))
  add(query_589756, "prettyPrint", newJBool(prettyPrint))
  result = call_589754.call(path_589755, query_589756, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_589735(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_589736,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_589737,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_589757 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsServicesVersionsInstancesDebug_589759(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesDebug_589758(path: JsonNode;
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
  var valid_589760 = path.getOrDefault("versionsId")
  valid_589760 = validateParameter(valid_589760, JString, required = true,
                                 default = nil)
  if valid_589760 != nil:
    section.add "versionsId", valid_589760
  var valid_589761 = path.getOrDefault("instancesId")
  valid_589761 = validateParameter(valid_589761, JString, required = true,
                                 default = nil)
  if valid_589761 != nil:
    section.add "instancesId", valid_589761
  var valid_589762 = path.getOrDefault("servicesId")
  valid_589762 = validateParameter(valid_589762, JString, required = true,
                                 default = nil)
  if valid_589762 != nil:
    section.add "servicesId", valid_589762
  var valid_589763 = path.getOrDefault("appsId")
  valid_589763 = validateParameter(valid_589763, JString, required = true,
                                 default = nil)
  if valid_589763 != nil:
    section.add "appsId", valid_589763
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
  var valid_589764 = query.getOrDefault("upload_protocol")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "upload_protocol", valid_589764
  var valid_589765 = query.getOrDefault("fields")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "fields", valid_589765
  var valid_589766 = query.getOrDefault("quotaUser")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "quotaUser", valid_589766
  var valid_589767 = query.getOrDefault("alt")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = newJString("json"))
  if valid_589767 != nil:
    section.add "alt", valid_589767
  var valid_589768 = query.getOrDefault("oauth_token")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "oauth_token", valid_589768
  var valid_589769 = query.getOrDefault("callback")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "callback", valid_589769
  var valid_589770 = query.getOrDefault("access_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "access_token", valid_589770
  var valid_589771 = query.getOrDefault("uploadType")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "uploadType", valid_589771
  var valid_589772 = query.getOrDefault("key")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = nil)
  if valid_589772 != nil:
    section.add "key", valid_589772
  var valid_589773 = query.getOrDefault("$.xgafv")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = newJString("1"))
  if valid_589773 != nil:
    section.add "$.xgafv", valid_589773
  var valid_589774 = query.getOrDefault("prettyPrint")
  valid_589774 = validateParameter(valid_589774, JBool, required = false,
                                 default = newJBool(true))
  if valid_589774 != nil:
    section.add "prettyPrint", valid_589774
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

proc call*(call_589776: Call_AppengineAppsServicesVersionsInstancesDebug_589757;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_589776.validator(path, query, header, formData, body)
  let scheme = call_589776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589776.url(scheme.get, call_589776.host, call_589776.base,
                         call_589776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589776, url, valid)

proc call*(call_589777: Call_AppengineAppsServicesVersionsInstancesDebug_589757;
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
  var path_589778 = newJObject()
  var query_589779 = newJObject()
  var body_589780 = newJObject()
  add(query_589779, "upload_protocol", newJString(uploadProtocol))
  add(query_589779, "fields", newJString(fields))
  add(query_589779, "quotaUser", newJString(quotaUser))
  add(path_589778, "versionsId", newJString(versionsId))
  add(query_589779, "alt", newJString(alt))
  add(path_589778, "instancesId", newJString(instancesId))
  add(query_589779, "oauth_token", newJString(oauthToken))
  add(query_589779, "callback", newJString(callback))
  add(query_589779, "access_token", newJString(accessToken))
  add(query_589779, "uploadType", newJString(uploadType))
  add(path_589778, "servicesId", newJString(servicesId))
  add(query_589779, "key", newJString(key))
  add(path_589778, "appsId", newJString(appsId))
  add(query_589779, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589780 = body
  add(query_589779, "prettyPrint", newJBool(prettyPrint))
  result = call_589777.call(path_589778, query_589779, nil, nil, body_589780)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_589757(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_589758,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_589759,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsRepair_589781 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsRepair_589783(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: ":repair")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsRepair_589782(path: JsonNode; query: JsonNode;
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
  var valid_589784 = path.getOrDefault("appsId")
  valid_589784 = validateParameter(valid_589784, JString, required = true,
                                 default = nil)
  if valid_589784 != nil:
    section.add "appsId", valid_589784
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
  var valid_589785 = query.getOrDefault("upload_protocol")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "upload_protocol", valid_589785
  var valid_589786 = query.getOrDefault("fields")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "fields", valid_589786
  var valid_589787 = query.getOrDefault("quotaUser")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "quotaUser", valid_589787
  var valid_589788 = query.getOrDefault("alt")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = newJString("json"))
  if valid_589788 != nil:
    section.add "alt", valid_589788
  var valid_589789 = query.getOrDefault("oauth_token")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "oauth_token", valid_589789
  var valid_589790 = query.getOrDefault("callback")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "callback", valid_589790
  var valid_589791 = query.getOrDefault("access_token")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "access_token", valid_589791
  var valid_589792 = query.getOrDefault("uploadType")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "uploadType", valid_589792
  var valid_589793 = query.getOrDefault("key")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "key", valid_589793
  var valid_589794 = query.getOrDefault("$.xgafv")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = newJString("1"))
  if valid_589794 != nil:
    section.add "$.xgafv", valid_589794
  var valid_589795 = query.getOrDefault("prettyPrint")
  valid_589795 = validateParameter(valid_589795, JBool, required = false,
                                 default = newJBool(true))
  if valid_589795 != nil:
    section.add "prettyPrint", valid_589795
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

proc call*(call_589797: Call_AppengineAppsRepair_589781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
  ## 
  let valid = call_589797.validator(path, query, header, formData, body)
  let scheme = call_589797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589797.url(scheme.get, call_589797.host, call_589797.base,
                         call_589797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589797, url, valid)

proc call*(call_589798: Call_AppengineAppsRepair_589781; appsId: string;
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
  var path_589799 = newJObject()
  var query_589800 = newJObject()
  var body_589801 = newJObject()
  add(query_589800, "upload_protocol", newJString(uploadProtocol))
  add(query_589800, "fields", newJString(fields))
  add(query_589800, "quotaUser", newJString(quotaUser))
  add(query_589800, "alt", newJString(alt))
  add(query_589800, "oauth_token", newJString(oauthToken))
  add(query_589800, "callback", newJString(callback))
  add(query_589800, "access_token", newJString(accessToken))
  add(query_589800, "uploadType", newJString(uploadType))
  add(query_589800, "key", newJString(key))
  add(path_589799, "appsId", newJString(appsId))
  add(query_589800, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589801 = body
  add(query_589800, "prettyPrint", newJBool(prettyPrint))
  result = call_589798.call(path_589799, query_589800, nil, nil, body_589801)

var appengineAppsRepair* = Call_AppengineAppsRepair_589781(
    name: "appengineAppsRepair", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}:repair",
    validator: validate_AppengineAppsRepair_589782, base: "/",
    url: url_AppengineAppsRepair_589783, schemes: {Scheme.Https})
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
