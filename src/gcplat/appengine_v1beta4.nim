
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
    host: "appengine.googleapis.com", route: "/v1beta4/apps",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
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
  ##   ensureResourcesExist: JBool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete.
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
  var valid_589022 = query.getOrDefault("ensureResourcesExist")
  valid_589022 = validateParameter(valid_589022, JBool, required = false, default = nil)
  if valid_589022 != nil:
    section.add "ensureResourcesExist", valid_589022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589023: Call_AppengineAppsGet_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_589023.validator(path, query, header, formData, body)
  let scheme = call_589023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589023.url(scheme.get, call_589023.host, call_589023.base,
                         call_589023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589023, url, valid)

proc call*(call_589024: Call_AppengineAppsGet_588993; appsId: string;
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
  var path_589025 = newJObject()
  var query_589026 = newJObject()
  add(query_589026, "upload_protocol", newJString(uploadProtocol))
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "callback", newJString(callback))
  add(query_589026, "access_token", newJString(accessToken))
  add(query_589026, "uploadType", newJString(uploadType))
  add(query_589026, "key", newJString(key))
  add(path_589025, "appsId", newJString(appsId))
  add(query_589026, "$.xgafv", newJString(Xgafv))
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  add(query_589026, "ensureResourcesExist", newJBool(ensureResourcesExist))
  result = call_589024.call(path_589025, query_589026, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_588993(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}", validator: validate_AppengineAppsGet_588994,
    base: "/", url: url_AppengineAppsGet_588995, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_589027 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsPatch_589029(protocol: Scheme; host: string; base: string;
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

proc validate_AppengineAppsPatch_589028(path: JsonNode; query: JsonNode;
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
  var valid_589030 = path.getOrDefault("appsId")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "appsId", valid_589030
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
  var valid_589031 = query.getOrDefault("upload_protocol")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "upload_protocol", valid_589031
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("alt")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("json"))
  if valid_589034 != nil:
    section.add "alt", valid_589034
  var valid_589035 = query.getOrDefault("oauth_token")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "oauth_token", valid_589035
  var valid_589036 = query.getOrDefault("callback")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "callback", valid_589036
  var valid_589037 = query.getOrDefault("access_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "access_token", valid_589037
  var valid_589038 = query.getOrDefault("uploadType")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "uploadType", valid_589038
  var valid_589039 = query.getOrDefault("mask")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "mask", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("$.xgafv")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("1"))
  if valid_589041 != nil:
    section.add "$.xgafv", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
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

proc call*(call_589044: Call_AppengineAppsPatch_589027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_AppengineAppsPatch_589027; appsId: string;
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
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  var body_589048 = newJObject()
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(query_589047, "mask", newJString(mask))
  add(query_589047, "key", newJString(key))
  add(path_589046, "appsId", newJString(appsId))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589048 = body
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, body_589048)

var appengineAppsPatch* = Call_AppengineAppsPatch_589027(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}",
    validator: validate_AppengineAppsPatch_589028, base: "/",
    url: url_AppengineAppsPatch_589029, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_589049 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsLocationsList_589051(protocol: Scheme; host: string;
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

proc validate_AppengineAppsLocationsList_589050(path: JsonNode; query: JsonNode;
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
  var valid_589052 = path.getOrDefault("appsId")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "appsId", valid_589052
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
  var valid_589053 = query.getOrDefault("upload_protocol")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "upload_protocol", valid_589053
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("pageToken")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "pageToken", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
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
  var valid_589066 = query.getOrDefault("filter")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "filter", valid_589066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589067: Call_AppengineAppsLocationsList_589049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_AppengineAppsLocationsList_589049; appsId: string;
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
  var path_589069 = newJObject()
  var query_589070 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "pageToken", newJString(pageToken))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "key", newJString(key))
  add(path_589069, "appsId", newJString(appsId))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  add(query_589070, "pageSize", newJInt(pageSize))
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  add(query_589070, "filter", newJString(filter))
  result = call_589068.call(path_589069, query_589070, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_589049(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_589050, base: "/",
    url: url_AppengineAppsLocationsList_589051, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_589071 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsLocationsGet_589073(protocol: Scheme; host: string;
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

proc validate_AppengineAppsLocationsGet_589072(path: JsonNode; query: JsonNode;
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
  var valid_589074 = path.getOrDefault("appsId")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "appsId", valid_589074
  var valid_589075 = path.getOrDefault("locationsId")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "locationsId", valid_589075
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
  var valid_589076 = query.getOrDefault("upload_protocol")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "upload_protocol", valid_589076
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("quotaUser")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "quotaUser", valid_589078
  var valid_589079 = query.getOrDefault("alt")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = newJString("json"))
  if valid_589079 != nil:
    section.add "alt", valid_589079
  var valid_589080 = query.getOrDefault("oauth_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "oauth_token", valid_589080
  var valid_589081 = query.getOrDefault("callback")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "callback", valid_589081
  var valid_589082 = query.getOrDefault("access_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "access_token", valid_589082
  var valid_589083 = query.getOrDefault("uploadType")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "uploadType", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("$.xgafv")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("1"))
  if valid_589085 != nil:
    section.add "$.xgafv", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589087: Call_AppengineAppsLocationsGet_589071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_AppengineAppsLocationsGet_589071; appsId: string;
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
  var path_589089 = newJObject()
  var query_589090 = newJObject()
  add(query_589090, "upload_protocol", newJString(uploadProtocol))
  add(query_589090, "fields", newJString(fields))
  add(query_589090, "quotaUser", newJString(quotaUser))
  add(query_589090, "alt", newJString(alt))
  add(query_589090, "oauth_token", newJString(oauthToken))
  add(query_589090, "callback", newJString(callback))
  add(query_589090, "access_token", newJString(accessToken))
  add(query_589090, "uploadType", newJString(uploadType))
  add(query_589090, "key", newJString(key))
  add(path_589089, "appsId", newJString(appsId))
  add(query_589090, "$.xgafv", newJString(Xgafv))
  add(query_589090, "prettyPrint", newJBool(prettyPrint))
  add(path_589089, "locationsId", newJString(locationsId))
  result = call_589088.call(path_589089, query_589090, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_589071(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_589072, base: "/",
    url: url_AppengineAppsLocationsGet_589073, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesList_589091 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesList_589093(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesList_589092(path: JsonNode; query: JsonNode;
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
  var valid_589094 = path.getOrDefault("appsId")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "appsId", valid_589094
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
  var valid_589095 = query.getOrDefault("upload_protocol")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "upload_protocol", valid_589095
  var valid_589096 = query.getOrDefault("fields")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "fields", valid_589096
  var valid_589097 = query.getOrDefault("pageToken")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "pageToken", valid_589097
  var valid_589098 = query.getOrDefault("quotaUser")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "quotaUser", valid_589098
  var valid_589099 = query.getOrDefault("alt")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("json"))
  if valid_589099 != nil:
    section.add "alt", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("callback")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "callback", valid_589101
  var valid_589102 = query.getOrDefault("access_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "access_token", valid_589102
  var valid_589103 = query.getOrDefault("uploadType")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "uploadType", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("$.xgafv")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("1"))
  if valid_589105 != nil:
    section.add "$.xgafv", valid_589105
  var valid_589106 = query.getOrDefault("pageSize")
  valid_589106 = validateParameter(valid_589106, JInt, required = false, default = nil)
  if valid_589106 != nil:
    section.add "pageSize", valid_589106
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

proc call*(call_589108: Call_AppengineAppsModulesList_589091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the modules in the application.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_AppengineAppsModulesList_589091; appsId: string;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "upload_protocol", newJString(uploadProtocol))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "pageToken", newJString(pageToken))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "callback", newJString(callback))
  add(query_589111, "access_token", newJString(accessToken))
  add(query_589111, "uploadType", newJString(uploadType))
  add(query_589111, "key", newJString(key))
  add(path_589110, "appsId", newJString(appsId))
  add(query_589111, "$.xgafv", newJString(Xgafv))
  add(query_589111, "pageSize", newJInt(pageSize))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var appengineAppsModulesList* = Call_AppengineAppsModulesList_589091(
    name: "appengineAppsModulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules",
    validator: validate_AppengineAppsModulesList_589092, base: "/",
    url: url_AppengineAppsModulesList_589093, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesGet_589112 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesGet_589114(protocol: Scheme; host: string; base: string;
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

proc validate_AppengineAppsModulesGet_589113(path: JsonNode; query: JsonNode;
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
  var valid_589115 = path.getOrDefault("modulesId")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "modulesId", valid_589115
  var valid_589116 = path.getOrDefault("appsId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "appsId", valid_589116
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

proc call*(call_589128: Call_AppengineAppsModulesGet_589112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified module.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_AppengineAppsModulesGet_589112; modulesId: string;
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
  add(path_589130, "modulesId", newJString(modulesId))
  add(query_589131, "key", newJString(key))
  add(path_589130, "appsId", newJString(appsId))
  add(query_589131, "$.xgafv", newJString(Xgafv))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var appengineAppsModulesGet* = Call_AppengineAppsModulesGet_589112(
    name: "appengineAppsModulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesGet_589113, base: "/",
    url: url_AppengineAppsModulesGet_589114, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesPatch_589152 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesPatch_589154(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesPatch_589153(path: JsonNode; query: JsonNode;
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
  var valid_589155 = path.getOrDefault("modulesId")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "modulesId", valid_589155
  var valid_589156 = path.getOrDefault("appsId")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "appsId", valid_589156
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
  var valid_589157 = query.getOrDefault("upload_protocol")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "upload_protocol", valid_589157
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("callback")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "callback", valid_589162
  var valid_589163 = query.getOrDefault("access_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "access_token", valid_589163
  var valid_589164 = query.getOrDefault("uploadType")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "uploadType", valid_589164
  var valid_589165 = query.getOrDefault("mask")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "mask", valid_589165
  var valid_589166 = query.getOrDefault("key")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "key", valid_589166
  var valid_589167 = query.getOrDefault("$.xgafv")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("1"))
  if valid_589167 != nil:
    section.add "$.xgafv", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
  var valid_589169 = query.getOrDefault("migrateTraffic")
  valid_589169 = validateParameter(valid_589169, JBool, required = false, default = nil)
  if valid_589169 != nil:
    section.add "migrateTraffic", valid_589169
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

proc call*(call_589171: Call_AppengineAppsModulesPatch_589152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified module.
  ## 
  let valid = call_589171.validator(path, query, header, formData, body)
  let scheme = call_589171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589171.url(scheme.get, call_589171.host, call_589171.base,
                         call_589171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589171, url, valid)

proc call*(call_589172: Call_AppengineAppsModulesPatch_589152; modulesId: string;
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
  var path_589173 = newJObject()
  var query_589174 = newJObject()
  var body_589175 = newJObject()
  add(query_589174, "upload_protocol", newJString(uploadProtocol))
  add(query_589174, "fields", newJString(fields))
  add(query_589174, "quotaUser", newJString(quotaUser))
  add(query_589174, "alt", newJString(alt))
  add(query_589174, "oauth_token", newJString(oauthToken))
  add(query_589174, "callback", newJString(callback))
  add(query_589174, "access_token", newJString(accessToken))
  add(query_589174, "uploadType", newJString(uploadType))
  add(query_589174, "mask", newJString(mask))
  add(path_589173, "modulesId", newJString(modulesId))
  add(query_589174, "key", newJString(key))
  add(path_589173, "appsId", newJString(appsId))
  add(query_589174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589175 = body
  add(query_589174, "prettyPrint", newJBool(prettyPrint))
  add(query_589174, "migrateTraffic", newJBool(migrateTraffic))
  result = call_589172.call(path_589173, query_589174, nil, nil, body_589175)

var appengineAppsModulesPatch* = Call_AppengineAppsModulesPatch_589152(
    name: "appengineAppsModulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesPatch_589153, base: "/",
    url: url_AppengineAppsModulesPatch_589154, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesDelete_589132 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesDelete_589134(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesDelete_589133(path: JsonNode; query: JsonNode;
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
  var valid_589135 = path.getOrDefault("modulesId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "modulesId", valid_589135
  var valid_589136 = path.getOrDefault("appsId")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "appsId", valid_589136
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589148: Call_AppengineAppsModulesDelete_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified module and all enclosed versions.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_AppengineAppsModulesDelete_589132; modulesId: string;
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
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  add(query_589151, "upload_protocol", newJString(uploadProtocol))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "callback", newJString(callback))
  add(query_589151, "access_token", newJString(accessToken))
  add(query_589151, "uploadType", newJString(uploadType))
  add(path_589150, "modulesId", newJString(modulesId))
  add(query_589151, "key", newJString(key))
  add(path_589150, "appsId", newJString(appsId))
  add(query_589151, "$.xgafv", newJString(Xgafv))
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, nil)

var appengineAppsModulesDelete* = Call_AppengineAppsModulesDelete_589132(
    name: "appengineAppsModulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesDelete_589133, base: "/",
    url: url_AppengineAppsModulesDelete_589134, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsCreate_589199 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsCreate_589201(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesVersionsCreate_589200(path: JsonNode;
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
  var valid_589202 = path.getOrDefault("modulesId")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "modulesId", valid_589202
  var valid_589203 = path.getOrDefault("appsId")
  valid_589203 = validateParameter(valid_589203, JString, required = true,
                                 default = nil)
  if valid_589203 != nil:
    section.add "appsId", valid_589203
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
  var valid_589204 = query.getOrDefault("upload_protocol")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "upload_protocol", valid_589204
  var valid_589205 = query.getOrDefault("fields")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "fields", valid_589205
  var valid_589206 = query.getOrDefault("quotaUser")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "quotaUser", valid_589206
  var valid_589207 = query.getOrDefault("alt")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = newJString("json"))
  if valid_589207 != nil:
    section.add "alt", valid_589207
  var valid_589208 = query.getOrDefault("oauth_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "oauth_token", valid_589208
  var valid_589209 = query.getOrDefault("callback")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "callback", valid_589209
  var valid_589210 = query.getOrDefault("access_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "access_token", valid_589210
  var valid_589211 = query.getOrDefault("uploadType")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "uploadType", valid_589211
  var valid_589212 = query.getOrDefault("key")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "key", valid_589212
  var valid_589213 = query.getOrDefault("$.xgafv")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("1"))
  if valid_589213 != nil:
    section.add "$.xgafv", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
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

proc call*(call_589216: Call_AppengineAppsModulesVersionsCreate_589199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_589216.validator(path, query, header, formData, body)
  let scheme = call_589216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589216.url(scheme.get, call_589216.host, call_589216.base,
                         call_589216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589216, url, valid)

proc call*(call_589217: Call_AppengineAppsModulesVersionsCreate_589199;
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
  var path_589218 = newJObject()
  var query_589219 = newJObject()
  var body_589220 = newJObject()
  add(query_589219, "upload_protocol", newJString(uploadProtocol))
  add(query_589219, "fields", newJString(fields))
  add(query_589219, "quotaUser", newJString(quotaUser))
  add(query_589219, "alt", newJString(alt))
  add(query_589219, "oauth_token", newJString(oauthToken))
  add(query_589219, "callback", newJString(callback))
  add(query_589219, "access_token", newJString(accessToken))
  add(query_589219, "uploadType", newJString(uploadType))
  add(path_589218, "modulesId", newJString(modulesId))
  add(query_589219, "key", newJString(key))
  add(path_589218, "appsId", newJString(appsId))
  add(query_589219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589220 = body
  add(query_589219, "prettyPrint", newJBool(prettyPrint))
  result = call_589217.call(path_589218, query_589219, nil, nil, body_589220)

var appengineAppsModulesVersionsCreate* = Call_AppengineAppsModulesVersionsCreate_589199(
    name: "appengineAppsModulesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsCreate_589200, base: "/",
    url: url_AppengineAppsModulesVersionsCreate_589201, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsList_589176 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsList_589178(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesVersionsList_589177(path: JsonNode;
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
  var valid_589179 = path.getOrDefault("modulesId")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "modulesId", valid_589179
  var valid_589180 = path.getOrDefault("appsId")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "appsId", valid_589180
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
  var valid_589181 = query.getOrDefault("upload_protocol")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "upload_protocol", valid_589181
  var valid_589182 = query.getOrDefault("fields")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "fields", valid_589182
  var valid_589183 = query.getOrDefault("pageToken")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "pageToken", valid_589183
  var valid_589184 = query.getOrDefault("quotaUser")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "quotaUser", valid_589184
  var valid_589185 = query.getOrDefault("view")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589185 != nil:
    section.add "view", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("oauth_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "oauth_token", valid_589187
  var valid_589188 = query.getOrDefault("callback")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "callback", valid_589188
  var valid_589189 = query.getOrDefault("access_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "access_token", valid_589189
  var valid_589190 = query.getOrDefault("uploadType")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "uploadType", valid_589190
  var valid_589191 = query.getOrDefault("key")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "key", valid_589191
  var valid_589192 = query.getOrDefault("$.xgafv")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("1"))
  if valid_589192 != nil:
    section.add "$.xgafv", valid_589192
  var valid_589193 = query.getOrDefault("pageSize")
  valid_589193 = validateParameter(valid_589193, JInt, required = false, default = nil)
  if valid_589193 != nil:
    section.add "pageSize", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589195: Call_AppengineAppsModulesVersionsList_589176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a module.
  ## 
  let valid = call_589195.validator(path, query, header, formData, body)
  let scheme = call_589195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589195.url(scheme.get, call_589195.host, call_589195.base,
                         call_589195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589195, url, valid)

proc call*(call_589196: Call_AppengineAppsModulesVersionsList_589176;
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
  var path_589197 = newJObject()
  var query_589198 = newJObject()
  add(query_589198, "upload_protocol", newJString(uploadProtocol))
  add(query_589198, "fields", newJString(fields))
  add(query_589198, "pageToken", newJString(pageToken))
  add(query_589198, "quotaUser", newJString(quotaUser))
  add(query_589198, "view", newJString(view))
  add(query_589198, "alt", newJString(alt))
  add(query_589198, "oauth_token", newJString(oauthToken))
  add(query_589198, "callback", newJString(callback))
  add(query_589198, "access_token", newJString(accessToken))
  add(query_589198, "uploadType", newJString(uploadType))
  add(path_589197, "modulesId", newJString(modulesId))
  add(query_589198, "key", newJString(key))
  add(path_589197, "appsId", newJString(appsId))
  add(query_589198, "$.xgafv", newJString(Xgafv))
  add(query_589198, "pageSize", newJInt(pageSize))
  add(query_589198, "prettyPrint", newJBool(prettyPrint))
  result = call_589196.call(path_589197, query_589198, nil, nil, nil)

var appengineAppsModulesVersionsList* = Call_AppengineAppsModulesVersionsList_589176(
    name: "appengineAppsModulesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsList_589177, base: "/",
    url: url_AppengineAppsModulesVersionsList_589178, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsGet_589221 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsGet_589223(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesVersionsGet_589222(path: JsonNode;
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
  var valid_589224 = path.getOrDefault("versionsId")
  valid_589224 = validateParameter(valid_589224, JString, required = true,
                                 default = nil)
  if valid_589224 != nil:
    section.add "versionsId", valid_589224
  var valid_589225 = path.getOrDefault("modulesId")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "modulesId", valid_589225
  var valid_589226 = path.getOrDefault("appsId")
  valid_589226 = validateParameter(valid_589226, JString, required = true,
                                 default = nil)
  if valid_589226 != nil:
    section.add "appsId", valid_589226
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
  var valid_589227 = query.getOrDefault("upload_protocol")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "upload_protocol", valid_589227
  var valid_589228 = query.getOrDefault("fields")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "fields", valid_589228
  var valid_589229 = query.getOrDefault("view")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589229 != nil:
    section.add "view", valid_589229
  var valid_589230 = query.getOrDefault("quotaUser")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "quotaUser", valid_589230
  var valid_589231 = query.getOrDefault("alt")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("json"))
  if valid_589231 != nil:
    section.add "alt", valid_589231
  var valid_589232 = query.getOrDefault("oauth_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "oauth_token", valid_589232
  var valid_589233 = query.getOrDefault("callback")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "callback", valid_589233
  var valid_589234 = query.getOrDefault("access_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "access_token", valid_589234
  var valid_589235 = query.getOrDefault("uploadType")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "uploadType", valid_589235
  var valid_589236 = query.getOrDefault("key")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "key", valid_589236
  var valid_589237 = query.getOrDefault("$.xgafv")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = newJString("1"))
  if valid_589237 != nil:
    section.add "$.xgafv", valid_589237
  var valid_589238 = query.getOrDefault("prettyPrint")
  valid_589238 = validateParameter(valid_589238, JBool, required = false,
                                 default = newJBool(true))
  if valid_589238 != nil:
    section.add "prettyPrint", valid_589238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589239: Call_AppengineAppsModulesVersionsGet_589221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_AppengineAppsModulesVersionsGet_589221;
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
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  add(query_589242, "upload_protocol", newJString(uploadProtocol))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "view", newJString(view))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(path_589241, "versionsId", newJString(versionsId))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "callback", newJString(callback))
  add(query_589242, "access_token", newJString(accessToken))
  add(query_589242, "uploadType", newJString(uploadType))
  add(path_589241, "modulesId", newJString(modulesId))
  add(query_589242, "key", newJString(key))
  add(path_589241, "appsId", newJString(appsId))
  add(query_589242, "$.xgafv", newJString(Xgafv))
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  result = call_589240.call(path_589241, query_589242, nil, nil, nil)

var appengineAppsModulesVersionsGet* = Call_AppengineAppsModulesVersionsGet_589221(
    name: "appengineAppsModulesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsGet_589222, base: "/",
    url: url_AppengineAppsModulesVersionsGet_589223, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsPatch_589264 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsPatch_589266(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesVersionsPatch_589265(path: JsonNode;
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
  var valid_589267 = path.getOrDefault("versionsId")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "versionsId", valid_589267
  var valid_589268 = path.getOrDefault("modulesId")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "modulesId", valid_589268
  var valid_589269 = path.getOrDefault("appsId")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "appsId", valid_589269
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
  var valid_589270 = query.getOrDefault("upload_protocol")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "upload_protocol", valid_589270
  var valid_589271 = query.getOrDefault("fields")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "fields", valid_589271
  var valid_589272 = query.getOrDefault("quotaUser")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "quotaUser", valid_589272
  var valid_589273 = query.getOrDefault("alt")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("json"))
  if valid_589273 != nil:
    section.add "alt", valid_589273
  var valid_589274 = query.getOrDefault("oauth_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "oauth_token", valid_589274
  var valid_589275 = query.getOrDefault("callback")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "callback", valid_589275
  var valid_589276 = query.getOrDefault("access_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "access_token", valid_589276
  var valid_589277 = query.getOrDefault("uploadType")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "uploadType", valid_589277
  var valid_589278 = query.getOrDefault("mask")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "mask", valid_589278
  var valid_589279 = query.getOrDefault("key")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "key", valid_589279
  var valid_589280 = query.getOrDefault("$.xgafv")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("1"))
  if valid_589280 != nil:
    section.add "$.xgafv", valid_589280
  var valid_589281 = query.getOrDefault("prettyPrint")
  valid_589281 = validateParameter(valid_589281, JBool, required = false,
                                 default = newJBool(true))
  if valid_589281 != nil:
    section.add "prettyPrint", valid_589281
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

proc call*(call_589283: Call_AppengineAppsModulesVersionsPatch_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  let valid = call_589283.validator(path, query, header, formData, body)
  let scheme = call_589283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589283.url(scheme.get, call_589283.host, call_589283.base,
                         call_589283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589283, url, valid)

proc call*(call_589284: Call_AppengineAppsModulesVersionsPatch_589264;
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
  var path_589285 = newJObject()
  var query_589286 = newJObject()
  var body_589287 = newJObject()
  add(query_589286, "upload_protocol", newJString(uploadProtocol))
  add(query_589286, "fields", newJString(fields))
  add(query_589286, "quotaUser", newJString(quotaUser))
  add(path_589285, "versionsId", newJString(versionsId))
  add(query_589286, "alt", newJString(alt))
  add(query_589286, "oauth_token", newJString(oauthToken))
  add(query_589286, "callback", newJString(callback))
  add(query_589286, "access_token", newJString(accessToken))
  add(query_589286, "uploadType", newJString(uploadType))
  add(query_589286, "mask", newJString(mask))
  add(path_589285, "modulesId", newJString(modulesId))
  add(query_589286, "key", newJString(key))
  add(path_589285, "appsId", newJString(appsId))
  add(query_589286, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589287 = body
  add(query_589286, "prettyPrint", newJBool(prettyPrint))
  result = call_589284.call(path_589285, query_589286, nil, nil, body_589287)

var appengineAppsModulesVersionsPatch* = Call_AppengineAppsModulesVersionsPatch_589264(
    name: "appengineAppsModulesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsPatch_589265, base: "/",
    url: url_AppengineAppsModulesVersionsPatch_589266, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsDelete_589243 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsDelete_589245(protocol: Scheme; host: string;
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

proc validate_AppengineAppsModulesVersionsDelete_589244(path: JsonNode;
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
  var valid_589246 = path.getOrDefault("versionsId")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "versionsId", valid_589246
  var valid_589247 = path.getOrDefault("modulesId")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "modulesId", valid_589247
  var valid_589248 = path.getOrDefault("appsId")
  valid_589248 = validateParameter(valid_589248, JString, required = true,
                                 default = nil)
  if valid_589248 != nil:
    section.add "appsId", valid_589248
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
  var valid_589249 = query.getOrDefault("upload_protocol")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "upload_protocol", valid_589249
  var valid_589250 = query.getOrDefault("fields")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "fields", valid_589250
  var valid_589251 = query.getOrDefault("quotaUser")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "quotaUser", valid_589251
  var valid_589252 = query.getOrDefault("alt")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("json"))
  if valid_589252 != nil:
    section.add "alt", valid_589252
  var valid_589253 = query.getOrDefault("oauth_token")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "oauth_token", valid_589253
  var valid_589254 = query.getOrDefault("callback")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "callback", valid_589254
  var valid_589255 = query.getOrDefault("access_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "access_token", valid_589255
  var valid_589256 = query.getOrDefault("uploadType")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "uploadType", valid_589256
  var valid_589257 = query.getOrDefault("key")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "key", valid_589257
  var valid_589258 = query.getOrDefault("$.xgafv")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = newJString("1"))
  if valid_589258 != nil:
    section.add "$.xgafv", valid_589258
  var valid_589259 = query.getOrDefault("prettyPrint")
  valid_589259 = validateParameter(valid_589259, JBool, required = false,
                                 default = newJBool(true))
  if valid_589259 != nil:
    section.add "prettyPrint", valid_589259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589260: Call_AppengineAppsModulesVersionsDelete_589243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing version.
  ## 
  let valid = call_589260.validator(path, query, header, formData, body)
  let scheme = call_589260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589260.url(scheme.get, call_589260.host, call_589260.base,
                         call_589260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589260, url, valid)

proc call*(call_589261: Call_AppengineAppsModulesVersionsDelete_589243;
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
  var path_589262 = newJObject()
  var query_589263 = newJObject()
  add(query_589263, "upload_protocol", newJString(uploadProtocol))
  add(query_589263, "fields", newJString(fields))
  add(query_589263, "quotaUser", newJString(quotaUser))
  add(path_589262, "versionsId", newJString(versionsId))
  add(query_589263, "alt", newJString(alt))
  add(query_589263, "oauth_token", newJString(oauthToken))
  add(query_589263, "callback", newJString(callback))
  add(query_589263, "access_token", newJString(accessToken))
  add(query_589263, "uploadType", newJString(uploadType))
  add(path_589262, "modulesId", newJString(modulesId))
  add(query_589263, "key", newJString(key))
  add(path_589262, "appsId", newJString(appsId))
  add(query_589263, "$.xgafv", newJString(Xgafv))
  add(query_589263, "prettyPrint", newJBool(prettyPrint))
  result = call_589261.call(path_589262, query_589263, nil, nil, nil)

var appengineAppsModulesVersionsDelete* = Call_AppengineAppsModulesVersionsDelete_589243(
    name: "appengineAppsModulesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsDelete_589244, base: "/",
    url: url_AppengineAppsModulesVersionsDelete_589245, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesList_589288 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsInstancesList_589290(protocol: Scheme;
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

proc validate_AppengineAppsModulesVersionsInstancesList_589289(path: JsonNode;
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
  var valid_589291 = path.getOrDefault("versionsId")
  valid_589291 = validateParameter(valid_589291, JString, required = true,
                                 default = nil)
  if valid_589291 != nil:
    section.add "versionsId", valid_589291
  var valid_589292 = path.getOrDefault("modulesId")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "modulesId", valid_589292
  var valid_589293 = path.getOrDefault("appsId")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "appsId", valid_589293
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
  var valid_589294 = query.getOrDefault("upload_protocol")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "upload_protocol", valid_589294
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("pageToken")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "pageToken", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("callback")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "callback", valid_589300
  var valid_589301 = query.getOrDefault("access_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "access_token", valid_589301
  var valid_589302 = query.getOrDefault("uploadType")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "uploadType", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("$.xgafv")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("1"))
  if valid_589304 != nil:
    section.add "$.xgafv", valid_589304
  var valid_589305 = query.getOrDefault("pageSize")
  valid_589305 = validateParameter(valid_589305, JInt, required = false, default = nil)
  if valid_589305 != nil:
    section.add "pageSize", valid_589305
  var valid_589306 = query.getOrDefault("prettyPrint")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(true))
  if valid_589306 != nil:
    section.add "prettyPrint", valid_589306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_AppengineAppsModulesVersionsInstancesList_589288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_AppengineAppsModulesVersionsInstancesList_589288;
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
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  add(query_589310, "upload_protocol", newJString(uploadProtocol))
  add(query_589310, "fields", newJString(fields))
  add(query_589310, "pageToken", newJString(pageToken))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(path_589309, "versionsId", newJString(versionsId))
  add(query_589310, "alt", newJString(alt))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(query_589310, "callback", newJString(callback))
  add(query_589310, "access_token", newJString(accessToken))
  add(query_589310, "uploadType", newJString(uploadType))
  add(path_589309, "modulesId", newJString(modulesId))
  add(query_589310, "key", newJString(key))
  add(path_589309, "appsId", newJString(appsId))
  add(query_589310, "$.xgafv", newJString(Xgafv))
  add(query_589310, "pageSize", newJInt(pageSize))
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  result = call_589308.call(path_589309, query_589310, nil, nil, nil)

var appengineAppsModulesVersionsInstancesList* = Call_AppengineAppsModulesVersionsInstancesList_589288(
    name: "appengineAppsModulesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsModulesVersionsInstancesList_589289,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesList_589290,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesGet_589311 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsInstancesGet_589313(protocol: Scheme;
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

proc validate_AppengineAppsModulesVersionsInstancesGet_589312(path: JsonNode;
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
  var valid_589314 = path.getOrDefault("versionsId")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "versionsId", valid_589314
  var valid_589315 = path.getOrDefault("instancesId")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "instancesId", valid_589315
  var valid_589316 = path.getOrDefault("modulesId")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = nil)
  if valid_589316 != nil:
    section.add "modulesId", valid_589316
  var valid_589317 = path.getOrDefault("appsId")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "appsId", valid_589317
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
  var valid_589318 = query.getOrDefault("upload_protocol")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "upload_protocol", valid_589318
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("callback")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "callback", valid_589323
  var valid_589324 = query.getOrDefault("access_token")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "access_token", valid_589324
  var valid_589325 = query.getOrDefault("uploadType")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "uploadType", valid_589325
  var valid_589326 = query.getOrDefault("key")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "key", valid_589326
  var valid_589327 = query.getOrDefault("$.xgafv")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = newJString("1"))
  if valid_589327 != nil:
    section.add "$.xgafv", valid_589327
  var valid_589328 = query.getOrDefault("prettyPrint")
  valid_589328 = validateParameter(valid_589328, JBool, required = false,
                                 default = newJBool(true))
  if valid_589328 != nil:
    section.add "prettyPrint", valid_589328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589329: Call_AppengineAppsModulesVersionsInstancesGet_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_589329.validator(path, query, header, formData, body)
  let scheme = call_589329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589329.url(scheme.get, call_589329.host, call_589329.base,
                         call_589329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589329, url, valid)

proc call*(call_589330: Call_AppengineAppsModulesVersionsInstancesGet_589311;
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
  var path_589331 = newJObject()
  var query_589332 = newJObject()
  add(query_589332, "upload_protocol", newJString(uploadProtocol))
  add(query_589332, "fields", newJString(fields))
  add(query_589332, "quotaUser", newJString(quotaUser))
  add(path_589331, "versionsId", newJString(versionsId))
  add(query_589332, "alt", newJString(alt))
  add(path_589331, "instancesId", newJString(instancesId))
  add(query_589332, "oauth_token", newJString(oauthToken))
  add(query_589332, "callback", newJString(callback))
  add(query_589332, "access_token", newJString(accessToken))
  add(query_589332, "uploadType", newJString(uploadType))
  add(path_589331, "modulesId", newJString(modulesId))
  add(query_589332, "key", newJString(key))
  add(path_589331, "appsId", newJString(appsId))
  add(query_589332, "$.xgafv", newJString(Xgafv))
  add(query_589332, "prettyPrint", newJBool(prettyPrint))
  result = call_589330.call(path_589331, query_589332, nil, nil, nil)

var appengineAppsModulesVersionsInstancesGet* = Call_AppengineAppsModulesVersionsInstancesGet_589311(
    name: "appengineAppsModulesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesGet_589312,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesGet_589313,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDelete_589333 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsInstancesDelete_589335(protocol: Scheme;
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

proc validate_AppengineAppsModulesVersionsInstancesDelete_589334(path: JsonNode;
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
  var valid_589336 = path.getOrDefault("versionsId")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "versionsId", valid_589336
  var valid_589337 = path.getOrDefault("instancesId")
  valid_589337 = validateParameter(valid_589337, JString, required = true,
                                 default = nil)
  if valid_589337 != nil:
    section.add "instancesId", valid_589337
  var valid_589338 = path.getOrDefault("modulesId")
  valid_589338 = validateParameter(valid_589338, JString, required = true,
                                 default = nil)
  if valid_589338 != nil:
    section.add "modulesId", valid_589338
  var valid_589339 = path.getOrDefault("appsId")
  valid_589339 = validateParameter(valid_589339, JString, required = true,
                                 default = nil)
  if valid_589339 != nil:
    section.add "appsId", valid_589339
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
  var valid_589340 = query.getOrDefault("upload_protocol")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "upload_protocol", valid_589340
  var valid_589341 = query.getOrDefault("fields")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "fields", valid_589341
  var valid_589342 = query.getOrDefault("quotaUser")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "quotaUser", valid_589342
  var valid_589343 = query.getOrDefault("alt")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("json"))
  if valid_589343 != nil:
    section.add "alt", valid_589343
  var valid_589344 = query.getOrDefault("oauth_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "oauth_token", valid_589344
  var valid_589345 = query.getOrDefault("callback")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "callback", valid_589345
  var valid_589346 = query.getOrDefault("access_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "access_token", valid_589346
  var valid_589347 = query.getOrDefault("uploadType")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "uploadType", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("$.xgafv")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = newJString("1"))
  if valid_589349 != nil:
    section.add "$.xgafv", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589351: Call_AppengineAppsModulesVersionsInstancesDelete_589333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_589351.validator(path, query, header, formData, body)
  let scheme = call_589351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589351.url(scheme.get, call_589351.host, call_589351.base,
                         call_589351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589351, url, valid)

proc call*(call_589352: Call_AppengineAppsModulesVersionsInstancesDelete_589333;
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
  var path_589353 = newJObject()
  var query_589354 = newJObject()
  add(query_589354, "upload_protocol", newJString(uploadProtocol))
  add(query_589354, "fields", newJString(fields))
  add(query_589354, "quotaUser", newJString(quotaUser))
  add(path_589353, "versionsId", newJString(versionsId))
  add(query_589354, "alt", newJString(alt))
  add(path_589353, "instancesId", newJString(instancesId))
  add(query_589354, "oauth_token", newJString(oauthToken))
  add(query_589354, "callback", newJString(callback))
  add(query_589354, "access_token", newJString(accessToken))
  add(query_589354, "uploadType", newJString(uploadType))
  add(path_589353, "modulesId", newJString(modulesId))
  add(query_589354, "key", newJString(key))
  add(path_589353, "appsId", newJString(appsId))
  add(query_589354, "$.xgafv", newJString(Xgafv))
  add(query_589354, "prettyPrint", newJBool(prettyPrint))
  result = call_589352.call(path_589353, query_589354, nil, nil, nil)

var appengineAppsModulesVersionsInstancesDelete* = Call_AppengineAppsModulesVersionsInstancesDelete_589333(
    name: "appengineAppsModulesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesDelete_589334,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDelete_589335,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDebug_589355 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsModulesVersionsInstancesDebug_589357(protocol: Scheme;
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

proc validate_AppengineAppsModulesVersionsInstancesDebug_589356(path: JsonNode;
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
  var valid_589358 = path.getOrDefault("versionsId")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "versionsId", valid_589358
  var valid_589359 = path.getOrDefault("instancesId")
  valid_589359 = validateParameter(valid_589359, JString, required = true,
                                 default = nil)
  if valid_589359 != nil:
    section.add "instancesId", valid_589359
  var valid_589360 = path.getOrDefault("modulesId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "modulesId", valid_589360
  var valid_589361 = path.getOrDefault("appsId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "appsId", valid_589361
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
  var valid_589362 = query.getOrDefault("upload_protocol")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "upload_protocol", valid_589362
  var valid_589363 = query.getOrDefault("fields")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fields", valid_589363
  var valid_589364 = query.getOrDefault("quotaUser")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "quotaUser", valid_589364
  var valid_589365 = query.getOrDefault("alt")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("json"))
  if valid_589365 != nil:
    section.add "alt", valid_589365
  var valid_589366 = query.getOrDefault("oauth_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "oauth_token", valid_589366
  var valid_589367 = query.getOrDefault("callback")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "callback", valid_589367
  var valid_589368 = query.getOrDefault("access_token")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "access_token", valid_589368
  var valid_589369 = query.getOrDefault("uploadType")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "uploadType", valid_589369
  var valid_589370 = query.getOrDefault("key")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "key", valid_589370
  var valid_589371 = query.getOrDefault("$.xgafv")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("1"))
  if valid_589371 != nil:
    section.add "$.xgafv", valid_589371
  var valid_589372 = query.getOrDefault("prettyPrint")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(true))
  if valid_589372 != nil:
    section.add "prettyPrint", valid_589372
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

proc call*(call_589374: Call_AppengineAppsModulesVersionsInstancesDebug_589355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_589374.validator(path, query, header, formData, body)
  let scheme = call_589374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589374.url(scheme.get, call_589374.host, call_589374.base,
                         call_589374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589374, url, valid)

proc call*(call_589375: Call_AppengineAppsModulesVersionsInstancesDebug_589355;
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
  var path_589376 = newJObject()
  var query_589377 = newJObject()
  var body_589378 = newJObject()
  add(query_589377, "upload_protocol", newJString(uploadProtocol))
  add(query_589377, "fields", newJString(fields))
  add(query_589377, "quotaUser", newJString(quotaUser))
  add(path_589376, "versionsId", newJString(versionsId))
  add(query_589377, "alt", newJString(alt))
  add(path_589376, "instancesId", newJString(instancesId))
  add(query_589377, "oauth_token", newJString(oauthToken))
  add(query_589377, "callback", newJString(callback))
  add(query_589377, "access_token", newJString(accessToken))
  add(query_589377, "uploadType", newJString(uploadType))
  add(path_589376, "modulesId", newJString(modulesId))
  add(query_589377, "key", newJString(key))
  add(path_589376, "appsId", newJString(appsId))
  add(query_589377, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589378 = body
  add(query_589377, "prettyPrint", newJBool(prettyPrint))
  result = call_589375.call(path_589376, query_589377, nil, nil, body_589378)

var appengineAppsModulesVersionsInstancesDebug* = Call_AppengineAppsModulesVersionsInstancesDebug_589355(
    name: "appengineAppsModulesVersionsInstancesDebug", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsModulesVersionsInstancesDebug_589356,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDebug_589357,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_589379 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsOperationsList_589381(protocol: Scheme; host: string;
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

proc validate_AppengineAppsOperationsList_589380(path: JsonNode; query: JsonNode;
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
  var valid_589382 = path.getOrDefault("appsId")
  valid_589382 = validateParameter(valid_589382, JString, required = true,
                                 default = nil)
  if valid_589382 != nil:
    section.add "appsId", valid_589382
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
  var valid_589383 = query.getOrDefault("upload_protocol")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "upload_protocol", valid_589383
  var valid_589384 = query.getOrDefault("fields")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "fields", valid_589384
  var valid_589385 = query.getOrDefault("pageToken")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "pageToken", valid_589385
  var valid_589386 = query.getOrDefault("quotaUser")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "quotaUser", valid_589386
  var valid_589387 = query.getOrDefault("alt")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = newJString("json"))
  if valid_589387 != nil:
    section.add "alt", valid_589387
  var valid_589388 = query.getOrDefault("oauth_token")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "oauth_token", valid_589388
  var valid_589389 = query.getOrDefault("callback")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "callback", valid_589389
  var valid_589390 = query.getOrDefault("access_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "access_token", valid_589390
  var valid_589391 = query.getOrDefault("uploadType")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "uploadType", valid_589391
  var valid_589392 = query.getOrDefault("key")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "key", valid_589392
  var valid_589393 = query.getOrDefault("$.xgafv")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = newJString("1"))
  if valid_589393 != nil:
    section.add "$.xgafv", valid_589393
  var valid_589394 = query.getOrDefault("pageSize")
  valid_589394 = validateParameter(valid_589394, JInt, required = false, default = nil)
  if valid_589394 != nil:
    section.add "pageSize", valid_589394
  var valid_589395 = query.getOrDefault("prettyPrint")
  valid_589395 = validateParameter(valid_589395, JBool, required = false,
                                 default = newJBool(true))
  if valid_589395 != nil:
    section.add "prettyPrint", valid_589395
  var valid_589396 = query.getOrDefault("filter")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "filter", valid_589396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589397: Call_AppengineAppsOperationsList_589379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_589397.validator(path, query, header, formData, body)
  let scheme = call_589397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589397.url(scheme.get, call_589397.host, call_589397.base,
                         call_589397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589397, url, valid)

proc call*(call_589398: Call_AppengineAppsOperationsList_589379; appsId: string;
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
  var path_589399 = newJObject()
  var query_589400 = newJObject()
  add(query_589400, "upload_protocol", newJString(uploadProtocol))
  add(query_589400, "fields", newJString(fields))
  add(query_589400, "pageToken", newJString(pageToken))
  add(query_589400, "quotaUser", newJString(quotaUser))
  add(query_589400, "alt", newJString(alt))
  add(query_589400, "oauth_token", newJString(oauthToken))
  add(query_589400, "callback", newJString(callback))
  add(query_589400, "access_token", newJString(accessToken))
  add(query_589400, "uploadType", newJString(uploadType))
  add(query_589400, "key", newJString(key))
  add(path_589399, "appsId", newJString(appsId))
  add(query_589400, "$.xgafv", newJString(Xgafv))
  add(query_589400, "pageSize", newJInt(pageSize))
  add(query_589400, "prettyPrint", newJBool(prettyPrint))
  add(query_589400, "filter", newJString(filter))
  result = call_589398.call(path_589399, query_589400, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_589379(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_589380, base: "/",
    url: url_AppengineAppsOperationsList_589381, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_589401 = ref object of OpenApiRestCall_588450
proc url_AppengineAppsOperationsGet_589403(protocol: Scheme; host: string;
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

proc validate_AppengineAppsOperationsGet_589402(path: JsonNode; query: JsonNode;
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
  var valid_589404 = path.getOrDefault("appsId")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "appsId", valid_589404
  var valid_589405 = path.getOrDefault("operationsId")
  valid_589405 = validateParameter(valid_589405, JString, required = true,
                                 default = nil)
  if valid_589405 != nil:
    section.add "operationsId", valid_589405
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
  var valid_589406 = query.getOrDefault("upload_protocol")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "upload_protocol", valid_589406
  var valid_589407 = query.getOrDefault("fields")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "fields", valid_589407
  var valid_589408 = query.getOrDefault("quotaUser")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "quotaUser", valid_589408
  var valid_589409 = query.getOrDefault("alt")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = newJString("json"))
  if valid_589409 != nil:
    section.add "alt", valid_589409
  var valid_589410 = query.getOrDefault("oauth_token")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "oauth_token", valid_589410
  var valid_589411 = query.getOrDefault("callback")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "callback", valid_589411
  var valid_589412 = query.getOrDefault("access_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "access_token", valid_589412
  var valid_589413 = query.getOrDefault("uploadType")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "uploadType", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  var valid_589415 = query.getOrDefault("$.xgafv")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = newJString("1"))
  if valid_589415 != nil:
    section.add "$.xgafv", valid_589415
  var valid_589416 = query.getOrDefault("prettyPrint")
  valid_589416 = validateParameter(valid_589416, JBool, required = false,
                                 default = newJBool(true))
  if valid_589416 != nil:
    section.add "prettyPrint", valid_589416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589417: Call_AppengineAppsOperationsGet_589401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_589417.validator(path, query, header, formData, body)
  let scheme = call_589417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589417.url(scheme.get, call_589417.host, call_589417.base,
                         call_589417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589417, url, valid)

proc call*(call_589418: Call_AppengineAppsOperationsGet_589401; appsId: string;
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
  var path_589419 = newJObject()
  var query_589420 = newJObject()
  add(query_589420, "upload_protocol", newJString(uploadProtocol))
  add(query_589420, "fields", newJString(fields))
  add(query_589420, "quotaUser", newJString(quotaUser))
  add(query_589420, "alt", newJString(alt))
  add(query_589420, "oauth_token", newJString(oauthToken))
  add(query_589420, "callback", newJString(callback))
  add(query_589420, "access_token", newJString(accessToken))
  add(query_589420, "uploadType", newJString(uploadType))
  add(query_589420, "key", newJString(key))
  add(path_589419, "appsId", newJString(appsId))
  add(query_589420, "$.xgafv", newJString(Xgafv))
  add(path_589419, "operationsId", newJString(operationsId))
  add(query_589420, "prettyPrint", newJBool(prettyPrint))
  result = call_589418.call(path_589419, query_589420, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_589401(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_589402, base: "/",
    url: url_AppengineAppsOperationsGet_589403, schemes: {Scheme.Https})
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
