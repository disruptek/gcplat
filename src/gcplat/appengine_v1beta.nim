
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
  Call_AppengineAppsCreate_597690 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsCreate_597692(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppengineAppsCreate_597691(path: JsonNode; query: JsonNode;
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
  var valid_597804 = query.getOrDefault("upload_protocol")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = nil)
  if valid_597804 != nil:
    section.add "upload_protocol", valid_597804
  var valid_597805 = query.getOrDefault("fields")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "fields", valid_597805
  var valid_597806 = query.getOrDefault("quotaUser")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "quotaUser", valid_597806
  var valid_597820 = query.getOrDefault("alt")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = newJString("json"))
  if valid_597820 != nil:
    section.add "alt", valid_597820
  var valid_597821 = query.getOrDefault("oauth_token")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "oauth_token", valid_597821
  var valid_597822 = query.getOrDefault("callback")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "callback", valid_597822
  var valid_597823 = query.getOrDefault("access_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "access_token", valid_597823
  var valid_597824 = query.getOrDefault("uploadType")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "uploadType", valid_597824
  var valid_597825 = query.getOrDefault("key")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "key", valid_597825
  var valid_597826 = query.getOrDefault("$.xgafv")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = newJString("1"))
  if valid_597826 != nil:
    section.add "$.xgafv", valid_597826
  var valid_597827 = query.getOrDefault("prettyPrint")
  valid_597827 = validateParameter(valid_597827, JBool, required = false,
                                 default = newJBool(true))
  if valid_597827 != nil:
    section.add "prettyPrint", valid_597827
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

proc call*(call_597851: Call_AppengineAppsCreate_597690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
  ## 
  let valid = call_597851.validator(path, query, header, formData, body)
  let scheme = call_597851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597851.url(scheme.get, call_597851.host, call_597851.base,
                         call_597851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597851, url, valid)

proc call*(call_597922: Call_AppengineAppsCreate_597690;
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
  var query_597923 = newJObject()
  var body_597925 = newJObject()
  add(query_597923, "upload_protocol", newJString(uploadProtocol))
  add(query_597923, "fields", newJString(fields))
  add(query_597923, "quotaUser", newJString(quotaUser))
  add(query_597923, "alt", newJString(alt))
  add(query_597923, "oauth_token", newJString(oauthToken))
  add(query_597923, "callback", newJString(callback))
  add(query_597923, "access_token", newJString(accessToken))
  add(query_597923, "uploadType", newJString(uploadType))
  add(query_597923, "key", newJString(key))
  add(query_597923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597925 = body
  add(query_597923, "prettyPrint", newJBool(prettyPrint))
  result = call_597922.call(nil, query_597923, nil, nil, body_597925)

var appengineAppsCreate* = Call_AppengineAppsCreate_597690(
    name: "appengineAppsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta/apps",
    validator: validate_AppengineAppsCreate_597691, base: "/",
    url: url_AppengineAppsCreate_597692, schemes: {Scheme.Https})
type
  Call_AppengineAppsGet_597964 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsGet_597966(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsGet_597965(path: JsonNode; query: JsonNode;
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
  var valid_597981 = path.getOrDefault("appsId")
  valid_597981 = validateParameter(valid_597981, JString, required = true,
                                 default = nil)
  if valid_597981 != nil:
    section.add "appsId", valid_597981
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
  var valid_597982 = query.getOrDefault("upload_protocol")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "upload_protocol", valid_597982
  var valid_597983 = query.getOrDefault("fields")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "fields", valid_597983
  var valid_597984 = query.getOrDefault("quotaUser")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "quotaUser", valid_597984
  var valid_597985 = query.getOrDefault("alt")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = newJString("json"))
  if valid_597985 != nil:
    section.add "alt", valid_597985
  var valid_597986 = query.getOrDefault("oauth_token")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "oauth_token", valid_597986
  var valid_597987 = query.getOrDefault("callback")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "callback", valid_597987
  var valid_597988 = query.getOrDefault("access_token")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "access_token", valid_597988
  var valid_597989 = query.getOrDefault("uploadType")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "uploadType", valid_597989
  var valid_597990 = query.getOrDefault("key")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "key", valid_597990
  var valid_597991 = query.getOrDefault("$.xgafv")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("1"))
  if valid_597991 != nil:
    section.add "$.xgafv", valid_597991
  var valid_597992 = query.getOrDefault("prettyPrint")
  valid_597992 = validateParameter(valid_597992, JBool, required = false,
                                 default = newJBool(true))
  if valid_597992 != nil:
    section.add "prettyPrint", valid_597992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597993: Call_AppengineAppsGet_597964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_597993.validator(path, query, header, formData, body)
  let scheme = call_597993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597993.url(scheme.get, call_597993.host, call_597993.base,
                         call_597993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597993, url, valid)

proc call*(call_597994: Call_AppengineAppsGet_597964; appsId: string;
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
  var path_597995 = newJObject()
  var query_597996 = newJObject()
  add(query_597996, "upload_protocol", newJString(uploadProtocol))
  add(query_597996, "fields", newJString(fields))
  add(query_597996, "quotaUser", newJString(quotaUser))
  add(query_597996, "alt", newJString(alt))
  add(query_597996, "oauth_token", newJString(oauthToken))
  add(query_597996, "callback", newJString(callback))
  add(query_597996, "access_token", newJString(accessToken))
  add(query_597996, "uploadType", newJString(uploadType))
  add(query_597996, "key", newJString(key))
  add(path_597995, "appsId", newJString(appsId))
  add(query_597996, "$.xgafv", newJString(Xgafv))
  add(query_597996, "prettyPrint", newJBool(prettyPrint))
  result = call_597994.call(path_597995, query_597996, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_597964(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}", validator: validate_AppengineAppsGet_597965,
    base: "/", url: url_AppengineAppsGet_597966, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_597997 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsPatch_597999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_597998(path: JsonNode; query: JsonNode;
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
  var valid_598000 = path.getOrDefault("appsId")
  valid_598000 = validateParameter(valid_598000, JString, required = true,
                                 default = nil)
  if valid_598000 != nil:
    section.add "appsId", valid_598000
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
  var valid_598001 = query.getOrDefault("upload_protocol")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "upload_protocol", valid_598001
  var valid_598002 = query.getOrDefault("fields")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "fields", valid_598002
  var valid_598003 = query.getOrDefault("quotaUser")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "quotaUser", valid_598003
  var valid_598004 = query.getOrDefault("alt")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = newJString("json"))
  if valid_598004 != nil:
    section.add "alt", valid_598004
  var valid_598005 = query.getOrDefault("oauth_token")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "oauth_token", valid_598005
  var valid_598006 = query.getOrDefault("callback")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "callback", valid_598006
  var valid_598007 = query.getOrDefault("access_token")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "access_token", valid_598007
  var valid_598008 = query.getOrDefault("uploadType")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "uploadType", valid_598008
  var valid_598009 = query.getOrDefault("key")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "key", valid_598009
  var valid_598010 = query.getOrDefault("$.xgafv")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = newJString("1"))
  if valid_598010 != nil:
    section.add "$.xgafv", valid_598010
  var valid_598011 = query.getOrDefault("prettyPrint")
  valid_598011 = validateParameter(valid_598011, JBool, required = false,
                                 default = newJBool(true))
  if valid_598011 != nil:
    section.add "prettyPrint", valid_598011
  var valid_598012 = query.getOrDefault("updateMask")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "updateMask", valid_598012
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

proc call*(call_598014: Call_AppengineAppsPatch_597997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
  ## 
  let valid = call_598014.validator(path, query, header, formData, body)
  let scheme = call_598014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598014.url(scheme.get, call_598014.host, call_598014.base,
                         call_598014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598014, url, valid)

proc call*(call_598015: Call_AppengineAppsPatch_597997; appsId: string;
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
  var path_598016 = newJObject()
  var query_598017 = newJObject()
  var body_598018 = newJObject()
  add(query_598017, "upload_protocol", newJString(uploadProtocol))
  add(query_598017, "fields", newJString(fields))
  add(query_598017, "quotaUser", newJString(quotaUser))
  add(query_598017, "alt", newJString(alt))
  add(query_598017, "oauth_token", newJString(oauthToken))
  add(query_598017, "callback", newJString(callback))
  add(query_598017, "access_token", newJString(accessToken))
  add(query_598017, "uploadType", newJString(uploadType))
  add(query_598017, "key", newJString(key))
  add(path_598016, "appsId", newJString(appsId))
  add(query_598017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598018 = body
  add(query_598017, "prettyPrint", newJBool(prettyPrint))
  add(query_598017, "updateMask", newJString(updateMask))
  result = call_598015.call(path_598016, query_598017, nil, nil, body_598018)

var appengineAppsPatch* = Call_AppengineAppsPatch_597997(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}",
    validator: validate_AppengineAppsPatch_597998, base: "/",
    url: url_AppengineAppsPatch_597999, schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesCreate_598041 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedCertificatesCreate_598043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesCreate_598042(path: JsonNode;
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
  var valid_598044 = path.getOrDefault("appsId")
  valid_598044 = validateParameter(valid_598044, JString, required = true,
                                 default = nil)
  if valid_598044 != nil:
    section.add "appsId", valid_598044
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
  var valid_598045 = query.getOrDefault("upload_protocol")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "upload_protocol", valid_598045
  var valid_598046 = query.getOrDefault("fields")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "fields", valid_598046
  var valid_598047 = query.getOrDefault("quotaUser")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "quotaUser", valid_598047
  var valid_598048 = query.getOrDefault("alt")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = newJString("json"))
  if valid_598048 != nil:
    section.add "alt", valid_598048
  var valid_598049 = query.getOrDefault("oauth_token")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "oauth_token", valid_598049
  var valid_598050 = query.getOrDefault("callback")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "callback", valid_598050
  var valid_598051 = query.getOrDefault("access_token")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "access_token", valid_598051
  var valid_598052 = query.getOrDefault("uploadType")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "uploadType", valid_598052
  var valid_598053 = query.getOrDefault("key")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "key", valid_598053
  var valid_598054 = query.getOrDefault("$.xgafv")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = newJString("1"))
  if valid_598054 != nil:
    section.add "$.xgafv", valid_598054
  var valid_598055 = query.getOrDefault("prettyPrint")
  valid_598055 = validateParameter(valid_598055, JBool, required = false,
                                 default = newJBool(true))
  if valid_598055 != nil:
    section.add "prettyPrint", valid_598055
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

proc call*(call_598057: Call_AppengineAppsAuthorizedCertificatesCreate_598041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_598057.validator(path, query, header, formData, body)
  let scheme = call_598057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598057.url(scheme.get, call_598057.host, call_598057.base,
                         call_598057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598057, url, valid)

proc call*(call_598058: Call_AppengineAppsAuthorizedCertificatesCreate_598041;
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
  var path_598059 = newJObject()
  var query_598060 = newJObject()
  var body_598061 = newJObject()
  add(query_598060, "upload_protocol", newJString(uploadProtocol))
  add(query_598060, "fields", newJString(fields))
  add(query_598060, "quotaUser", newJString(quotaUser))
  add(query_598060, "alt", newJString(alt))
  add(query_598060, "oauth_token", newJString(oauthToken))
  add(query_598060, "callback", newJString(callback))
  add(query_598060, "access_token", newJString(accessToken))
  add(query_598060, "uploadType", newJString(uploadType))
  add(query_598060, "key", newJString(key))
  add(path_598059, "appsId", newJString(appsId))
  add(query_598060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598061 = body
  add(query_598060, "prettyPrint", newJBool(prettyPrint))
  result = call_598058.call(path_598059, query_598060, nil, nil, body_598061)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_598041(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_598042,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_598043,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_598019 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedCertificatesList_598021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesList_598020(path: JsonNode;
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
  var valid_598022 = path.getOrDefault("appsId")
  valid_598022 = validateParameter(valid_598022, JString, required = true,
                                 default = nil)
  if valid_598022 != nil:
    section.add "appsId", valid_598022
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
  var valid_598023 = query.getOrDefault("upload_protocol")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "upload_protocol", valid_598023
  var valid_598024 = query.getOrDefault("fields")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "fields", valid_598024
  var valid_598025 = query.getOrDefault("pageToken")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "pageToken", valid_598025
  var valid_598026 = query.getOrDefault("quotaUser")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "quotaUser", valid_598026
  var valid_598027 = query.getOrDefault("view")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_598027 != nil:
    section.add "view", valid_598027
  var valid_598028 = query.getOrDefault("alt")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = newJString("json"))
  if valid_598028 != nil:
    section.add "alt", valid_598028
  var valid_598029 = query.getOrDefault("oauth_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "oauth_token", valid_598029
  var valid_598030 = query.getOrDefault("callback")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "callback", valid_598030
  var valid_598031 = query.getOrDefault("access_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "access_token", valid_598031
  var valid_598032 = query.getOrDefault("uploadType")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "uploadType", valid_598032
  var valid_598033 = query.getOrDefault("key")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "key", valid_598033
  var valid_598034 = query.getOrDefault("$.xgafv")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("1"))
  if valid_598034 != nil:
    section.add "$.xgafv", valid_598034
  var valid_598035 = query.getOrDefault("pageSize")
  valid_598035 = validateParameter(valid_598035, JInt, required = false, default = nil)
  if valid_598035 != nil:
    section.add "pageSize", valid_598035
  var valid_598036 = query.getOrDefault("prettyPrint")
  valid_598036 = validateParameter(valid_598036, JBool, required = false,
                                 default = newJBool(true))
  if valid_598036 != nil:
    section.add "prettyPrint", valid_598036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598037: Call_AppengineAppsAuthorizedCertificatesList_598019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_598037.validator(path, query, header, formData, body)
  let scheme = call_598037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598037.url(scheme.get, call_598037.host, call_598037.base,
                         call_598037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598037, url, valid)

proc call*(call_598038: Call_AppengineAppsAuthorizedCertificatesList_598019;
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
  var path_598039 = newJObject()
  var query_598040 = newJObject()
  add(query_598040, "upload_protocol", newJString(uploadProtocol))
  add(query_598040, "fields", newJString(fields))
  add(query_598040, "pageToken", newJString(pageToken))
  add(query_598040, "quotaUser", newJString(quotaUser))
  add(query_598040, "view", newJString(view))
  add(query_598040, "alt", newJString(alt))
  add(query_598040, "oauth_token", newJString(oauthToken))
  add(query_598040, "callback", newJString(callback))
  add(query_598040, "access_token", newJString(accessToken))
  add(query_598040, "uploadType", newJString(uploadType))
  add(query_598040, "key", newJString(key))
  add(path_598039, "appsId", newJString(appsId))
  add(query_598040, "$.xgafv", newJString(Xgafv))
  add(query_598040, "pageSize", newJInt(pageSize))
  add(query_598040, "prettyPrint", newJBool(prettyPrint))
  result = call_598038.call(path_598039, query_598040, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_598019(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_598020, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_598021,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_598062 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedCertificatesGet_598064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesGet_598063(path: JsonNode;
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
  var valid_598065 = path.getOrDefault("appsId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "appsId", valid_598065
  var valid_598066 = path.getOrDefault("authorizedCertificatesId")
  valid_598066 = validateParameter(valid_598066, JString, required = true,
                                 default = nil)
  if valid_598066 != nil:
    section.add "authorizedCertificatesId", valid_598066
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
  var valid_598067 = query.getOrDefault("upload_protocol")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "upload_protocol", valid_598067
  var valid_598068 = query.getOrDefault("fields")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "fields", valid_598068
  var valid_598069 = query.getOrDefault("view")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_598069 != nil:
    section.add "view", valid_598069
  var valid_598070 = query.getOrDefault("quotaUser")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "quotaUser", valid_598070
  var valid_598071 = query.getOrDefault("alt")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = newJString("json"))
  if valid_598071 != nil:
    section.add "alt", valid_598071
  var valid_598072 = query.getOrDefault("oauth_token")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "oauth_token", valid_598072
  var valid_598073 = query.getOrDefault("callback")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "callback", valid_598073
  var valid_598074 = query.getOrDefault("access_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "access_token", valid_598074
  var valid_598075 = query.getOrDefault("uploadType")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "uploadType", valid_598075
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("$.xgafv")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("1"))
  if valid_598077 != nil:
    section.add "$.xgafv", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598079: Call_AppengineAppsAuthorizedCertificatesGet_598062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_598079.validator(path, query, header, formData, body)
  let scheme = call_598079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598079.url(scheme.get, call_598079.host, call_598079.base,
                         call_598079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598079, url, valid)

proc call*(call_598080: Call_AppengineAppsAuthorizedCertificatesGet_598062;
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
  var path_598081 = newJObject()
  var query_598082 = newJObject()
  add(query_598082, "upload_protocol", newJString(uploadProtocol))
  add(query_598082, "fields", newJString(fields))
  add(query_598082, "view", newJString(view))
  add(query_598082, "quotaUser", newJString(quotaUser))
  add(query_598082, "alt", newJString(alt))
  add(query_598082, "oauth_token", newJString(oauthToken))
  add(query_598082, "callback", newJString(callback))
  add(query_598082, "access_token", newJString(accessToken))
  add(query_598082, "uploadType", newJString(uploadType))
  add(query_598082, "key", newJString(key))
  add(path_598081, "appsId", newJString(appsId))
  add(query_598082, "$.xgafv", newJString(Xgafv))
  add(query_598082, "prettyPrint", newJBool(prettyPrint))
  add(path_598081, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598080.call(path_598081, query_598082, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_598062(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_598063, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_598064,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_598103 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedCertificatesPatch_598105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesPatch_598104(path: JsonNode;
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
  var valid_598106 = path.getOrDefault("appsId")
  valid_598106 = validateParameter(valid_598106, JString, required = true,
                                 default = nil)
  if valid_598106 != nil:
    section.add "appsId", valid_598106
  var valid_598107 = path.getOrDefault("authorizedCertificatesId")
  valid_598107 = validateParameter(valid_598107, JString, required = true,
                                 default = nil)
  if valid_598107 != nil:
    section.add "authorizedCertificatesId", valid_598107
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
  var valid_598108 = query.getOrDefault("upload_protocol")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "upload_protocol", valid_598108
  var valid_598109 = query.getOrDefault("fields")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "fields", valid_598109
  var valid_598110 = query.getOrDefault("quotaUser")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "quotaUser", valid_598110
  var valid_598111 = query.getOrDefault("alt")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = newJString("json"))
  if valid_598111 != nil:
    section.add "alt", valid_598111
  var valid_598112 = query.getOrDefault("oauth_token")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "oauth_token", valid_598112
  var valid_598113 = query.getOrDefault("callback")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "callback", valid_598113
  var valid_598114 = query.getOrDefault("access_token")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "access_token", valid_598114
  var valid_598115 = query.getOrDefault("uploadType")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "uploadType", valid_598115
  var valid_598116 = query.getOrDefault("key")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "key", valid_598116
  var valid_598117 = query.getOrDefault("$.xgafv")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = newJString("1"))
  if valid_598117 != nil:
    section.add "$.xgafv", valid_598117
  var valid_598118 = query.getOrDefault("prettyPrint")
  valid_598118 = validateParameter(valid_598118, JBool, required = false,
                                 default = newJBool(true))
  if valid_598118 != nil:
    section.add "prettyPrint", valid_598118
  var valid_598119 = query.getOrDefault("updateMask")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "updateMask", valid_598119
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

proc call*(call_598121: Call_AppengineAppsAuthorizedCertificatesPatch_598103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_598121.validator(path, query, header, formData, body)
  let scheme = call_598121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598121.url(scheme.get, call_598121.host, call_598121.base,
                         call_598121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598121, url, valid)

proc call*(call_598122: Call_AppengineAppsAuthorizedCertificatesPatch_598103;
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
  var path_598123 = newJObject()
  var query_598124 = newJObject()
  var body_598125 = newJObject()
  add(query_598124, "upload_protocol", newJString(uploadProtocol))
  add(query_598124, "fields", newJString(fields))
  add(query_598124, "quotaUser", newJString(quotaUser))
  add(query_598124, "alt", newJString(alt))
  add(query_598124, "oauth_token", newJString(oauthToken))
  add(query_598124, "callback", newJString(callback))
  add(query_598124, "access_token", newJString(accessToken))
  add(query_598124, "uploadType", newJString(uploadType))
  add(query_598124, "key", newJString(key))
  add(path_598123, "appsId", newJString(appsId))
  add(query_598124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598125 = body
  add(query_598124, "prettyPrint", newJBool(prettyPrint))
  add(query_598124, "updateMask", newJString(updateMask))
  add(path_598123, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598122.call(path_598123, query_598124, nil, nil, body_598125)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_598103(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_598104,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_598105,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_598083 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedCertificatesDelete_598085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedCertificatesDelete_598084(path: JsonNode;
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
  var valid_598086 = path.getOrDefault("appsId")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "appsId", valid_598086
  var valid_598087 = path.getOrDefault("authorizedCertificatesId")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "authorizedCertificatesId", valid_598087
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
  var valid_598088 = query.getOrDefault("upload_protocol")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "upload_protocol", valid_598088
  var valid_598089 = query.getOrDefault("fields")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "fields", valid_598089
  var valid_598090 = query.getOrDefault("quotaUser")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "quotaUser", valid_598090
  var valid_598091 = query.getOrDefault("alt")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = newJString("json"))
  if valid_598091 != nil:
    section.add "alt", valid_598091
  var valid_598092 = query.getOrDefault("oauth_token")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "oauth_token", valid_598092
  var valid_598093 = query.getOrDefault("callback")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "callback", valid_598093
  var valid_598094 = query.getOrDefault("access_token")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "access_token", valid_598094
  var valid_598095 = query.getOrDefault("uploadType")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "uploadType", valid_598095
  var valid_598096 = query.getOrDefault("key")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "key", valid_598096
  var valid_598097 = query.getOrDefault("$.xgafv")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = newJString("1"))
  if valid_598097 != nil:
    section.add "$.xgafv", valid_598097
  var valid_598098 = query.getOrDefault("prettyPrint")
  valid_598098 = validateParameter(valid_598098, JBool, required = false,
                                 default = newJBool(true))
  if valid_598098 != nil:
    section.add "prettyPrint", valid_598098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598099: Call_AppengineAppsAuthorizedCertificatesDelete_598083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_598099.validator(path, query, header, formData, body)
  let scheme = call_598099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598099.url(scheme.get, call_598099.host, call_598099.base,
                         call_598099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598099, url, valid)

proc call*(call_598100: Call_AppengineAppsAuthorizedCertificatesDelete_598083;
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
  var path_598101 = newJObject()
  var query_598102 = newJObject()
  add(query_598102, "upload_protocol", newJString(uploadProtocol))
  add(query_598102, "fields", newJString(fields))
  add(query_598102, "quotaUser", newJString(quotaUser))
  add(query_598102, "alt", newJString(alt))
  add(query_598102, "oauth_token", newJString(oauthToken))
  add(query_598102, "callback", newJString(callback))
  add(query_598102, "access_token", newJString(accessToken))
  add(query_598102, "uploadType", newJString(uploadType))
  add(query_598102, "key", newJString(key))
  add(path_598101, "appsId", newJString(appsId))
  add(query_598102, "$.xgafv", newJString(Xgafv))
  add(query_598102, "prettyPrint", newJBool(prettyPrint))
  add(path_598101, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  result = call_598100.call(path_598101, query_598102, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_598083(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_598084,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_598085,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_598126 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsAuthorizedDomainsList_598128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsAuthorizedDomainsList_598127(path: JsonNode;
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
  var valid_598129 = path.getOrDefault("appsId")
  valid_598129 = validateParameter(valid_598129, JString, required = true,
                                 default = nil)
  if valid_598129 != nil:
    section.add "appsId", valid_598129
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
  var valid_598130 = query.getOrDefault("upload_protocol")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "upload_protocol", valid_598130
  var valid_598131 = query.getOrDefault("fields")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "fields", valid_598131
  var valid_598132 = query.getOrDefault("pageToken")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "pageToken", valid_598132
  var valid_598133 = query.getOrDefault("quotaUser")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "quotaUser", valid_598133
  var valid_598134 = query.getOrDefault("alt")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = newJString("json"))
  if valid_598134 != nil:
    section.add "alt", valid_598134
  var valid_598135 = query.getOrDefault("oauth_token")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "oauth_token", valid_598135
  var valid_598136 = query.getOrDefault("callback")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "callback", valid_598136
  var valid_598137 = query.getOrDefault("access_token")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "access_token", valid_598137
  var valid_598138 = query.getOrDefault("uploadType")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "uploadType", valid_598138
  var valid_598139 = query.getOrDefault("key")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "key", valid_598139
  var valid_598140 = query.getOrDefault("$.xgafv")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("1"))
  if valid_598140 != nil:
    section.add "$.xgafv", valid_598140
  var valid_598141 = query.getOrDefault("pageSize")
  valid_598141 = validateParameter(valid_598141, JInt, required = false, default = nil)
  if valid_598141 != nil:
    section.add "pageSize", valid_598141
  var valid_598142 = query.getOrDefault("prettyPrint")
  valid_598142 = validateParameter(valid_598142, JBool, required = false,
                                 default = newJBool(true))
  if valid_598142 != nil:
    section.add "prettyPrint", valid_598142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598143: Call_AppengineAppsAuthorizedDomainsList_598126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_598143.validator(path, query, header, formData, body)
  let scheme = call_598143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598143.url(scheme.get, call_598143.host, call_598143.base,
                         call_598143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598143, url, valid)

proc call*(call_598144: Call_AppengineAppsAuthorizedDomainsList_598126;
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
  var path_598145 = newJObject()
  var query_598146 = newJObject()
  add(query_598146, "upload_protocol", newJString(uploadProtocol))
  add(query_598146, "fields", newJString(fields))
  add(query_598146, "pageToken", newJString(pageToken))
  add(query_598146, "quotaUser", newJString(quotaUser))
  add(query_598146, "alt", newJString(alt))
  add(query_598146, "oauth_token", newJString(oauthToken))
  add(query_598146, "callback", newJString(callback))
  add(query_598146, "access_token", newJString(accessToken))
  add(query_598146, "uploadType", newJString(uploadType))
  add(query_598146, "key", newJString(key))
  add(path_598145, "appsId", newJString(appsId))
  add(query_598146, "$.xgafv", newJString(Xgafv))
  add(query_598146, "pageSize", newJInt(pageSize))
  add(query_598146, "prettyPrint", newJBool(prettyPrint))
  result = call_598144.call(path_598145, query_598146, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_598126(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_598127, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_598128, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_598168 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsDomainMappingsCreate_598170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsCreate_598169(path: JsonNode;
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
  var valid_598171 = path.getOrDefault("appsId")
  valid_598171 = validateParameter(valid_598171, JString, required = true,
                                 default = nil)
  if valid_598171 != nil:
    section.add "appsId", valid_598171
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
  var valid_598172 = query.getOrDefault("upload_protocol")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "upload_protocol", valid_598172
  var valid_598173 = query.getOrDefault("fields")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "fields", valid_598173
  var valid_598174 = query.getOrDefault("quotaUser")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "quotaUser", valid_598174
  var valid_598175 = query.getOrDefault("alt")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = newJString("json"))
  if valid_598175 != nil:
    section.add "alt", valid_598175
  var valid_598176 = query.getOrDefault("oauth_token")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "oauth_token", valid_598176
  var valid_598177 = query.getOrDefault("callback")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "callback", valid_598177
  var valid_598178 = query.getOrDefault("access_token")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "access_token", valid_598178
  var valid_598179 = query.getOrDefault("uploadType")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "uploadType", valid_598179
  var valid_598180 = query.getOrDefault("key")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "key", valid_598180
  var valid_598181 = query.getOrDefault("$.xgafv")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = newJString("1"))
  if valid_598181 != nil:
    section.add "$.xgafv", valid_598181
  var valid_598182 = query.getOrDefault("prettyPrint")
  valid_598182 = validateParameter(valid_598182, JBool, required = false,
                                 default = newJBool(true))
  if valid_598182 != nil:
    section.add "prettyPrint", valid_598182
  var valid_598183 = query.getOrDefault("overrideStrategy")
  valid_598183 = validateParameter(valid_598183, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_598183 != nil:
    section.add "overrideStrategy", valid_598183
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

proc call*(call_598185: Call_AppengineAppsDomainMappingsCreate_598168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_598185.validator(path, query, header, formData, body)
  let scheme = call_598185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598185.url(scheme.get, call_598185.host, call_598185.base,
                         call_598185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598185, url, valid)

proc call*(call_598186: Call_AppengineAppsDomainMappingsCreate_598168;
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
  var path_598187 = newJObject()
  var query_598188 = newJObject()
  var body_598189 = newJObject()
  add(query_598188, "upload_protocol", newJString(uploadProtocol))
  add(query_598188, "fields", newJString(fields))
  add(query_598188, "quotaUser", newJString(quotaUser))
  add(query_598188, "alt", newJString(alt))
  add(query_598188, "oauth_token", newJString(oauthToken))
  add(query_598188, "callback", newJString(callback))
  add(query_598188, "access_token", newJString(accessToken))
  add(query_598188, "uploadType", newJString(uploadType))
  add(query_598188, "key", newJString(key))
  add(path_598187, "appsId", newJString(appsId))
  add(query_598188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598189 = body
  add(query_598188, "prettyPrint", newJBool(prettyPrint))
  add(query_598188, "overrideStrategy", newJString(overrideStrategy))
  result = call_598186.call(path_598187, query_598188, nil, nil, body_598189)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_598168(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_598169, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_598170, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_598147 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsDomainMappingsList_598149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsList_598148(path: JsonNode;
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
  var valid_598150 = path.getOrDefault("appsId")
  valid_598150 = validateParameter(valid_598150, JString, required = true,
                                 default = nil)
  if valid_598150 != nil:
    section.add "appsId", valid_598150
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
  var valid_598151 = query.getOrDefault("upload_protocol")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "upload_protocol", valid_598151
  var valid_598152 = query.getOrDefault("fields")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "fields", valid_598152
  var valid_598153 = query.getOrDefault("pageToken")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "pageToken", valid_598153
  var valid_598154 = query.getOrDefault("quotaUser")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "quotaUser", valid_598154
  var valid_598155 = query.getOrDefault("alt")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = newJString("json"))
  if valid_598155 != nil:
    section.add "alt", valid_598155
  var valid_598156 = query.getOrDefault("oauth_token")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "oauth_token", valid_598156
  var valid_598157 = query.getOrDefault("callback")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "callback", valid_598157
  var valid_598158 = query.getOrDefault("access_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "access_token", valid_598158
  var valid_598159 = query.getOrDefault("uploadType")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "uploadType", valid_598159
  var valid_598160 = query.getOrDefault("key")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "key", valid_598160
  var valid_598161 = query.getOrDefault("$.xgafv")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("1"))
  if valid_598161 != nil:
    section.add "$.xgafv", valid_598161
  var valid_598162 = query.getOrDefault("pageSize")
  valid_598162 = validateParameter(valid_598162, JInt, required = false, default = nil)
  if valid_598162 != nil:
    section.add "pageSize", valid_598162
  var valid_598163 = query.getOrDefault("prettyPrint")
  valid_598163 = validateParameter(valid_598163, JBool, required = false,
                                 default = newJBool(true))
  if valid_598163 != nil:
    section.add "prettyPrint", valid_598163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598164: Call_AppengineAppsDomainMappingsList_598147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_AppengineAppsDomainMappingsList_598147;
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
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  add(query_598167, "upload_protocol", newJString(uploadProtocol))
  add(query_598167, "fields", newJString(fields))
  add(query_598167, "pageToken", newJString(pageToken))
  add(query_598167, "quotaUser", newJString(quotaUser))
  add(query_598167, "alt", newJString(alt))
  add(query_598167, "oauth_token", newJString(oauthToken))
  add(query_598167, "callback", newJString(callback))
  add(query_598167, "access_token", newJString(accessToken))
  add(query_598167, "uploadType", newJString(uploadType))
  add(query_598167, "key", newJString(key))
  add(path_598166, "appsId", newJString(appsId))
  add(query_598167, "$.xgafv", newJString(Xgafv))
  add(query_598167, "pageSize", newJInt(pageSize))
  add(query_598167, "prettyPrint", newJBool(prettyPrint))
  result = call_598165.call(path_598166, query_598167, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_598147(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_598148, base: "/",
    url: url_AppengineAppsDomainMappingsList_598149, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_598190 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsDomainMappingsGet_598192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsGet_598191(path: JsonNode;
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
  var valid_598193 = path.getOrDefault("appsId")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "appsId", valid_598193
  var valid_598194 = path.getOrDefault("domainMappingsId")
  valid_598194 = validateParameter(valid_598194, JString, required = true,
                                 default = nil)
  if valid_598194 != nil:
    section.add "domainMappingsId", valid_598194
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
  var valid_598195 = query.getOrDefault("upload_protocol")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "upload_protocol", valid_598195
  var valid_598196 = query.getOrDefault("fields")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "fields", valid_598196
  var valid_598197 = query.getOrDefault("quotaUser")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "quotaUser", valid_598197
  var valid_598198 = query.getOrDefault("alt")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = newJString("json"))
  if valid_598198 != nil:
    section.add "alt", valid_598198
  var valid_598199 = query.getOrDefault("oauth_token")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "oauth_token", valid_598199
  var valid_598200 = query.getOrDefault("callback")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "callback", valid_598200
  var valid_598201 = query.getOrDefault("access_token")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "access_token", valid_598201
  var valid_598202 = query.getOrDefault("uploadType")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "uploadType", valid_598202
  var valid_598203 = query.getOrDefault("key")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "key", valid_598203
  var valid_598204 = query.getOrDefault("$.xgafv")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = newJString("1"))
  if valid_598204 != nil:
    section.add "$.xgafv", valid_598204
  var valid_598205 = query.getOrDefault("prettyPrint")
  valid_598205 = validateParameter(valid_598205, JBool, required = false,
                                 default = newJBool(true))
  if valid_598205 != nil:
    section.add "prettyPrint", valid_598205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598206: Call_AppengineAppsDomainMappingsGet_598190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_598206.validator(path, query, header, formData, body)
  let scheme = call_598206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598206.url(scheme.get, call_598206.host, call_598206.base,
                         call_598206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598206, url, valid)

proc call*(call_598207: Call_AppengineAppsDomainMappingsGet_598190; appsId: string;
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
  var path_598208 = newJObject()
  var query_598209 = newJObject()
  add(query_598209, "upload_protocol", newJString(uploadProtocol))
  add(query_598209, "fields", newJString(fields))
  add(query_598209, "quotaUser", newJString(quotaUser))
  add(query_598209, "alt", newJString(alt))
  add(query_598209, "oauth_token", newJString(oauthToken))
  add(query_598209, "callback", newJString(callback))
  add(query_598209, "access_token", newJString(accessToken))
  add(query_598209, "uploadType", newJString(uploadType))
  add(query_598209, "key", newJString(key))
  add(path_598208, "appsId", newJString(appsId))
  add(query_598209, "$.xgafv", newJString(Xgafv))
  add(query_598209, "prettyPrint", newJBool(prettyPrint))
  add(path_598208, "domainMappingsId", newJString(domainMappingsId))
  result = call_598207.call(path_598208, query_598209, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_598190(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_598191, base: "/",
    url: url_AppengineAppsDomainMappingsGet_598192, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_598230 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsDomainMappingsPatch_598232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsPatch_598231(path: JsonNode;
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
  var valid_598233 = path.getOrDefault("appsId")
  valid_598233 = validateParameter(valid_598233, JString, required = true,
                                 default = nil)
  if valid_598233 != nil:
    section.add "appsId", valid_598233
  var valid_598234 = path.getOrDefault("domainMappingsId")
  valid_598234 = validateParameter(valid_598234, JString, required = true,
                                 default = nil)
  if valid_598234 != nil:
    section.add "domainMappingsId", valid_598234
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
  var valid_598235 = query.getOrDefault("upload_protocol")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "upload_protocol", valid_598235
  var valid_598236 = query.getOrDefault("fields")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "fields", valid_598236
  var valid_598237 = query.getOrDefault("quotaUser")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "quotaUser", valid_598237
  var valid_598238 = query.getOrDefault("alt")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = newJString("json"))
  if valid_598238 != nil:
    section.add "alt", valid_598238
  var valid_598239 = query.getOrDefault("oauth_token")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "oauth_token", valid_598239
  var valid_598240 = query.getOrDefault("callback")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "callback", valid_598240
  var valid_598241 = query.getOrDefault("access_token")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "access_token", valid_598241
  var valid_598242 = query.getOrDefault("uploadType")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "uploadType", valid_598242
  var valid_598243 = query.getOrDefault("key")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "key", valid_598243
  var valid_598244 = query.getOrDefault("$.xgafv")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = newJString("1"))
  if valid_598244 != nil:
    section.add "$.xgafv", valid_598244
  var valid_598245 = query.getOrDefault("prettyPrint")
  valid_598245 = validateParameter(valid_598245, JBool, required = false,
                                 default = newJBool(true))
  if valid_598245 != nil:
    section.add "prettyPrint", valid_598245
  var valid_598246 = query.getOrDefault("updateMask")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "updateMask", valid_598246
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

proc call*(call_598248: Call_AppengineAppsDomainMappingsPatch_598230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_598248.validator(path, query, header, formData, body)
  let scheme = call_598248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598248.url(scheme.get, call_598248.host, call_598248.base,
                         call_598248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598248, url, valid)

proc call*(call_598249: Call_AppengineAppsDomainMappingsPatch_598230;
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
  var path_598250 = newJObject()
  var query_598251 = newJObject()
  var body_598252 = newJObject()
  add(query_598251, "upload_protocol", newJString(uploadProtocol))
  add(query_598251, "fields", newJString(fields))
  add(query_598251, "quotaUser", newJString(quotaUser))
  add(query_598251, "alt", newJString(alt))
  add(query_598251, "oauth_token", newJString(oauthToken))
  add(query_598251, "callback", newJString(callback))
  add(query_598251, "access_token", newJString(accessToken))
  add(query_598251, "uploadType", newJString(uploadType))
  add(query_598251, "key", newJString(key))
  add(path_598250, "appsId", newJString(appsId))
  add(query_598251, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598252 = body
  add(query_598251, "prettyPrint", newJBool(prettyPrint))
  add(path_598250, "domainMappingsId", newJString(domainMappingsId))
  add(query_598251, "updateMask", newJString(updateMask))
  result = call_598249.call(path_598250, query_598251, nil, nil, body_598252)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_598230(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_598231, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_598232, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_598210 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsDomainMappingsDelete_598212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsDomainMappingsDelete_598211(path: JsonNode;
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
  var valid_598213 = path.getOrDefault("appsId")
  valid_598213 = validateParameter(valid_598213, JString, required = true,
                                 default = nil)
  if valid_598213 != nil:
    section.add "appsId", valid_598213
  var valid_598214 = path.getOrDefault("domainMappingsId")
  valid_598214 = validateParameter(valid_598214, JString, required = true,
                                 default = nil)
  if valid_598214 != nil:
    section.add "domainMappingsId", valid_598214
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
  var valid_598215 = query.getOrDefault("upload_protocol")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "upload_protocol", valid_598215
  var valid_598216 = query.getOrDefault("fields")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "fields", valid_598216
  var valid_598217 = query.getOrDefault("quotaUser")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "quotaUser", valid_598217
  var valid_598218 = query.getOrDefault("alt")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = newJString("json"))
  if valid_598218 != nil:
    section.add "alt", valid_598218
  var valid_598219 = query.getOrDefault("oauth_token")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "oauth_token", valid_598219
  var valid_598220 = query.getOrDefault("callback")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "callback", valid_598220
  var valid_598221 = query.getOrDefault("access_token")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "access_token", valid_598221
  var valid_598222 = query.getOrDefault("uploadType")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "uploadType", valid_598222
  var valid_598223 = query.getOrDefault("key")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "key", valid_598223
  var valid_598224 = query.getOrDefault("$.xgafv")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = newJString("1"))
  if valid_598224 != nil:
    section.add "$.xgafv", valid_598224
  var valid_598225 = query.getOrDefault("prettyPrint")
  valid_598225 = validateParameter(valid_598225, JBool, required = false,
                                 default = newJBool(true))
  if valid_598225 != nil:
    section.add "prettyPrint", valid_598225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598226: Call_AppengineAppsDomainMappingsDelete_598210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_598226.validator(path, query, header, formData, body)
  let scheme = call_598226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598226.url(scheme.get, call_598226.host, call_598226.base,
                         call_598226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598226, url, valid)

proc call*(call_598227: Call_AppengineAppsDomainMappingsDelete_598210;
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
  var path_598228 = newJObject()
  var query_598229 = newJObject()
  add(query_598229, "upload_protocol", newJString(uploadProtocol))
  add(query_598229, "fields", newJString(fields))
  add(query_598229, "quotaUser", newJString(quotaUser))
  add(query_598229, "alt", newJString(alt))
  add(query_598229, "oauth_token", newJString(oauthToken))
  add(query_598229, "callback", newJString(callback))
  add(query_598229, "access_token", newJString(accessToken))
  add(query_598229, "uploadType", newJString(uploadType))
  add(query_598229, "key", newJString(key))
  add(path_598228, "appsId", newJString(appsId))
  add(query_598229, "$.xgafv", newJString(Xgafv))
  add(query_598229, "prettyPrint", newJBool(prettyPrint))
  add(path_598228, "domainMappingsId", newJString(domainMappingsId))
  result = call_598227.call(path_598228, query_598229, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_598210(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_598211, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_598212, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesCreate_598275 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesCreate_598277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesCreate_598276(path: JsonNode;
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
  var valid_598278 = path.getOrDefault("appsId")
  valid_598278 = validateParameter(valid_598278, JString, required = true,
                                 default = nil)
  if valid_598278 != nil:
    section.add "appsId", valid_598278
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
  var valid_598279 = query.getOrDefault("upload_protocol")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "upload_protocol", valid_598279
  var valid_598280 = query.getOrDefault("fields")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "fields", valid_598280
  var valid_598281 = query.getOrDefault("quotaUser")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "quotaUser", valid_598281
  var valid_598282 = query.getOrDefault("alt")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = newJString("json"))
  if valid_598282 != nil:
    section.add "alt", valid_598282
  var valid_598283 = query.getOrDefault("oauth_token")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "oauth_token", valid_598283
  var valid_598284 = query.getOrDefault("callback")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "callback", valid_598284
  var valid_598285 = query.getOrDefault("access_token")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "access_token", valid_598285
  var valid_598286 = query.getOrDefault("uploadType")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "uploadType", valid_598286
  var valid_598287 = query.getOrDefault("key")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "key", valid_598287
  var valid_598288 = query.getOrDefault("$.xgafv")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = newJString("1"))
  if valid_598288 != nil:
    section.add "$.xgafv", valid_598288
  var valid_598289 = query.getOrDefault("prettyPrint")
  valid_598289 = validateParameter(valid_598289, JBool, required = false,
                                 default = newJBool(true))
  if valid_598289 != nil:
    section.add "prettyPrint", valid_598289
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

proc call*(call_598291: Call_AppengineAppsFirewallIngressRulesCreate_598275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a firewall rule for the application.
  ## 
  let valid = call_598291.validator(path, query, header, formData, body)
  let scheme = call_598291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598291.url(scheme.get, call_598291.host, call_598291.base,
                         call_598291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598291, url, valid)

proc call*(call_598292: Call_AppengineAppsFirewallIngressRulesCreate_598275;
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
  var path_598293 = newJObject()
  var query_598294 = newJObject()
  var body_598295 = newJObject()
  add(query_598294, "upload_protocol", newJString(uploadProtocol))
  add(query_598294, "fields", newJString(fields))
  add(query_598294, "quotaUser", newJString(quotaUser))
  add(query_598294, "alt", newJString(alt))
  add(query_598294, "oauth_token", newJString(oauthToken))
  add(query_598294, "callback", newJString(callback))
  add(query_598294, "access_token", newJString(accessToken))
  add(query_598294, "uploadType", newJString(uploadType))
  add(query_598294, "key", newJString(key))
  add(path_598293, "appsId", newJString(appsId))
  add(query_598294, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598295 = body
  add(query_598294, "prettyPrint", newJBool(prettyPrint))
  result = call_598292.call(path_598293, query_598294, nil, nil, body_598295)

var appengineAppsFirewallIngressRulesCreate* = Call_AppengineAppsFirewallIngressRulesCreate_598275(
    name: "appengineAppsFirewallIngressRulesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesCreate_598276, base: "/",
    url: url_AppengineAppsFirewallIngressRulesCreate_598277,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesList_598253 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesList_598255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesList_598254(path: JsonNode;
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
  var valid_598256 = path.getOrDefault("appsId")
  valid_598256 = validateParameter(valid_598256, JString, required = true,
                                 default = nil)
  if valid_598256 != nil:
    section.add "appsId", valid_598256
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
  var valid_598257 = query.getOrDefault("upload_protocol")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "upload_protocol", valid_598257
  var valid_598258 = query.getOrDefault("fields")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "fields", valid_598258
  var valid_598259 = query.getOrDefault("pageToken")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "pageToken", valid_598259
  var valid_598260 = query.getOrDefault("quotaUser")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "quotaUser", valid_598260
  var valid_598261 = query.getOrDefault("alt")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = newJString("json"))
  if valid_598261 != nil:
    section.add "alt", valid_598261
  var valid_598262 = query.getOrDefault("oauth_token")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "oauth_token", valid_598262
  var valid_598263 = query.getOrDefault("callback")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "callback", valid_598263
  var valid_598264 = query.getOrDefault("access_token")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "access_token", valid_598264
  var valid_598265 = query.getOrDefault("uploadType")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "uploadType", valid_598265
  var valid_598266 = query.getOrDefault("matchingAddress")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "matchingAddress", valid_598266
  var valid_598267 = query.getOrDefault("key")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "key", valid_598267
  var valid_598268 = query.getOrDefault("$.xgafv")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = newJString("1"))
  if valid_598268 != nil:
    section.add "$.xgafv", valid_598268
  var valid_598269 = query.getOrDefault("pageSize")
  valid_598269 = validateParameter(valid_598269, JInt, required = false, default = nil)
  if valid_598269 != nil:
    section.add "pageSize", valid_598269
  var valid_598270 = query.getOrDefault("prettyPrint")
  valid_598270 = validateParameter(valid_598270, JBool, required = false,
                                 default = newJBool(true))
  if valid_598270 != nil:
    section.add "prettyPrint", valid_598270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598271: Call_AppengineAppsFirewallIngressRulesList_598253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the firewall rules of an application.
  ## 
  let valid = call_598271.validator(path, query, header, formData, body)
  let scheme = call_598271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598271.url(scheme.get, call_598271.host, call_598271.base,
                         call_598271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598271, url, valid)

proc call*(call_598272: Call_AppengineAppsFirewallIngressRulesList_598253;
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
  var path_598273 = newJObject()
  var query_598274 = newJObject()
  add(query_598274, "upload_protocol", newJString(uploadProtocol))
  add(query_598274, "fields", newJString(fields))
  add(query_598274, "pageToken", newJString(pageToken))
  add(query_598274, "quotaUser", newJString(quotaUser))
  add(query_598274, "alt", newJString(alt))
  add(query_598274, "oauth_token", newJString(oauthToken))
  add(query_598274, "callback", newJString(callback))
  add(query_598274, "access_token", newJString(accessToken))
  add(query_598274, "uploadType", newJString(uploadType))
  add(query_598274, "matchingAddress", newJString(matchingAddress))
  add(query_598274, "key", newJString(key))
  add(path_598273, "appsId", newJString(appsId))
  add(query_598274, "$.xgafv", newJString(Xgafv))
  add(query_598274, "pageSize", newJInt(pageSize))
  add(query_598274, "prettyPrint", newJBool(prettyPrint))
  result = call_598272.call(path_598273, query_598274, nil, nil, nil)

var appengineAppsFirewallIngressRulesList* = Call_AppengineAppsFirewallIngressRulesList_598253(
    name: "appengineAppsFirewallIngressRulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesList_598254, base: "/",
    url: url_AppengineAppsFirewallIngressRulesList_598255, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesGet_598296 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesGet_598298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesGet_598297(path: JsonNode;
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
  var valid_598299 = path.getOrDefault("ingressRulesId")
  valid_598299 = validateParameter(valid_598299, JString, required = true,
                                 default = nil)
  if valid_598299 != nil:
    section.add "ingressRulesId", valid_598299
  var valid_598300 = path.getOrDefault("appsId")
  valid_598300 = validateParameter(valid_598300, JString, required = true,
                                 default = nil)
  if valid_598300 != nil:
    section.add "appsId", valid_598300
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
  var valid_598301 = query.getOrDefault("upload_protocol")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "upload_protocol", valid_598301
  var valid_598302 = query.getOrDefault("fields")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "fields", valid_598302
  var valid_598303 = query.getOrDefault("quotaUser")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "quotaUser", valid_598303
  var valid_598304 = query.getOrDefault("alt")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = newJString("json"))
  if valid_598304 != nil:
    section.add "alt", valid_598304
  var valid_598305 = query.getOrDefault("oauth_token")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "oauth_token", valid_598305
  var valid_598306 = query.getOrDefault("callback")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "callback", valid_598306
  var valid_598307 = query.getOrDefault("access_token")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "access_token", valid_598307
  var valid_598308 = query.getOrDefault("uploadType")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "uploadType", valid_598308
  var valid_598309 = query.getOrDefault("key")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "key", valid_598309
  var valid_598310 = query.getOrDefault("$.xgafv")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = newJString("1"))
  if valid_598310 != nil:
    section.add "$.xgafv", valid_598310
  var valid_598311 = query.getOrDefault("prettyPrint")
  valid_598311 = validateParameter(valid_598311, JBool, required = false,
                                 default = newJBool(true))
  if valid_598311 != nil:
    section.add "prettyPrint", valid_598311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598312: Call_AppengineAppsFirewallIngressRulesGet_598296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified firewall rule.
  ## 
  let valid = call_598312.validator(path, query, header, formData, body)
  let scheme = call_598312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598312.url(scheme.get, call_598312.host, call_598312.base,
                         call_598312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598312, url, valid)

proc call*(call_598313: Call_AppengineAppsFirewallIngressRulesGet_598296;
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
  var path_598314 = newJObject()
  var query_598315 = newJObject()
  add(query_598315, "upload_protocol", newJString(uploadProtocol))
  add(path_598314, "ingressRulesId", newJString(ingressRulesId))
  add(query_598315, "fields", newJString(fields))
  add(query_598315, "quotaUser", newJString(quotaUser))
  add(query_598315, "alt", newJString(alt))
  add(query_598315, "oauth_token", newJString(oauthToken))
  add(query_598315, "callback", newJString(callback))
  add(query_598315, "access_token", newJString(accessToken))
  add(query_598315, "uploadType", newJString(uploadType))
  add(query_598315, "key", newJString(key))
  add(path_598314, "appsId", newJString(appsId))
  add(query_598315, "$.xgafv", newJString(Xgafv))
  add(query_598315, "prettyPrint", newJBool(prettyPrint))
  result = call_598313.call(path_598314, query_598315, nil, nil, nil)

var appengineAppsFirewallIngressRulesGet* = Call_AppengineAppsFirewallIngressRulesGet_598296(
    name: "appengineAppsFirewallIngressRulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesGet_598297, base: "/",
    url: url_AppengineAppsFirewallIngressRulesGet_598298, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesPatch_598336 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesPatch_598338(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesPatch_598337(path: JsonNode;
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
  var valid_598339 = path.getOrDefault("ingressRulesId")
  valid_598339 = validateParameter(valid_598339, JString, required = true,
                                 default = nil)
  if valid_598339 != nil:
    section.add "ingressRulesId", valid_598339
  var valid_598340 = path.getOrDefault("appsId")
  valid_598340 = validateParameter(valid_598340, JString, required = true,
                                 default = nil)
  if valid_598340 != nil:
    section.add "appsId", valid_598340
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
  var valid_598341 = query.getOrDefault("upload_protocol")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "upload_protocol", valid_598341
  var valid_598342 = query.getOrDefault("fields")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "fields", valid_598342
  var valid_598343 = query.getOrDefault("quotaUser")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "quotaUser", valid_598343
  var valid_598344 = query.getOrDefault("alt")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = newJString("json"))
  if valid_598344 != nil:
    section.add "alt", valid_598344
  var valid_598345 = query.getOrDefault("oauth_token")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "oauth_token", valid_598345
  var valid_598346 = query.getOrDefault("callback")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "callback", valid_598346
  var valid_598347 = query.getOrDefault("access_token")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "access_token", valid_598347
  var valid_598348 = query.getOrDefault("uploadType")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "uploadType", valid_598348
  var valid_598349 = query.getOrDefault("key")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "key", valid_598349
  var valid_598350 = query.getOrDefault("$.xgafv")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = newJString("1"))
  if valid_598350 != nil:
    section.add "$.xgafv", valid_598350
  var valid_598351 = query.getOrDefault("prettyPrint")
  valid_598351 = validateParameter(valid_598351, JBool, required = false,
                                 default = newJBool(true))
  if valid_598351 != nil:
    section.add "prettyPrint", valid_598351
  var valid_598352 = query.getOrDefault("updateMask")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "updateMask", valid_598352
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

proc call*(call_598354: Call_AppengineAppsFirewallIngressRulesPatch_598336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_598354.validator(path, query, header, formData, body)
  let scheme = call_598354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598354.url(scheme.get, call_598354.host, call_598354.base,
                         call_598354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598354, url, valid)

proc call*(call_598355: Call_AppengineAppsFirewallIngressRulesPatch_598336;
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
  var path_598356 = newJObject()
  var query_598357 = newJObject()
  var body_598358 = newJObject()
  add(query_598357, "upload_protocol", newJString(uploadProtocol))
  add(path_598356, "ingressRulesId", newJString(ingressRulesId))
  add(query_598357, "fields", newJString(fields))
  add(query_598357, "quotaUser", newJString(quotaUser))
  add(query_598357, "alt", newJString(alt))
  add(query_598357, "oauth_token", newJString(oauthToken))
  add(query_598357, "callback", newJString(callback))
  add(query_598357, "access_token", newJString(accessToken))
  add(query_598357, "uploadType", newJString(uploadType))
  add(query_598357, "key", newJString(key))
  add(path_598356, "appsId", newJString(appsId))
  add(query_598357, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598358 = body
  add(query_598357, "prettyPrint", newJBool(prettyPrint))
  add(query_598357, "updateMask", newJString(updateMask))
  result = call_598355.call(path_598356, query_598357, nil, nil, body_598358)

var appengineAppsFirewallIngressRulesPatch* = Call_AppengineAppsFirewallIngressRulesPatch_598336(
    name: "appengineAppsFirewallIngressRulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesPatch_598337, base: "/",
    url: url_AppengineAppsFirewallIngressRulesPatch_598338,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesDelete_598316 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesDelete_598318(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesDelete_598317(path: JsonNode;
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
  var valid_598319 = path.getOrDefault("ingressRulesId")
  valid_598319 = validateParameter(valid_598319, JString, required = true,
                                 default = nil)
  if valid_598319 != nil:
    section.add "ingressRulesId", valid_598319
  var valid_598320 = path.getOrDefault("appsId")
  valid_598320 = validateParameter(valid_598320, JString, required = true,
                                 default = nil)
  if valid_598320 != nil:
    section.add "appsId", valid_598320
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
  var valid_598321 = query.getOrDefault("upload_protocol")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "upload_protocol", valid_598321
  var valid_598322 = query.getOrDefault("fields")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "fields", valid_598322
  var valid_598323 = query.getOrDefault("quotaUser")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "quotaUser", valid_598323
  var valid_598324 = query.getOrDefault("alt")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = newJString("json"))
  if valid_598324 != nil:
    section.add "alt", valid_598324
  var valid_598325 = query.getOrDefault("oauth_token")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "oauth_token", valid_598325
  var valid_598326 = query.getOrDefault("callback")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "callback", valid_598326
  var valid_598327 = query.getOrDefault("access_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "access_token", valid_598327
  var valid_598328 = query.getOrDefault("uploadType")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "uploadType", valid_598328
  var valid_598329 = query.getOrDefault("key")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "key", valid_598329
  var valid_598330 = query.getOrDefault("$.xgafv")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = newJString("1"))
  if valid_598330 != nil:
    section.add "$.xgafv", valid_598330
  var valid_598331 = query.getOrDefault("prettyPrint")
  valid_598331 = validateParameter(valid_598331, JBool, required = false,
                                 default = newJBool(true))
  if valid_598331 != nil:
    section.add "prettyPrint", valid_598331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598332: Call_AppengineAppsFirewallIngressRulesDelete_598316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified firewall rule.
  ## 
  let valid = call_598332.validator(path, query, header, formData, body)
  let scheme = call_598332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598332.url(scheme.get, call_598332.host, call_598332.base,
                         call_598332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598332, url, valid)

proc call*(call_598333: Call_AppengineAppsFirewallIngressRulesDelete_598316;
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
  var path_598334 = newJObject()
  var query_598335 = newJObject()
  add(query_598335, "upload_protocol", newJString(uploadProtocol))
  add(path_598334, "ingressRulesId", newJString(ingressRulesId))
  add(query_598335, "fields", newJString(fields))
  add(query_598335, "quotaUser", newJString(quotaUser))
  add(query_598335, "alt", newJString(alt))
  add(query_598335, "oauth_token", newJString(oauthToken))
  add(query_598335, "callback", newJString(callback))
  add(query_598335, "access_token", newJString(accessToken))
  add(query_598335, "uploadType", newJString(uploadType))
  add(query_598335, "key", newJString(key))
  add(path_598334, "appsId", newJString(appsId))
  add(query_598335, "$.xgafv", newJString(Xgafv))
  add(query_598335, "prettyPrint", newJBool(prettyPrint))
  result = call_598333.call(path_598334, query_598335, nil, nil, nil)

var appengineAppsFirewallIngressRulesDelete* = Call_AppengineAppsFirewallIngressRulesDelete_598316(
    name: "appengineAppsFirewallIngressRulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesDelete_598317, base: "/",
    url: url_AppengineAppsFirewallIngressRulesDelete_598318,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesBatchUpdate_598359 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsFirewallIngressRulesBatchUpdate_598361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsFirewallIngressRulesBatchUpdate_598360(path: JsonNode;
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
  var valid_598362 = path.getOrDefault("appsId")
  valid_598362 = validateParameter(valid_598362, JString, required = true,
                                 default = nil)
  if valid_598362 != nil:
    section.add "appsId", valid_598362
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
  var valid_598363 = query.getOrDefault("upload_protocol")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = nil)
  if valid_598363 != nil:
    section.add "upload_protocol", valid_598363
  var valid_598364 = query.getOrDefault("fields")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "fields", valid_598364
  var valid_598365 = query.getOrDefault("quotaUser")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "quotaUser", valid_598365
  var valid_598366 = query.getOrDefault("alt")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = newJString("json"))
  if valid_598366 != nil:
    section.add "alt", valid_598366
  var valid_598367 = query.getOrDefault("oauth_token")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "oauth_token", valid_598367
  var valid_598368 = query.getOrDefault("callback")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "callback", valid_598368
  var valid_598369 = query.getOrDefault("access_token")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "access_token", valid_598369
  var valid_598370 = query.getOrDefault("uploadType")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "uploadType", valid_598370
  var valid_598371 = query.getOrDefault("key")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "key", valid_598371
  var valid_598372 = query.getOrDefault("$.xgafv")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = newJString("1"))
  if valid_598372 != nil:
    section.add "$.xgafv", valid_598372
  var valid_598373 = query.getOrDefault("prettyPrint")
  valid_598373 = validateParameter(valid_598373, JBool, required = false,
                                 default = newJBool(true))
  if valid_598373 != nil:
    section.add "prettyPrint", valid_598373
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

proc call*(call_598375: Call_AppengineAppsFirewallIngressRulesBatchUpdate_598359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
  ## 
  let valid = call_598375.validator(path, query, header, formData, body)
  let scheme = call_598375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598375.url(scheme.get, call_598375.host, call_598375.base,
                         call_598375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598375, url, valid)

proc call*(call_598376: Call_AppengineAppsFirewallIngressRulesBatchUpdate_598359;
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
  var path_598377 = newJObject()
  var query_598378 = newJObject()
  var body_598379 = newJObject()
  add(query_598378, "upload_protocol", newJString(uploadProtocol))
  add(query_598378, "fields", newJString(fields))
  add(query_598378, "quotaUser", newJString(quotaUser))
  add(query_598378, "alt", newJString(alt))
  add(query_598378, "oauth_token", newJString(oauthToken))
  add(query_598378, "callback", newJString(callback))
  add(query_598378, "access_token", newJString(accessToken))
  add(query_598378, "uploadType", newJString(uploadType))
  add(query_598378, "key", newJString(key))
  add(path_598377, "appsId", newJString(appsId))
  add(query_598378, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598379 = body
  add(query_598378, "prettyPrint", newJBool(prettyPrint))
  result = call_598376.call(path_598377, query_598378, nil, nil, body_598379)

var appengineAppsFirewallIngressRulesBatchUpdate* = Call_AppengineAppsFirewallIngressRulesBatchUpdate_598359(
    name: "appengineAppsFirewallIngressRulesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/firewall/ingressRules:batchUpdate",
    validator: validate_AppengineAppsFirewallIngressRulesBatchUpdate_598360,
    base: "/", url: url_AppengineAppsFirewallIngressRulesBatchUpdate_598361,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_598380 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsLocationsList_598382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsLocationsList_598381(path: JsonNode; query: JsonNode;
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
  var valid_598383 = path.getOrDefault("appsId")
  valid_598383 = validateParameter(valid_598383, JString, required = true,
                                 default = nil)
  if valid_598383 != nil:
    section.add "appsId", valid_598383
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
  var valid_598384 = query.getOrDefault("upload_protocol")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "upload_protocol", valid_598384
  var valid_598385 = query.getOrDefault("fields")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "fields", valid_598385
  var valid_598386 = query.getOrDefault("pageToken")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "pageToken", valid_598386
  var valid_598387 = query.getOrDefault("quotaUser")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "quotaUser", valid_598387
  var valid_598388 = query.getOrDefault("alt")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = newJString("json"))
  if valid_598388 != nil:
    section.add "alt", valid_598388
  var valid_598389 = query.getOrDefault("oauth_token")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "oauth_token", valid_598389
  var valid_598390 = query.getOrDefault("callback")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "callback", valid_598390
  var valid_598391 = query.getOrDefault("access_token")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "access_token", valid_598391
  var valid_598392 = query.getOrDefault("uploadType")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "uploadType", valid_598392
  var valid_598393 = query.getOrDefault("key")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "key", valid_598393
  var valid_598394 = query.getOrDefault("$.xgafv")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = newJString("1"))
  if valid_598394 != nil:
    section.add "$.xgafv", valid_598394
  var valid_598395 = query.getOrDefault("pageSize")
  valid_598395 = validateParameter(valid_598395, JInt, required = false, default = nil)
  if valid_598395 != nil:
    section.add "pageSize", valid_598395
  var valid_598396 = query.getOrDefault("prettyPrint")
  valid_598396 = validateParameter(valid_598396, JBool, required = false,
                                 default = newJBool(true))
  if valid_598396 != nil:
    section.add "prettyPrint", valid_598396
  var valid_598397 = query.getOrDefault("filter")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = nil)
  if valid_598397 != nil:
    section.add "filter", valid_598397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598398: Call_AppengineAppsLocationsList_598380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598398.validator(path, query, header, formData, body)
  let scheme = call_598398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598398.url(scheme.get, call_598398.host, call_598398.base,
                         call_598398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598398, url, valid)

proc call*(call_598399: Call_AppengineAppsLocationsList_598380; appsId: string;
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
  var path_598400 = newJObject()
  var query_598401 = newJObject()
  add(query_598401, "upload_protocol", newJString(uploadProtocol))
  add(query_598401, "fields", newJString(fields))
  add(query_598401, "pageToken", newJString(pageToken))
  add(query_598401, "quotaUser", newJString(quotaUser))
  add(query_598401, "alt", newJString(alt))
  add(query_598401, "oauth_token", newJString(oauthToken))
  add(query_598401, "callback", newJString(callback))
  add(query_598401, "access_token", newJString(accessToken))
  add(query_598401, "uploadType", newJString(uploadType))
  add(query_598401, "key", newJString(key))
  add(path_598400, "appsId", newJString(appsId))
  add(query_598401, "$.xgafv", newJString(Xgafv))
  add(query_598401, "pageSize", newJInt(pageSize))
  add(query_598401, "prettyPrint", newJBool(prettyPrint))
  add(query_598401, "filter", newJString(filter))
  result = call_598399.call(path_598400, query_598401, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_598380(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_598381, base: "/",
    url: url_AppengineAppsLocationsList_598382, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_598402 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsLocationsGet_598404(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsLocationsGet_598403(path: JsonNode; query: JsonNode;
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
  var valid_598405 = path.getOrDefault("appsId")
  valid_598405 = validateParameter(valid_598405, JString, required = true,
                                 default = nil)
  if valid_598405 != nil:
    section.add "appsId", valid_598405
  var valid_598406 = path.getOrDefault("locationsId")
  valid_598406 = validateParameter(valid_598406, JString, required = true,
                                 default = nil)
  if valid_598406 != nil:
    section.add "locationsId", valid_598406
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
  var valid_598407 = query.getOrDefault("upload_protocol")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "upload_protocol", valid_598407
  var valid_598408 = query.getOrDefault("fields")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "fields", valid_598408
  var valid_598409 = query.getOrDefault("quotaUser")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "quotaUser", valid_598409
  var valid_598410 = query.getOrDefault("alt")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = newJString("json"))
  if valid_598410 != nil:
    section.add "alt", valid_598410
  var valid_598411 = query.getOrDefault("oauth_token")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "oauth_token", valid_598411
  var valid_598412 = query.getOrDefault("callback")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "callback", valid_598412
  var valid_598413 = query.getOrDefault("access_token")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "access_token", valid_598413
  var valid_598414 = query.getOrDefault("uploadType")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "uploadType", valid_598414
  var valid_598415 = query.getOrDefault("key")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = nil)
  if valid_598415 != nil:
    section.add "key", valid_598415
  var valid_598416 = query.getOrDefault("$.xgafv")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = newJString("1"))
  if valid_598416 != nil:
    section.add "$.xgafv", valid_598416
  var valid_598417 = query.getOrDefault("prettyPrint")
  valid_598417 = validateParameter(valid_598417, JBool, required = false,
                                 default = newJBool(true))
  if valid_598417 != nil:
    section.add "prettyPrint", valid_598417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598418: Call_AppengineAppsLocationsGet_598402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_598418.validator(path, query, header, formData, body)
  let scheme = call_598418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598418.url(scheme.get, call_598418.host, call_598418.base,
                         call_598418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598418, url, valid)

proc call*(call_598419: Call_AppengineAppsLocationsGet_598402; appsId: string;
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
  var path_598420 = newJObject()
  var query_598421 = newJObject()
  add(query_598421, "upload_protocol", newJString(uploadProtocol))
  add(query_598421, "fields", newJString(fields))
  add(query_598421, "quotaUser", newJString(quotaUser))
  add(query_598421, "alt", newJString(alt))
  add(query_598421, "oauth_token", newJString(oauthToken))
  add(query_598421, "callback", newJString(callback))
  add(query_598421, "access_token", newJString(accessToken))
  add(query_598421, "uploadType", newJString(uploadType))
  add(query_598421, "key", newJString(key))
  add(path_598420, "appsId", newJString(appsId))
  add(query_598421, "$.xgafv", newJString(Xgafv))
  add(query_598421, "prettyPrint", newJBool(prettyPrint))
  add(path_598420, "locationsId", newJString(locationsId))
  result = call_598419.call(path_598420, query_598421, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_598402(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_598403, base: "/",
    url: url_AppengineAppsLocationsGet_598404, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_598422 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsList_598424(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsList_598423(path: JsonNode; query: JsonNode;
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
  var valid_598425 = path.getOrDefault("appsId")
  valid_598425 = validateParameter(valid_598425, JString, required = true,
                                 default = nil)
  if valid_598425 != nil:
    section.add "appsId", valid_598425
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
  var valid_598426 = query.getOrDefault("upload_protocol")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = nil)
  if valid_598426 != nil:
    section.add "upload_protocol", valid_598426
  var valid_598427 = query.getOrDefault("fields")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "fields", valid_598427
  var valid_598428 = query.getOrDefault("pageToken")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "pageToken", valid_598428
  var valid_598429 = query.getOrDefault("quotaUser")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "quotaUser", valid_598429
  var valid_598430 = query.getOrDefault("alt")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = newJString("json"))
  if valid_598430 != nil:
    section.add "alt", valid_598430
  var valid_598431 = query.getOrDefault("oauth_token")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "oauth_token", valid_598431
  var valid_598432 = query.getOrDefault("callback")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "callback", valid_598432
  var valid_598433 = query.getOrDefault("access_token")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = nil)
  if valid_598433 != nil:
    section.add "access_token", valid_598433
  var valid_598434 = query.getOrDefault("uploadType")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "uploadType", valid_598434
  var valid_598435 = query.getOrDefault("key")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "key", valid_598435
  var valid_598436 = query.getOrDefault("$.xgafv")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = newJString("1"))
  if valid_598436 != nil:
    section.add "$.xgafv", valid_598436
  var valid_598437 = query.getOrDefault("pageSize")
  valid_598437 = validateParameter(valid_598437, JInt, required = false, default = nil)
  if valid_598437 != nil:
    section.add "pageSize", valid_598437
  var valid_598438 = query.getOrDefault("prettyPrint")
  valid_598438 = validateParameter(valid_598438, JBool, required = false,
                                 default = newJBool(true))
  if valid_598438 != nil:
    section.add "prettyPrint", valid_598438
  var valid_598439 = query.getOrDefault("filter")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = nil)
  if valid_598439 != nil:
    section.add "filter", valid_598439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598440: Call_AppengineAppsOperationsList_598422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_598440.validator(path, query, header, formData, body)
  let scheme = call_598440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598440.url(scheme.get, call_598440.host, call_598440.base,
                         call_598440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598440, url, valid)

proc call*(call_598441: Call_AppengineAppsOperationsList_598422; appsId: string;
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
  var path_598442 = newJObject()
  var query_598443 = newJObject()
  add(query_598443, "upload_protocol", newJString(uploadProtocol))
  add(query_598443, "fields", newJString(fields))
  add(query_598443, "pageToken", newJString(pageToken))
  add(query_598443, "quotaUser", newJString(quotaUser))
  add(query_598443, "alt", newJString(alt))
  add(query_598443, "oauth_token", newJString(oauthToken))
  add(query_598443, "callback", newJString(callback))
  add(query_598443, "access_token", newJString(accessToken))
  add(query_598443, "uploadType", newJString(uploadType))
  add(query_598443, "key", newJString(key))
  add(path_598442, "appsId", newJString(appsId))
  add(query_598443, "$.xgafv", newJString(Xgafv))
  add(query_598443, "pageSize", newJInt(pageSize))
  add(query_598443, "prettyPrint", newJBool(prettyPrint))
  add(query_598443, "filter", newJString(filter))
  result = call_598441.call(path_598442, query_598443, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_598422(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_598423, base: "/",
    url: url_AppengineAppsOperationsList_598424, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_598444 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsGet_598446(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsGet_598445(path: JsonNode; query: JsonNode;
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
  var valid_598447 = path.getOrDefault("appsId")
  valid_598447 = validateParameter(valid_598447, JString, required = true,
                                 default = nil)
  if valid_598447 != nil:
    section.add "appsId", valid_598447
  var valid_598448 = path.getOrDefault("operationsId")
  valid_598448 = validateParameter(valid_598448, JString, required = true,
                                 default = nil)
  if valid_598448 != nil:
    section.add "operationsId", valid_598448
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
  var valid_598449 = query.getOrDefault("upload_protocol")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "upload_protocol", valid_598449
  var valid_598450 = query.getOrDefault("fields")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "fields", valid_598450
  var valid_598451 = query.getOrDefault("quotaUser")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "quotaUser", valid_598451
  var valid_598452 = query.getOrDefault("alt")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = newJString("json"))
  if valid_598452 != nil:
    section.add "alt", valid_598452
  var valid_598453 = query.getOrDefault("oauth_token")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "oauth_token", valid_598453
  var valid_598454 = query.getOrDefault("callback")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "callback", valid_598454
  var valid_598455 = query.getOrDefault("access_token")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "access_token", valid_598455
  var valid_598456 = query.getOrDefault("uploadType")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = nil)
  if valid_598456 != nil:
    section.add "uploadType", valid_598456
  var valid_598457 = query.getOrDefault("key")
  valid_598457 = validateParameter(valid_598457, JString, required = false,
                                 default = nil)
  if valid_598457 != nil:
    section.add "key", valid_598457
  var valid_598458 = query.getOrDefault("$.xgafv")
  valid_598458 = validateParameter(valid_598458, JString, required = false,
                                 default = newJString("1"))
  if valid_598458 != nil:
    section.add "$.xgafv", valid_598458
  var valid_598459 = query.getOrDefault("prettyPrint")
  valid_598459 = validateParameter(valid_598459, JBool, required = false,
                                 default = newJBool(true))
  if valid_598459 != nil:
    section.add "prettyPrint", valid_598459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598460: Call_AppengineAppsOperationsGet_598444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_598460.validator(path, query, header, formData, body)
  let scheme = call_598460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598460.url(scheme.get, call_598460.host, call_598460.base,
                         call_598460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598460, url, valid)

proc call*(call_598461: Call_AppengineAppsOperationsGet_598444; appsId: string;
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
  var path_598462 = newJObject()
  var query_598463 = newJObject()
  add(query_598463, "upload_protocol", newJString(uploadProtocol))
  add(query_598463, "fields", newJString(fields))
  add(query_598463, "quotaUser", newJString(quotaUser))
  add(query_598463, "alt", newJString(alt))
  add(query_598463, "oauth_token", newJString(oauthToken))
  add(query_598463, "callback", newJString(callback))
  add(query_598463, "access_token", newJString(accessToken))
  add(query_598463, "uploadType", newJString(uploadType))
  add(query_598463, "key", newJString(key))
  add(path_598462, "appsId", newJString(appsId))
  add(query_598463, "$.xgafv", newJString(Xgafv))
  add(path_598462, "operationsId", newJString(operationsId))
  add(query_598463, "prettyPrint", newJBool(prettyPrint))
  result = call_598461.call(path_598462, query_598463, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_598444(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_598445, base: "/",
    url: url_AppengineAppsOperationsGet_598446, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_598464 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesList_598466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesList_598465(path: JsonNode; query: JsonNode;
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
  var valid_598467 = path.getOrDefault("appsId")
  valid_598467 = validateParameter(valid_598467, JString, required = true,
                                 default = nil)
  if valid_598467 != nil:
    section.add "appsId", valid_598467
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
  var valid_598468 = query.getOrDefault("upload_protocol")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = nil)
  if valid_598468 != nil:
    section.add "upload_protocol", valid_598468
  var valid_598469 = query.getOrDefault("fields")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "fields", valid_598469
  var valid_598470 = query.getOrDefault("pageToken")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "pageToken", valid_598470
  var valid_598471 = query.getOrDefault("quotaUser")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "quotaUser", valid_598471
  var valid_598472 = query.getOrDefault("alt")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = newJString("json"))
  if valid_598472 != nil:
    section.add "alt", valid_598472
  var valid_598473 = query.getOrDefault("oauth_token")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "oauth_token", valid_598473
  var valid_598474 = query.getOrDefault("callback")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "callback", valid_598474
  var valid_598475 = query.getOrDefault("access_token")
  valid_598475 = validateParameter(valid_598475, JString, required = false,
                                 default = nil)
  if valid_598475 != nil:
    section.add "access_token", valid_598475
  var valid_598476 = query.getOrDefault("uploadType")
  valid_598476 = validateParameter(valid_598476, JString, required = false,
                                 default = nil)
  if valid_598476 != nil:
    section.add "uploadType", valid_598476
  var valid_598477 = query.getOrDefault("key")
  valid_598477 = validateParameter(valid_598477, JString, required = false,
                                 default = nil)
  if valid_598477 != nil:
    section.add "key", valid_598477
  var valid_598478 = query.getOrDefault("$.xgafv")
  valid_598478 = validateParameter(valid_598478, JString, required = false,
                                 default = newJString("1"))
  if valid_598478 != nil:
    section.add "$.xgafv", valid_598478
  var valid_598479 = query.getOrDefault("pageSize")
  valid_598479 = validateParameter(valid_598479, JInt, required = false, default = nil)
  if valid_598479 != nil:
    section.add "pageSize", valid_598479
  var valid_598480 = query.getOrDefault("prettyPrint")
  valid_598480 = validateParameter(valid_598480, JBool, required = false,
                                 default = newJBool(true))
  if valid_598480 != nil:
    section.add "prettyPrint", valid_598480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598481: Call_AppengineAppsServicesList_598464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_598481.validator(path, query, header, formData, body)
  let scheme = call_598481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598481.url(scheme.get, call_598481.host, call_598481.base,
                         call_598481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598481, url, valid)

proc call*(call_598482: Call_AppengineAppsServicesList_598464; appsId: string;
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
  var path_598483 = newJObject()
  var query_598484 = newJObject()
  add(query_598484, "upload_protocol", newJString(uploadProtocol))
  add(query_598484, "fields", newJString(fields))
  add(query_598484, "pageToken", newJString(pageToken))
  add(query_598484, "quotaUser", newJString(quotaUser))
  add(query_598484, "alt", newJString(alt))
  add(query_598484, "oauth_token", newJString(oauthToken))
  add(query_598484, "callback", newJString(callback))
  add(query_598484, "access_token", newJString(accessToken))
  add(query_598484, "uploadType", newJString(uploadType))
  add(query_598484, "key", newJString(key))
  add(path_598483, "appsId", newJString(appsId))
  add(query_598484, "$.xgafv", newJString(Xgafv))
  add(query_598484, "pageSize", newJInt(pageSize))
  add(query_598484, "prettyPrint", newJBool(prettyPrint))
  result = call_598482.call(path_598483, query_598484, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_598464(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_598465, base: "/",
    url: url_AppengineAppsServicesList_598466, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_598485 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesGet_598487(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesGet_598486(path: JsonNode; query: JsonNode;
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
  var valid_598488 = path.getOrDefault("servicesId")
  valid_598488 = validateParameter(valid_598488, JString, required = true,
                                 default = nil)
  if valid_598488 != nil:
    section.add "servicesId", valid_598488
  var valid_598489 = path.getOrDefault("appsId")
  valid_598489 = validateParameter(valid_598489, JString, required = true,
                                 default = nil)
  if valid_598489 != nil:
    section.add "appsId", valid_598489
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
  var valid_598490 = query.getOrDefault("upload_protocol")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "upload_protocol", valid_598490
  var valid_598491 = query.getOrDefault("fields")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "fields", valid_598491
  var valid_598492 = query.getOrDefault("quotaUser")
  valid_598492 = validateParameter(valid_598492, JString, required = false,
                                 default = nil)
  if valid_598492 != nil:
    section.add "quotaUser", valid_598492
  var valid_598493 = query.getOrDefault("alt")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = newJString("json"))
  if valid_598493 != nil:
    section.add "alt", valid_598493
  var valid_598494 = query.getOrDefault("oauth_token")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "oauth_token", valid_598494
  var valid_598495 = query.getOrDefault("callback")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "callback", valid_598495
  var valid_598496 = query.getOrDefault("access_token")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = nil)
  if valid_598496 != nil:
    section.add "access_token", valid_598496
  var valid_598497 = query.getOrDefault("uploadType")
  valid_598497 = validateParameter(valid_598497, JString, required = false,
                                 default = nil)
  if valid_598497 != nil:
    section.add "uploadType", valid_598497
  var valid_598498 = query.getOrDefault("key")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "key", valid_598498
  var valid_598499 = query.getOrDefault("$.xgafv")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = newJString("1"))
  if valid_598499 != nil:
    section.add "$.xgafv", valid_598499
  var valid_598500 = query.getOrDefault("prettyPrint")
  valid_598500 = validateParameter(valid_598500, JBool, required = false,
                                 default = newJBool(true))
  if valid_598500 != nil:
    section.add "prettyPrint", valid_598500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598501: Call_AppengineAppsServicesGet_598485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_598501.validator(path, query, header, formData, body)
  let scheme = call_598501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598501.url(scheme.get, call_598501.host, call_598501.base,
                         call_598501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598501, url, valid)

proc call*(call_598502: Call_AppengineAppsServicesGet_598485; servicesId: string;
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
  var path_598503 = newJObject()
  var query_598504 = newJObject()
  add(query_598504, "upload_protocol", newJString(uploadProtocol))
  add(query_598504, "fields", newJString(fields))
  add(query_598504, "quotaUser", newJString(quotaUser))
  add(query_598504, "alt", newJString(alt))
  add(query_598504, "oauth_token", newJString(oauthToken))
  add(query_598504, "callback", newJString(callback))
  add(query_598504, "access_token", newJString(accessToken))
  add(query_598504, "uploadType", newJString(uploadType))
  add(path_598503, "servicesId", newJString(servicesId))
  add(query_598504, "key", newJString(key))
  add(path_598503, "appsId", newJString(appsId))
  add(query_598504, "$.xgafv", newJString(Xgafv))
  add(query_598504, "prettyPrint", newJBool(prettyPrint))
  result = call_598502.call(path_598503, query_598504, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_598485(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_598486, base: "/",
    url: url_AppengineAppsServicesGet_598487, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_598525 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesPatch_598527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesPatch_598526(path: JsonNode; query: JsonNode;
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
  var valid_598528 = path.getOrDefault("servicesId")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "servicesId", valid_598528
  var valid_598529 = path.getOrDefault("appsId")
  valid_598529 = validateParameter(valid_598529, JString, required = true,
                                 default = nil)
  if valid_598529 != nil:
    section.add "appsId", valid_598529
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
  var valid_598530 = query.getOrDefault("upload_protocol")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "upload_protocol", valid_598530
  var valid_598531 = query.getOrDefault("fields")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "fields", valid_598531
  var valid_598532 = query.getOrDefault("quotaUser")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "quotaUser", valid_598532
  var valid_598533 = query.getOrDefault("alt")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = newJString("json"))
  if valid_598533 != nil:
    section.add "alt", valid_598533
  var valid_598534 = query.getOrDefault("oauth_token")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "oauth_token", valid_598534
  var valid_598535 = query.getOrDefault("callback")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "callback", valid_598535
  var valid_598536 = query.getOrDefault("access_token")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "access_token", valid_598536
  var valid_598537 = query.getOrDefault("uploadType")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = nil)
  if valid_598537 != nil:
    section.add "uploadType", valid_598537
  var valid_598538 = query.getOrDefault("key")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "key", valid_598538
  var valid_598539 = query.getOrDefault("$.xgafv")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = newJString("1"))
  if valid_598539 != nil:
    section.add "$.xgafv", valid_598539
  var valid_598540 = query.getOrDefault("prettyPrint")
  valid_598540 = validateParameter(valid_598540, JBool, required = false,
                                 default = newJBool(true))
  if valid_598540 != nil:
    section.add "prettyPrint", valid_598540
  var valid_598541 = query.getOrDefault("updateMask")
  valid_598541 = validateParameter(valid_598541, JString, required = false,
                                 default = nil)
  if valid_598541 != nil:
    section.add "updateMask", valid_598541
  var valid_598542 = query.getOrDefault("migrateTraffic")
  valid_598542 = validateParameter(valid_598542, JBool, required = false, default = nil)
  if valid_598542 != nil:
    section.add "migrateTraffic", valid_598542
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

proc call*(call_598544: Call_AppengineAppsServicesPatch_598525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_598544.validator(path, query, header, formData, body)
  let scheme = call_598544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598544.url(scheme.get, call_598544.host, call_598544.base,
                         call_598544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598544, url, valid)

proc call*(call_598545: Call_AppengineAppsServicesPatch_598525; servicesId: string;
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
  var path_598546 = newJObject()
  var query_598547 = newJObject()
  var body_598548 = newJObject()
  add(query_598547, "upload_protocol", newJString(uploadProtocol))
  add(query_598547, "fields", newJString(fields))
  add(query_598547, "quotaUser", newJString(quotaUser))
  add(query_598547, "alt", newJString(alt))
  add(query_598547, "oauth_token", newJString(oauthToken))
  add(query_598547, "callback", newJString(callback))
  add(query_598547, "access_token", newJString(accessToken))
  add(query_598547, "uploadType", newJString(uploadType))
  add(path_598546, "servicesId", newJString(servicesId))
  add(query_598547, "key", newJString(key))
  add(path_598546, "appsId", newJString(appsId))
  add(query_598547, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598548 = body
  add(query_598547, "prettyPrint", newJBool(prettyPrint))
  add(query_598547, "updateMask", newJString(updateMask))
  add(query_598547, "migrateTraffic", newJBool(migrateTraffic))
  result = call_598545.call(path_598546, query_598547, nil, nil, body_598548)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_598525(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_598526, base: "/",
    url: url_AppengineAppsServicesPatch_598527, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_598505 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesDelete_598507(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesDelete_598506(path: JsonNode; query: JsonNode;
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
  var valid_598508 = path.getOrDefault("servicesId")
  valid_598508 = validateParameter(valid_598508, JString, required = true,
                                 default = nil)
  if valid_598508 != nil:
    section.add "servicesId", valid_598508
  var valid_598509 = path.getOrDefault("appsId")
  valid_598509 = validateParameter(valid_598509, JString, required = true,
                                 default = nil)
  if valid_598509 != nil:
    section.add "appsId", valid_598509
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
  var valid_598510 = query.getOrDefault("upload_protocol")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "upload_protocol", valid_598510
  var valid_598511 = query.getOrDefault("fields")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "fields", valid_598511
  var valid_598512 = query.getOrDefault("quotaUser")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "quotaUser", valid_598512
  var valid_598513 = query.getOrDefault("alt")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = newJString("json"))
  if valid_598513 != nil:
    section.add "alt", valid_598513
  var valid_598514 = query.getOrDefault("oauth_token")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "oauth_token", valid_598514
  var valid_598515 = query.getOrDefault("callback")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "callback", valid_598515
  var valid_598516 = query.getOrDefault("access_token")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "access_token", valid_598516
  var valid_598517 = query.getOrDefault("uploadType")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = nil)
  if valid_598517 != nil:
    section.add "uploadType", valid_598517
  var valid_598518 = query.getOrDefault("key")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = nil)
  if valid_598518 != nil:
    section.add "key", valid_598518
  var valid_598519 = query.getOrDefault("$.xgafv")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = newJString("1"))
  if valid_598519 != nil:
    section.add "$.xgafv", valid_598519
  var valid_598520 = query.getOrDefault("prettyPrint")
  valid_598520 = validateParameter(valid_598520, JBool, required = false,
                                 default = newJBool(true))
  if valid_598520 != nil:
    section.add "prettyPrint", valid_598520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598521: Call_AppengineAppsServicesDelete_598505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_598521.validator(path, query, header, formData, body)
  let scheme = call_598521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598521.url(scheme.get, call_598521.host, call_598521.base,
                         call_598521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598521, url, valid)

proc call*(call_598522: Call_AppengineAppsServicesDelete_598505;
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
  var path_598523 = newJObject()
  var query_598524 = newJObject()
  add(query_598524, "upload_protocol", newJString(uploadProtocol))
  add(query_598524, "fields", newJString(fields))
  add(query_598524, "quotaUser", newJString(quotaUser))
  add(query_598524, "alt", newJString(alt))
  add(query_598524, "oauth_token", newJString(oauthToken))
  add(query_598524, "callback", newJString(callback))
  add(query_598524, "access_token", newJString(accessToken))
  add(query_598524, "uploadType", newJString(uploadType))
  add(path_598523, "servicesId", newJString(servicesId))
  add(query_598524, "key", newJString(key))
  add(path_598523, "appsId", newJString(appsId))
  add(query_598524, "$.xgafv", newJString(Xgafv))
  add(query_598524, "prettyPrint", newJBool(prettyPrint))
  result = call_598522.call(path_598523, query_598524, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_598505(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_598506, base: "/",
    url: url_AppengineAppsServicesDelete_598507, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_598572 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsCreate_598574(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsCreate_598573(path: JsonNode;
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
  var valid_598575 = path.getOrDefault("servicesId")
  valid_598575 = validateParameter(valid_598575, JString, required = true,
                                 default = nil)
  if valid_598575 != nil:
    section.add "servicesId", valid_598575
  var valid_598576 = path.getOrDefault("appsId")
  valid_598576 = validateParameter(valid_598576, JString, required = true,
                                 default = nil)
  if valid_598576 != nil:
    section.add "appsId", valid_598576
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
  var valid_598577 = query.getOrDefault("upload_protocol")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "upload_protocol", valid_598577
  var valid_598578 = query.getOrDefault("fields")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "fields", valid_598578
  var valid_598579 = query.getOrDefault("quotaUser")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "quotaUser", valid_598579
  var valid_598580 = query.getOrDefault("alt")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = newJString("json"))
  if valid_598580 != nil:
    section.add "alt", valid_598580
  var valid_598581 = query.getOrDefault("oauth_token")
  valid_598581 = validateParameter(valid_598581, JString, required = false,
                                 default = nil)
  if valid_598581 != nil:
    section.add "oauth_token", valid_598581
  var valid_598582 = query.getOrDefault("callback")
  valid_598582 = validateParameter(valid_598582, JString, required = false,
                                 default = nil)
  if valid_598582 != nil:
    section.add "callback", valid_598582
  var valid_598583 = query.getOrDefault("access_token")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "access_token", valid_598583
  var valid_598584 = query.getOrDefault("uploadType")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = nil)
  if valid_598584 != nil:
    section.add "uploadType", valid_598584
  var valid_598585 = query.getOrDefault("key")
  valid_598585 = validateParameter(valid_598585, JString, required = false,
                                 default = nil)
  if valid_598585 != nil:
    section.add "key", valid_598585
  var valid_598586 = query.getOrDefault("$.xgafv")
  valid_598586 = validateParameter(valid_598586, JString, required = false,
                                 default = newJString("1"))
  if valid_598586 != nil:
    section.add "$.xgafv", valid_598586
  var valid_598587 = query.getOrDefault("prettyPrint")
  valid_598587 = validateParameter(valid_598587, JBool, required = false,
                                 default = newJBool(true))
  if valid_598587 != nil:
    section.add "prettyPrint", valid_598587
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

proc call*(call_598589: Call_AppengineAppsServicesVersionsCreate_598572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_598589.validator(path, query, header, formData, body)
  let scheme = call_598589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598589.url(scheme.get, call_598589.host, call_598589.base,
                         call_598589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598589, url, valid)

proc call*(call_598590: Call_AppengineAppsServicesVersionsCreate_598572;
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
  var path_598591 = newJObject()
  var query_598592 = newJObject()
  var body_598593 = newJObject()
  add(query_598592, "upload_protocol", newJString(uploadProtocol))
  add(query_598592, "fields", newJString(fields))
  add(query_598592, "quotaUser", newJString(quotaUser))
  add(query_598592, "alt", newJString(alt))
  add(query_598592, "oauth_token", newJString(oauthToken))
  add(query_598592, "callback", newJString(callback))
  add(query_598592, "access_token", newJString(accessToken))
  add(query_598592, "uploadType", newJString(uploadType))
  add(path_598591, "servicesId", newJString(servicesId))
  add(query_598592, "key", newJString(key))
  add(path_598591, "appsId", newJString(appsId))
  add(query_598592, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598593 = body
  add(query_598592, "prettyPrint", newJBool(prettyPrint))
  result = call_598590.call(path_598591, query_598592, nil, nil, body_598593)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_598572(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_598573, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_598574, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_598549 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsList_598551(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsList_598550(path: JsonNode;
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
  var valid_598552 = path.getOrDefault("servicesId")
  valid_598552 = validateParameter(valid_598552, JString, required = true,
                                 default = nil)
  if valid_598552 != nil:
    section.add "servicesId", valid_598552
  var valid_598553 = path.getOrDefault("appsId")
  valid_598553 = validateParameter(valid_598553, JString, required = true,
                                 default = nil)
  if valid_598553 != nil:
    section.add "appsId", valid_598553
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
  var valid_598554 = query.getOrDefault("upload_protocol")
  valid_598554 = validateParameter(valid_598554, JString, required = false,
                                 default = nil)
  if valid_598554 != nil:
    section.add "upload_protocol", valid_598554
  var valid_598555 = query.getOrDefault("fields")
  valid_598555 = validateParameter(valid_598555, JString, required = false,
                                 default = nil)
  if valid_598555 != nil:
    section.add "fields", valid_598555
  var valid_598556 = query.getOrDefault("pageToken")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "pageToken", valid_598556
  var valid_598557 = query.getOrDefault("quotaUser")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "quotaUser", valid_598557
  var valid_598558 = query.getOrDefault("view")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598558 != nil:
    section.add "view", valid_598558
  var valid_598559 = query.getOrDefault("alt")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = newJString("json"))
  if valid_598559 != nil:
    section.add "alt", valid_598559
  var valid_598560 = query.getOrDefault("oauth_token")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = nil)
  if valid_598560 != nil:
    section.add "oauth_token", valid_598560
  var valid_598561 = query.getOrDefault("callback")
  valid_598561 = validateParameter(valid_598561, JString, required = false,
                                 default = nil)
  if valid_598561 != nil:
    section.add "callback", valid_598561
  var valid_598562 = query.getOrDefault("access_token")
  valid_598562 = validateParameter(valid_598562, JString, required = false,
                                 default = nil)
  if valid_598562 != nil:
    section.add "access_token", valid_598562
  var valid_598563 = query.getOrDefault("uploadType")
  valid_598563 = validateParameter(valid_598563, JString, required = false,
                                 default = nil)
  if valid_598563 != nil:
    section.add "uploadType", valid_598563
  var valid_598564 = query.getOrDefault("key")
  valid_598564 = validateParameter(valid_598564, JString, required = false,
                                 default = nil)
  if valid_598564 != nil:
    section.add "key", valid_598564
  var valid_598565 = query.getOrDefault("$.xgafv")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = newJString("1"))
  if valid_598565 != nil:
    section.add "$.xgafv", valid_598565
  var valid_598566 = query.getOrDefault("pageSize")
  valid_598566 = validateParameter(valid_598566, JInt, required = false, default = nil)
  if valid_598566 != nil:
    section.add "pageSize", valid_598566
  var valid_598567 = query.getOrDefault("prettyPrint")
  valid_598567 = validateParameter(valid_598567, JBool, required = false,
                                 default = newJBool(true))
  if valid_598567 != nil:
    section.add "prettyPrint", valid_598567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598568: Call_AppengineAppsServicesVersionsList_598549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_598568.validator(path, query, header, formData, body)
  let scheme = call_598568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598568.url(scheme.get, call_598568.host, call_598568.base,
                         call_598568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598568, url, valid)

proc call*(call_598569: Call_AppengineAppsServicesVersionsList_598549;
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
  var path_598570 = newJObject()
  var query_598571 = newJObject()
  add(query_598571, "upload_protocol", newJString(uploadProtocol))
  add(query_598571, "fields", newJString(fields))
  add(query_598571, "pageToken", newJString(pageToken))
  add(query_598571, "quotaUser", newJString(quotaUser))
  add(query_598571, "view", newJString(view))
  add(query_598571, "alt", newJString(alt))
  add(query_598571, "oauth_token", newJString(oauthToken))
  add(query_598571, "callback", newJString(callback))
  add(query_598571, "access_token", newJString(accessToken))
  add(query_598571, "uploadType", newJString(uploadType))
  add(path_598570, "servicesId", newJString(servicesId))
  add(query_598571, "key", newJString(key))
  add(path_598570, "appsId", newJString(appsId))
  add(query_598571, "$.xgafv", newJString(Xgafv))
  add(query_598571, "pageSize", newJInt(pageSize))
  add(query_598571, "prettyPrint", newJBool(prettyPrint))
  result = call_598569.call(path_598570, query_598571, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_598549(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_598550, base: "/",
    url: url_AppengineAppsServicesVersionsList_598551, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_598594 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsGet_598596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsGet_598595(path: JsonNode;
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
  var valid_598597 = path.getOrDefault("versionsId")
  valid_598597 = validateParameter(valid_598597, JString, required = true,
                                 default = nil)
  if valid_598597 != nil:
    section.add "versionsId", valid_598597
  var valid_598598 = path.getOrDefault("servicesId")
  valid_598598 = validateParameter(valid_598598, JString, required = true,
                                 default = nil)
  if valid_598598 != nil:
    section.add "servicesId", valid_598598
  var valid_598599 = path.getOrDefault("appsId")
  valid_598599 = validateParameter(valid_598599, JString, required = true,
                                 default = nil)
  if valid_598599 != nil:
    section.add "appsId", valid_598599
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
  var valid_598600 = query.getOrDefault("upload_protocol")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = nil)
  if valid_598600 != nil:
    section.add "upload_protocol", valid_598600
  var valid_598601 = query.getOrDefault("fields")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "fields", valid_598601
  var valid_598602 = query.getOrDefault("view")
  valid_598602 = validateParameter(valid_598602, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598602 != nil:
    section.add "view", valid_598602
  var valid_598603 = query.getOrDefault("quotaUser")
  valid_598603 = validateParameter(valid_598603, JString, required = false,
                                 default = nil)
  if valid_598603 != nil:
    section.add "quotaUser", valid_598603
  var valid_598604 = query.getOrDefault("alt")
  valid_598604 = validateParameter(valid_598604, JString, required = false,
                                 default = newJString("json"))
  if valid_598604 != nil:
    section.add "alt", valid_598604
  var valid_598605 = query.getOrDefault("oauth_token")
  valid_598605 = validateParameter(valid_598605, JString, required = false,
                                 default = nil)
  if valid_598605 != nil:
    section.add "oauth_token", valid_598605
  var valid_598606 = query.getOrDefault("callback")
  valid_598606 = validateParameter(valid_598606, JString, required = false,
                                 default = nil)
  if valid_598606 != nil:
    section.add "callback", valid_598606
  var valid_598607 = query.getOrDefault("access_token")
  valid_598607 = validateParameter(valid_598607, JString, required = false,
                                 default = nil)
  if valid_598607 != nil:
    section.add "access_token", valid_598607
  var valid_598608 = query.getOrDefault("uploadType")
  valid_598608 = validateParameter(valid_598608, JString, required = false,
                                 default = nil)
  if valid_598608 != nil:
    section.add "uploadType", valid_598608
  var valid_598609 = query.getOrDefault("key")
  valid_598609 = validateParameter(valid_598609, JString, required = false,
                                 default = nil)
  if valid_598609 != nil:
    section.add "key", valid_598609
  var valid_598610 = query.getOrDefault("$.xgafv")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = newJString("1"))
  if valid_598610 != nil:
    section.add "$.xgafv", valid_598610
  var valid_598611 = query.getOrDefault("prettyPrint")
  valid_598611 = validateParameter(valid_598611, JBool, required = false,
                                 default = newJBool(true))
  if valid_598611 != nil:
    section.add "prettyPrint", valid_598611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598612: Call_AppengineAppsServicesVersionsGet_598594;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_598612.validator(path, query, header, formData, body)
  let scheme = call_598612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598612.url(scheme.get, call_598612.host, call_598612.base,
                         call_598612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598612, url, valid)

proc call*(call_598613: Call_AppengineAppsServicesVersionsGet_598594;
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
  var path_598614 = newJObject()
  var query_598615 = newJObject()
  add(query_598615, "upload_protocol", newJString(uploadProtocol))
  add(query_598615, "fields", newJString(fields))
  add(query_598615, "view", newJString(view))
  add(query_598615, "quotaUser", newJString(quotaUser))
  add(path_598614, "versionsId", newJString(versionsId))
  add(query_598615, "alt", newJString(alt))
  add(query_598615, "oauth_token", newJString(oauthToken))
  add(query_598615, "callback", newJString(callback))
  add(query_598615, "access_token", newJString(accessToken))
  add(query_598615, "uploadType", newJString(uploadType))
  add(path_598614, "servicesId", newJString(servicesId))
  add(query_598615, "key", newJString(key))
  add(path_598614, "appsId", newJString(appsId))
  add(query_598615, "$.xgafv", newJString(Xgafv))
  add(query_598615, "prettyPrint", newJBool(prettyPrint))
  result = call_598613.call(path_598614, query_598615, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_598594(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_598595, base: "/",
    url: url_AppengineAppsServicesVersionsGet_598596, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_598637 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsPatch_598639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsPatch_598638(path: JsonNode;
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
  var valid_598640 = path.getOrDefault("versionsId")
  valid_598640 = validateParameter(valid_598640, JString, required = true,
                                 default = nil)
  if valid_598640 != nil:
    section.add "versionsId", valid_598640
  var valid_598641 = path.getOrDefault("servicesId")
  valid_598641 = validateParameter(valid_598641, JString, required = true,
                                 default = nil)
  if valid_598641 != nil:
    section.add "servicesId", valid_598641
  var valid_598642 = path.getOrDefault("appsId")
  valid_598642 = validateParameter(valid_598642, JString, required = true,
                                 default = nil)
  if valid_598642 != nil:
    section.add "appsId", valid_598642
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
  var valid_598643 = query.getOrDefault("upload_protocol")
  valid_598643 = validateParameter(valid_598643, JString, required = false,
                                 default = nil)
  if valid_598643 != nil:
    section.add "upload_protocol", valid_598643
  var valid_598644 = query.getOrDefault("fields")
  valid_598644 = validateParameter(valid_598644, JString, required = false,
                                 default = nil)
  if valid_598644 != nil:
    section.add "fields", valid_598644
  var valid_598645 = query.getOrDefault("quotaUser")
  valid_598645 = validateParameter(valid_598645, JString, required = false,
                                 default = nil)
  if valid_598645 != nil:
    section.add "quotaUser", valid_598645
  var valid_598646 = query.getOrDefault("alt")
  valid_598646 = validateParameter(valid_598646, JString, required = false,
                                 default = newJString("json"))
  if valid_598646 != nil:
    section.add "alt", valid_598646
  var valid_598647 = query.getOrDefault("oauth_token")
  valid_598647 = validateParameter(valid_598647, JString, required = false,
                                 default = nil)
  if valid_598647 != nil:
    section.add "oauth_token", valid_598647
  var valid_598648 = query.getOrDefault("callback")
  valid_598648 = validateParameter(valid_598648, JString, required = false,
                                 default = nil)
  if valid_598648 != nil:
    section.add "callback", valid_598648
  var valid_598649 = query.getOrDefault("access_token")
  valid_598649 = validateParameter(valid_598649, JString, required = false,
                                 default = nil)
  if valid_598649 != nil:
    section.add "access_token", valid_598649
  var valid_598650 = query.getOrDefault("uploadType")
  valid_598650 = validateParameter(valid_598650, JString, required = false,
                                 default = nil)
  if valid_598650 != nil:
    section.add "uploadType", valid_598650
  var valid_598651 = query.getOrDefault("key")
  valid_598651 = validateParameter(valid_598651, JString, required = false,
                                 default = nil)
  if valid_598651 != nil:
    section.add "key", valid_598651
  var valid_598652 = query.getOrDefault("$.xgafv")
  valid_598652 = validateParameter(valid_598652, JString, required = false,
                                 default = newJString("1"))
  if valid_598652 != nil:
    section.add "$.xgafv", valid_598652
  var valid_598653 = query.getOrDefault("prettyPrint")
  valid_598653 = validateParameter(valid_598653, JBool, required = false,
                                 default = newJBool(true))
  if valid_598653 != nil:
    section.add "prettyPrint", valid_598653
  var valid_598654 = query.getOrDefault("updateMask")
  valid_598654 = validateParameter(valid_598654, JString, required = false,
                                 default = nil)
  if valid_598654 != nil:
    section.add "updateMask", valid_598654
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

proc call*(call_598656: Call_AppengineAppsServicesVersionsPatch_598637;
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
  let valid = call_598656.validator(path, query, header, formData, body)
  let scheme = call_598656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598656.url(scheme.get, call_598656.host, call_598656.base,
                         call_598656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598656, url, valid)

proc call*(call_598657: Call_AppengineAppsServicesVersionsPatch_598637;
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
  var path_598658 = newJObject()
  var query_598659 = newJObject()
  var body_598660 = newJObject()
  add(query_598659, "upload_protocol", newJString(uploadProtocol))
  add(query_598659, "fields", newJString(fields))
  add(query_598659, "quotaUser", newJString(quotaUser))
  add(path_598658, "versionsId", newJString(versionsId))
  add(query_598659, "alt", newJString(alt))
  add(query_598659, "oauth_token", newJString(oauthToken))
  add(query_598659, "callback", newJString(callback))
  add(query_598659, "access_token", newJString(accessToken))
  add(query_598659, "uploadType", newJString(uploadType))
  add(path_598658, "servicesId", newJString(servicesId))
  add(query_598659, "key", newJString(key))
  add(path_598658, "appsId", newJString(appsId))
  add(query_598659, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598660 = body
  add(query_598659, "prettyPrint", newJBool(prettyPrint))
  add(query_598659, "updateMask", newJString(updateMask))
  result = call_598657.call(path_598658, query_598659, nil, nil, body_598660)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_598637(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_598638, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_598639, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_598616 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsDelete_598618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsDelete_598617(path: JsonNode;
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
  var valid_598619 = path.getOrDefault("versionsId")
  valid_598619 = validateParameter(valid_598619, JString, required = true,
                                 default = nil)
  if valid_598619 != nil:
    section.add "versionsId", valid_598619
  var valid_598620 = path.getOrDefault("servicesId")
  valid_598620 = validateParameter(valid_598620, JString, required = true,
                                 default = nil)
  if valid_598620 != nil:
    section.add "servicesId", valid_598620
  var valid_598621 = path.getOrDefault("appsId")
  valid_598621 = validateParameter(valid_598621, JString, required = true,
                                 default = nil)
  if valid_598621 != nil:
    section.add "appsId", valid_598621
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
  var valid_598622 = query.getOrDefault("upload_protocol")
  valid_598622 = validateParameter(valid_598622, JString, required = false,
                                 default = nil)
  if valid_598622 != nil:
    section.add "upload_protocol", valid_598622
  var valid_598623 = query.getOrDefault("fields")
  valid_598623 = validateParameter(valid_598623, JString, required = false,
                                 default = nil)
  if valid_598623 != nil:
    section.add "fields", valid_598623
  var valid_598624 = query.getOrDefault("quotaUser")
  valid_598624 = validateParameter(valid_598624, JString, required = false,
                                 default = nil)
  if valid_598624 != nil:
    section.add "quotaUser", valid_598624
  var valid_598625 = query.getOrDefault("alt")
  valid_598625 = validateParameter(valid_598625, JString, required = false,
                                 default = newJString("json"))
  if valid_598625 != nil:
    section.add "alt", valid_598625
  var valid_598626 = query.getOrDefault("oauth_token")
  valid_598626 = validateParameter(valid_598626, JString, required = false,
                                 default = nil)
  if valid_598626 != nil:
    section.add "oauth_token", valid_598626
  var valid_598627 = query.getOrDefault("callback")
  valid_598627 = validateParameter(valid_598627, JString, required = false,
                                 default = nil)
  if valid_598627 != nil:
    section.add "callback", valid_598627
  var valid_598628 = query.getOrDefault("access_token")
  valid_598628 = validateParameter(valid_598628, JString, required = false,
                                 default = nil)
  if valid_598628 != nil:
    section.add "access_token", valid_598628
  var valid_598629 = query.getOrDefault("uploadType")
  valid_598629 = validateParameter(valid_598629, JString, required = false,
                                 default = nil)
  if valid_598629 != nil:
    section.add "uploadType", valid_598629
  var valid_598630 = query.getOrDefault("key")
  valid_598630 = validateParameter(valid_598630, JString, required = false,
                                 default = nil)
  if valid_598630 != nil:
    section.add "key", valid_598630
  var valid_598631 = query.getOrDefault("$.xgafv")
  valid_598631 = validateParameter(valid_598631, JString, required = false,
                                 default = newJString("1"))
  if valid_598631 != nil:
    section.add "$.xgafv", valid_598631
  var valid_598632 = query.getOrDefault("prettyPrint")
  valid_598632 = validateParameter(valid_598632, JBool, required = false,
                                 default = newJBool(true))
  if valid_598632 != nil:
    section.add "prettyPrint", valid_598632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598633: Call_AppengineAppsServicesVersionsDelete_598616;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Version resource.
  ## 
  let valid = call_598633.validator(path, query, header, formData, body)
  let scheme = call_598633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598633.url(scheme.get, call_598633.host, call_598633.base,
                         call_598633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598633, url, valid)

proc call*(call_598634: Call_AppengineAppsServicesVersionsDelete_598616;
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
  var path_598635 = newJObject()
  var query_598636 = newJObject()
  add(query_598636, "upload_protocol", newJString(uploadProtocol))
  add(query_598636, "fields", newJString(fields))
  add(query_598636, "quotaUser", newJString(quotaUser))
  add(path_598635, "versionsId", newJString(versionsId))
  add(query_598636, "alt", newJString(alt))
  add(query_598636, "oauth_token", newJString(oauthToken))
  add(query_598636, "callback", newJString(callback))
  add(query_598636, "access_token", newJString(accessToken))
  add(query_598636, "uploadType", newJString(uploadType))
  add(path_598635, "servicesId", newJString(servicesId))
  add(query_598636, "key", newJString(key))
  add(path_598635, "appsId", newJString(appsId))
  add(query_598636, "$.xgafv", newJString(Xgafv))
  add(query_598636, "prettyPrint", newJBool(prettyPrint))
  result = call_598634.call(path_598635, query_598636, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_598616(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_598617, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_598618, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_598661 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesList_598663(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsInstancesList_598662(path: JsonNode;
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
  var valid_598664 = path.getOrDefault("versionsId")
  valid_598664 = validateParameter(valid_598664, JString, required = true,
                                 default = nil)
  if valid_598664 != nil:
    section.add "versionsId", valid_598664
  var valid_598665 = path.getOrDefault("servicesId")
  valid_598665 = validateParameter(valid_598665, JString, required = true,
                                 default = nil)
  if valid_598665 != nil:
    section.add "servicesId", valid_598665
  var valid_598666 = path.getOrDefault("appsId")
  valid_598666 = validateParameter(valid_598666, JString, required = true,
                                 default = nil)
  if valid_598666 != nil:
    section.add "appsId", valid_598666
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
  var valid_598667 = query.getOrDefault("upload_protocol")
  valid_598667 = validateParameter(valid_598667, JString, required = false,
                                 default = nil)
  if valid_598667 != nil:
    section.add "upload_protocol", valid_598667
  var valid_598668 = query.getOrDefault("fields")
  valid_598668 = validateParameter(valid_598668, JString, required = false,
                                 default = nil)
  if valid_598668 != nil:
    section.add "fields", valid_598668
  var valid_598669 = query.getOrDefault("pageToken")
  valid_598669 = validateParameter(valid_598669, JString, required = false,
                                 default = nil)
  if valid_598669 != nil:
    section.add "pageToken", valid_598669
  var valid_598670 = query.getOrDefault("quotaUser")
  valid_598670 = validateParameter(valid_598670, JString, required = false,
                                 default = nil)
  if valid_598670 != nil:
    section.add "quotaUser", valid_598670
  var valid_598671 = query.getOrDefault("alt")
  valid_598671 = validateParameter(valid_598671, JString, required = false,
                                 default = newJString("json"))
  if valid_598671 != nil:
    section.add "alt", valid_598671
  var valid_598672 = query.getOrDefault("oauth_token")
  valid_598672 = validateParameter(valid_598672, JString, required = false,
                                 default = nil)
  if valid_598672 != nil:
    section.add "oauth_token", valid_598672
  var valid_598673 = query.getOrDefault("callback")
  valid_598673 = validateParameter(valid_598673, JString, required = false,
                                 default = nil)
  if valid_598673 != nil:
    section.add "callback", valid_598673
  var valid_598674 = query.getOrDefault("access_token")
  valid_598674 = validateParameter(valid_598674, JString, required = false,
                                 default = nil)
  if valid_598674 != nil:
    section.add "access_token", valid_598674
  var valid_598675 = query.getOrDefault("uploadType")
  valid_598675 = validateParameter(valid_598675, JString, required = false,
                                 default = nil)
  if valid_598675 != nil:
    section.add "uploadType", valid_598675
  var valid_598676 = query.getOrDefault("key")
  valid_598676 = validateParameter(valid_598676, JString, required = false,
                                 default = nil)
  if valid_598676 != nil:
    section.add "key", valid_598676
  var valid_598677 = query.getOrDefault("$.xgafv")
  valid_598677 = validateParameter(valid_598677, JString, required = false,
                                 default = newJString("1"))
  if valid_598677 != nil:
    section.add "$.xgafv", valid_598677
  var valid_598678 = query.getOrDefault("pageSize")
  valid_598678 = validateParameter(valid_598678, JInt, required = false, default = nil)
  if valid_598678 != nil:
    section.add "pageSize", valid_598678
  var valid_598679 = query.getOrDefault("prettyPrint")
  valid_598679 = validateParameter(valid_598679, JBool, required = false,
                                 default = newJBool(true))
  if valid_598679 != nil:
    section.add "prettyPrint", valid_598679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598680: Call_AppengineAppsServicesVersionsInstancesList_598661;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_598680.validator(path, query, header, formData, body)
  let scheme = call_598680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598680.url(scheme.get, call_598680.host, call_598680.base,
                         call_598680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598680, url, valid)

proc call*(call_598681: Call_AppengineAppsServicesVersionsInstancesList_598661;
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
  var path_598682 = newJObject()
  var query_598683 = newJObject()
  add(query_598683, "upload_protocol", newJString(uploadProtocol))
  add(query_598683, "fields", newJString(fields))
  add(query_598683, "pageToken", newJString(pageToken))
  add(query_598683, "quotaUser", newJString(quotaUser))
  add(path_598682, "versionsId", newJString(versionsId))
  add(query_598683, "alt", newJString(alt))
  add(query_598683, "oauth_token", newJString(oauthToken))
  add(query_598683, "callback", newJString(callback))
  add(query_598683, "access_token", newJString(accessToken))
  add(query_598683, "uploadType", newJString(uploadType))
  add(path_598682, "servicesId", newJString(servicesId))
  add(query_598683, "key", newJString(key))
  add(path_598682, "appsId", newJString(appsId))
  add(query_598683, "$.xgafv", newJString(Xgafv))
  add(query_598683, "pageSize", newJInt(pageSize))
  add(query_598683, "prettyPrint", newJBool(prettyPrint))
  result = call_598681.call(path_598682, query_598683, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_598661(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_598662,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_598663,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_598684 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesGet_598686(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsInstancesGet_598685(path: JsonNode;
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
  var valid_598687 = path.getOrDefault("versionsId")
  valid_598687 = validateParameter(valid_598687, JString, required = true,
                                 default = nil)
  if valid_598687 != nil:
    section.add "versionsId", valid_598687
  var valid_598688 = path.getOrDefault("instancesId")
  valid_598688 = validateParameter(valid_598688, JString, required = true,
                                 default = nil)
  if valid_598688 != nil:
    section.add "instancesId", valid_598688
  var valid_598689 = path.getOrDefault("servicesId")
  valid_598689 = validateParameter(valid_598689, JString, required = true,
                                 default = nil)
  if valid_598689 != nil:
    section.add "servicesId", valid_598689
  var valid_598690 = path.getOrDefault("appsId")
  valid_598690 = validateParameter(valid_598690, JString, required = true,
                                 default = nil)
  if valid_598690 != nil:
    section.add "appsId", valid_598690
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
  var valid_598691 = query.getOrDefault("upload_protocol")
  valid_598691 = validateParameter(valid_598691, JString, required = false,
                                 default = nil)
  if valid_598691 != nil:
    section.add "upload_protocol", valid_598691
  var valid_598692 = query.getOrDefault("fields")
  valid_598692 = validateParameter(valid_598692, JString, required = false,
                                 default = nil)
  if valid_598692 != nil:
    section.add "fields", valid_598692
  var valid_598693 = query.getOrDefault("quotaUser")
  valid_598693 = validateParameter(valid_598693, JString, required = false,
                                 default = nil)
  if valid_598693 != nil:
    section.add "quotaUser", valid_598693
  var valid_598694 = query.getOrDefault("alt")
  valid_598694 = validateParameter(valid_598694, JString, required = false,
                                 default = newJString("json"))
  if valid_598694 != nil:
    section.add "alt", valid_598694
  var valid_598695 = query.getOrDefault("oauth_token")
  valid_598695 = validateParameter(valid_598695, JString, required = false,
                                 default = nil)
  if valid_598695 != nil:
    section.add "oauth_token", valid_598695
  var valid_598696 = query.getOrDefault("callback")
  valid_598696 = validateParameter(valid_598696, JString, required = false,
                                 default = nil)
  if valid_598696 != nil:
    section.add "callback", valid_598696
  var valid_598697 = query.getOrDefault("access_token")
  valid_598697 = validateParameter(valid_598697, JString, required = false,
                                 default = nil)
  if valid_598697 != nil:
    section.add "access_token", valid_598697
  var valid_598698 = query.getOrDefault("uploadType")
  valid_598698 = validateParameter(valid_598698, JString, required = false,
                                 default = nil)
  if valid_598698 != nil:
    section.add "uploadType", valid_598698
  var valid_598699 = query.getOrDefault("key")
  valid_598699 = validateParameter(valid_598699, JString, required = false,
                                 default = nil)
  if valid_598699 != nil:
    section.add "key", valid_598699
  var valid_598700 = query.getOrDefault("$.xgafv")
  valid_598700 = validateParameter(valid_598700, JString, required = false,
                                 default = newJString("1"))
  if valid_598700 != nil:
    section.add "$.xgafv", valid_598700
  var valid_598701 = query.getOrDefault("prettyPrint")
  valid_598701 = validateParameter(valid_598701, JBool, required = false,
                                 default = newJBool(true))
  if valid_598701 != nil:
    section.add "prettyPrint", valid_598701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598702: Call_AppengineAppsServicesVersionsInstancesGet_598684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_598702.validator(path, query, header, formData, body)
  let scheme = call_598702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598702.url(scheme.get, call_598702.host, call_598702.base,
                         call_598702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598702, url, valid)

proc call*(call_598703: Call_AppengineAppsServicesVersionsInstancesGet_598684;
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
  var path_598704 = newJObject()
  var query_598705 = newJObject()
  add(query_598705, "upload_protocol", newJString(uploadProtocol))
  add(query_598705, "fields", newJString(fields))
  add(query_598705, "quotaUser", newJString(quotaUser))
  add(path_598704, "versionsId", newJString(versionsId))
  add(query_598705, "alt", newJString(alt))
  add(path_598704, "instancesId", newJString(instancesId))
  add(query_598705, "oauth_token", newJString(oauthToken))
  add(query_598705, "callback", newJString(callback))
  add(query_598705, "access_token", newJString(accessToken))
  add(query_598705, "uploadType", newJString(uploadType))
  add(path_598704, "servicesId", newJString(servicesId))
  add(query_598705, "key", newJString(key))
  add(path_598704, "appsId", newJString(appsId))
  add(query_598705, "$.xgafv", newJString(Xgafv))
  add(query_598705, "prettyPrint", newJBool(prettyPrint))
  result = call_598703.call(path_598704, query_598705, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_598684(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_598685,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_598686,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_598706 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesDelete_598708(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsInstancesDelete_598707(path: JsonNode;
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
  var valid_598709 = path.getOrDefault("versionsId")
  valid_598709 = validateParameter(valid_598709, JString, required = true,
                                 default = nil)
  if valid_598709 != nil:
    section.add "versionsId", valid_598709
  var valid_598710 = path.getOrDefault("instancesId")
  valid_598710 = validateParameter(valid_598710, JString, required = true,
                                 default = nil)
  if valid_598710 != nil:
    section.add "instancesId", valid_598710
  var valid_598711 = path.getOrDefault("servicesId")
  valid_598711 = validateParameter(valid_598711, JString, required = true,
                                 default = nil)
  if valid_598711 != nil:
    section.add "servicesId", valid_598711
  var valid_598712 = path.getOrDefault("appsId")
  valid_598712 = validateParameter(valid_598712, JString, required = true,
                                 default = nil)
  if valid_598712 != nil:
    section.add "appsId", valid_598712
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
  var valid_598713 = query.getOrDefault("upload_protocol")
  valid_598713 = validateParameter(valid_598713, JString, required = false,
                                 default = nil)
  if valid_598713 != nil:
    section.add "upload_protocol", valid_598713
  var valid_598714 = query.getOrDefault("fields")
  valid_598714 = validateParameter(valid_598714, JString, required = false,
                                 default = nil)
  if valid_598714 != nil:
    section.add "fields", valid_598714
  var valid_598715 = query.getOrDefault("quotaUser")
  valid_598715 = validateParameter(valid_598715, JString, required = false,
                                 default = nil)
  if valid_598715 != nil:
    section.add "quotaUser", valid_598715
  var valid_598716 = query.getOrDefault("alt")
  valid_598716 = validateParameter(valid_598716, JString, required = false,
                                 default = newJString("json"))
  if valid_598716 != nil:
    section.add "alt", valid_598716
  var valid_598717 = query.getOrDefault("oauth_token")
  valid_598717 = validateParameter(valid_598717, JString, required = false,
                                 default = nil)
  if valid_598717 != nil:
    section.add "oauth_token", valid_598717
  var valid_598718 = query.getOrDefault("callback")
  valid_598718 = validateParameter(valid_598718, JString, required = false,
                                 default = nil)
  if valid_598718 != nil:
    section.add "callback", valid_598718
  var valid_598719 = query.getOrDefault("access_token")
  valid_598719 = validateParameter(valid_598719, JString, required = false,
                                 default = nil)
  if valid_598719 != nil:
    section.add "access_token", valid_598719
  var valid_598720 = query.getOrDefault("uploadType")
  valid_598720 = validateParameter(valid_598720, JString, required = false,
                                 default = nil)
  if valid_598720 != nil:
    section.add "uploadType", valid_598720
  var valid_598721 = query.getOrDefault("key")
  valid_598721 = validateParameter(valid_598721, JString, required = false,
                                 default = nil)
  if valid_598721 != nil:
    section.add "key", valid_598721
  var valid_598722 = query.getOrDefault("$.xgafv")
  valid_598722 = validateParameter(valid_598722, JString, required = false,
                                 default = newJString("1"))
  if valid_598722 != nil:
    section.add "$.xgafv", valid_598722
  var valid_598723 = query.getOrDefault("prettyPrint")
  valid_598723 = validateParameter(valid_598723, JBool, required = false,
                                 default = newJBool(true))
  if valid_598723 != nil:
    section.add "prettyPrint", valid_598723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598724: Call_AppengineAppsServicesVersionsInstancesDelete_598706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_598724.validator(path, query, header, formData, body)
  let scheme = call_598724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598724.url(scheme.get, call_598724.host, call_598724.base,
                         call_598724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598724, url, valid)

proc call*(call_598725: Call_AppengineAppsServicesVersionsInstancesDelete_598706;
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
  var path_598726 = newJObject()
  var query_598727 = newJObject()
  add(query_598727, "upload_protocol", newJString(uploadProtocol))
  add(query_598727, "fields", newJString(fields))
  add(query_598727, "quotaUser", newJString(quotaUser))
  add(path_598726, "versionsId", newJString(versionsId))
  add(query_598727, "alt", newJString(alt))
  add(path_598726, "instancesId", newJString(instancesId))
  add(query_598727, "oauth_token", newJString(oauthToken))
  add(query_598727, "callback", newJString(callback))
  add(query_598727, "access_token", newJString(accessToken))
  add(query_598727, "uploadType", newJString(uploadType))
  add(path_598726, "servicesId", newJString(servicesId))
  add(query_598727, "key", newJString(key))
  add(path_598726, "appsId", newJString(appsId))
  add(query_598727, "$.xgafv", newJString(Xgafv))
  add(query_598727, "prettyPrint", newJBool(prettyPrint))
  result = call_598725.call(path_598726, query_598727, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_598706(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_598707,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_598708,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_598728 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesDebug_598730(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsServicesVersionsInstancesDebug_598729(path: JsonNode;
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
  var valid_598731 = path.getOrDefault("versionsId")
  valid_598731 = validateParameter(valid_598731, JString, required = true,
                                 default = nil)
  if valid_598731 != nil:
    section.add "versionsId", valid_598731
  var valid_598732 = path.getOrDefault("instancesId")
  valid_598732 = validateParameter(valid_598732, JString, required = true,
                                 default = nil)
  if valid_598732 != nil:
    section.add "instancesId", valid_598732
  var valid_598733 = path.getOrDefault("servicesId")
  valid_598733 = validateParameter(valid_598733, JString, required = true,
                                 default = nil)
  if valid_598733 != nil:
    section.add "servicesId", valid_598733
  var valid_598734 = path.getOrDefault("appsId")
  valid_598734 = validateParameter(valid_598734, JString, required = true,
                                 default = nil)
  if valid_598734 != nil:
    section.add "appsId", valid_598734
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
  var valid_598735 = query.getOrDefault("upload_protocol")
  valid_598735 = validateParameter(valid_598735, JString, required = false,
                                 default = nil)
  if valid_598735 != nil:
    section.add "upload_protocol", valid_598735
  var valid_598736 = query.getOrDefault("fields")
  valid_598736 = validateParameter(valid_598736, JString, required = false,
                                 default = nil)
  if valid_598736 != nil:
    section.add "fields", valid_598736
  var valid_598737 = query.getOrDefault("quotaUser")
  valid_598737 = validateParameter(valid_598737, JString, required = false,
                                 default = nil)
  if valid_598737 != nil:
    section.add "quotaUser", valid_598737
  var valid_598738 = query.getOrDefault("alt")
  valid_598738 = validateParameter(valid_598738, JString, required = false,
                                 default = newJString("json"))
  if valid_598738 != nil:
    section.add "alt", valid_598738
  var valid_598739 = query.getOrDefault("oauth_token")
  valid_598739 = validateParameter(valid_598739, JString, required = false,
                                 default = nil)
  if valid_598739 != nil:
    section.add "oauth_token", valid_598739
  var valid_598740 = query.getOrDefault("callback")
  valid_598740 = validateParameter(valid_598740, JString, required = false,
                                 default = nil)
  if valid_598740 != nil:
    section.add "callback", valid_598740
  var valid_598741 = query.getOrDefault("access_token")
  valid_598741 = validateParameter(valid_598741, JString, required = false,
                                 default = nil)
  if valid_598741 != nil:
    section.add "access_token", valid_598741
  var valid_598742 = query.getOrDefault("uploadType")
  valid_598742 = validateParameter(valid_598742, JString, required = false,
                                 default = nil)
  if valid_598742 != nil:
    section.add "uploadType", valid_598742
  var valid_598743 = query.getOrDefault("key")
  valid_598743 = validateParameter(valid_598743, JString, required = false,
                                 default = nil)
  if valid_598743 != nil:
    section.add "key", valid_598743
  var valid_598744 = query.getOrDefault("$.xgafv")
  valid_598744 = validateParameter(valid_598744, JString, required = false,
                                 default = newJString("1"))
  if valid_598744 != nil:
    section.add "$.xgafv", valid_598744
  var valid_598745 = query.getOrDefault("prettyPrint")
  valid_598745 = validateParameter(valid_598745, JBool, required = false,
                                 default = newJBool(true))
  if valid_598745 != nil:
    section.add "prettyPrint", valid_598745
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

proc call*(call_598747: Call_AppengineAppsServicesVersionsInstancesDebug_598728;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_598747.validator(path, query, header, formData, body)
  let scheme = call_598747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598747.url(scheme.get, call_598747.host, call_598747.base,
                         call_598747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598747, url, valid)

proc call*(call_598748: Call_AppengineAppsServicesVersionsInstancesDebug_598728;
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
  var path_598749 = newJObject()
  var query_598750 = newJObject()
  var body_598751 = newJObject()
  add(query_598750, "upload_protocol", newJString(uploadProtocol))
  add(query_598750, "fields", newJString(fields))
  add(query_598750, "quotaUser", newJString(quotaUser))
  add(path_598749, "versionsId", newJString(versionsId))
  add(query_598750, "alt", newJString(alt))
  add(path_598749, "instancesId", newJString(instancesId))
  add(query_598750, "oauth_token", newJString(oauthToken))
  add(query_598750, "callback", newJString(callback))
  add(query_598750, "access_token", newJString(accessToken))
  add(query_598750, "uploadType", newJString(uploadType))
  add(path_598749, "servicesId", newJString(servicesId))
  add(query_598750, "key", newJString(key))
  add(path_598749, "appsId", newJString(appsId))
  add(query_598750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598751 = body
  add(query_598750, "prettyPrint", newJBool(prettyPrint))
  result = call_598748.call(path_598749, query_598750, nil, nil, body_598751)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_598728(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_598729,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_598730,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsRepair_598752 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsRepair_598754(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsRepair_598753(path: JsonNode; query: JsonNode;
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
  var valid_598755 = path.getOrDefault("appsId")
  valid_598755 = validateParameter(valid_598755, JString, required = true,
                                 default = nil)
  if valid_598755 != nil:
    section.add "appsId", valid_598755
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
  var valid_598756 = query.getOrDefault("upload_protocol")
  valid_598756 = validateParameter(valid_598756, JString, required = false,
                                 default = nil)
  if valid_598756 != nil:
    section.add "upload_protocol", valid_598756
  var valid_598757 = query.getOrDefault("fields")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = nil)
  if valid_598757 != nil:
    section.add "fields", valid_598757
  var valid_598758 = query.getOrDefault("quotaUser")
  valid_598758 = validateParameter(valid_598758, JString, required = false,
                                 default = nil)
  if valid_598758 != nil:
    section.add "quotaUser", valid_598758
  var valid_598759 = query.getOrDefault("alt")
  valid_598759 = validateParameter(valid_598759, JString, required = false,
                                 default = newJString("json"))
  if valid_598759 != nil:
    section.add "alt", valid_598759
  var valid_598760 = query.getOrDefault("oauth_token")
  valid_598760 = validateParameter(valid_598760, JString, required = false,
                                 default = nil)
  if valid_598760 != nil:
    section.add "oauth_token", valid_598760
  var valid_598761 = query.getOrDefault("callback")
  valid_598761 = validateParameter(valid_598761, JString, required = false,
                                 default = nil)
  if valid_598761 != nil:
    section.add "callback", valid_598761
  var valid_598762 = query.getOrDefault("access_token")
  valid_598762 = validateParameter(valid_598762, JString, required = false,
                                 default = nil)
  if valid_598762 != nil:
    section.add "access_token", valid_598762
  var valid_598763 = query.getOrDefault("uploadType")
  valid_598763 = validateParameter(valid_598763, JString, required = false,
                                 default = nil)
  if valid_598763 != nil:
    section.add "uploadType", valid_598763
  var valid_598764 = query.getOrDefault("key")
  valid_598764 = validateParameter(valid_598764, JString, required = false,
                                 default = nil)
  if valid_598764 != nil:
    section.add "key", valid_598764
  var valid_598765 = query.getOrDefault("$.xgafv")
  valid_598765 = validateParameter(valid_598765, JString, required = false,
                                 default = newJString("1"))
  if valid_598765 != nil:
    section.add "$.xgafv", valid_598765
  var valid_598766 = query.getOrDefault("prettyPrint")
  valid_598766 = validateParameter(valid_598766, JBool, required = false,
                                 default = newJBool(true))
  if valid_598766 != nil:
    section.add "prettyPrint", valid_598766
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

proc call*(call_598768: Call_AppengineAppsRepair_598752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
  ## 
  let valid = call_598768.validator(path, query, header, formData, body)
  let scheme = call_598768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598768.url(scheme.get, call_598768.host, call_598768.base,
                         call_598768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598768, url, valid)

proc call*(call_598769: Call_AppengineAppsRepair_598752; appsId: string;
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
  var path_598770 = newJObject()
  var query_598771 = newJObject()
  var body_598772 = newJObject()
  add(query_598771, "upload_protocol", newJString(uploadProtocol))
  add(query_598771, "fields", newJString(fields))
  add(query_598771, "quotaUser", newJString(quotaUser))
  add(query_598771, "alt", newJString(alt))
  add(query_598771, "oauth_token", newJString(oauthToken))
  add(query_598771, "callback", newJString(callback))
  add(query_598771, "access_token", newJString(accessToken))
  add(query_598771, "uploadType", newJString(uploadType))
  add(query_598771, "key", newJString(key))
  add(path_598770, "appsId", newJString(appsId))
  add(query_598771, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598772 = body
  add(query_598771, "prettyPrint", newJBool(prettyPrint))
  result = call_598769.call(path_598770, query_598771, nil, nil, body_598772)

var appengineAppsRepair* = Call_AppengineAppsRepair_598752(
    name: "appengineAppsRepair", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta/apps/{appsId}:repair",
    validator: validate_AppengineAppsRepair_598753, base: "/",
    url: url_AppengineAppsRepair_598754, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
