
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: App Engine Admin
## version: v1beta5
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
    host: "appengine.googleapis.com", route: "/v1beta5/apps",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
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
  ##   ensureResourcesExist: JBool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete. Note: This parameter will be deprecated in a future version of the API.
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
  var valid_597993 = query.getOrDefault("ensureResourcesExist")
  valid_597993 = validateParameter(valid_597993, JBool, required = false, default = nil)
  if valid_597993 != nil:
    section.add "ensureResourcesExist", valid_597993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597994: Call_AppengineAppsGet_597964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_597994.validator(path, query, header, formData, body)
  let scheme = call_597994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597994.url(scheme.get, call_597994.host, call_597994.base,
                         call_597994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597994, url, valid)

proc call*(call_597995: Call_AppengineAppsGet_597964; appsId: string;
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
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete. Note: This parameter will be deprecated in a future version of the API.
  var path_597996 = newJObject()
  var query_597997 = newJObject()
  add(query_597997, "upload_protocol", newJString(uploadProtocol))
  add(query_597997, "fields", newJString(fields))
  add(query_597997, "quotaUser", newJString(quotaUser))
  add(query_597997, "alt", newJString(alt))
  add(query_597997, "oauth_token", newJString(oauthToken))
  add(query_597997, "callback", newJString(callback))
  add(query_597997, "access_token", newJString(accessToken))
  add(query_597997, "uploadType", newJString(uploadType))
  add(query_597997, "key", newJString(key))
  add(path_597996, "appsId", newJString(appsId))
  add(query_597997, "$.xgafv", newJString(Xgafv))
  add(query_597997, "prettyPrint", newJBool(prettyPrint))
  add(query_597997, "ensureResourcesExist", newJBool(ensureResourcesExist))
  result = call_597995.call(path_597996, query_597997, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_597964(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}", validator: validate_AppengineAppsGet_597965,
    base: "/", url: url_AppengineAppsGet_597966, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_597998 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsPatch_598000(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_597999(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598001 = path.getOrDefault("appsId")
  valid_598001 = validateParameter(valid_598001, JString, required = true,
                                 default = nil)
  if valid_598001 != nil:
    section.add "appsId", valid_598001
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
  var valid_598002 = query.getOrDefault("upload_protocol")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "upload_protocol", valid_598002
  var valid_598003 = query.getOrDefault("fields")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "fields", valid_598003
  var valid_598004 = query.getOrDefault("quotaUser")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "quotaUser", valid_598004
  var valid_598005 = query.getOrDefault("alt")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = newJString("json"))
  if valid_598005 != nil:
    section.add "alt", valid_598005
  var valid_598006 = query.getOrDefault("oauth_token")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "oauth_token", valid_598006
  var valid_598007 = query.getOrDefault("callback")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "callback", valid_598007
  var valid_598008 = query.getOrDefault("access_token")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "access_token", valid_598008
  var valid_598009 = query.getOrDefault("uploadType")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "uploadType", valid_598009
  var valid_598010 = query.getOrDefault("mask")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "mask", valid_598010
  var valid_598011 = query.getOrDefault("key")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "key", valid_598011
  var valid_598012 = query.getOrDefault("$.xgafv")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("1"))
  if valid_598012 != nil:
    section.add "$.xgafv", valid_598012
  var valid_598013 = query.getOrDefault("prettyPrint")
  valid_598013 = validateParameter(valid_598013, JBool, required = false,
                                 default = newJBool(true))
  if valid_598013 != nil:
    section.add "prettyPrint", valid_598013
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

proc call*(call_598015: Call_AppengineAppsPatch_597998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  let valid = call_598015.validator(path, query, header, formData, body)
  let scheme = call_598015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598015.url(scheme.get, call_598015.host, call_598015.base,
                         call_598015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598015, url, valid)

proc call*(call_598016: Call_AppengineAppsPatch_597998; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; mask: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsPatch
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.default_cookie_expiration)
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
  var path_598017 = newJObject()
  var query_598018 = newJObject()
  var body_598019 = newJObject()
  add(query_598018, "upload_protocol", newJString(uploadProtocol))
  add(query_598018, "fields", newJString(fields))
  add(query_598018, "quotaUser", newJString(quotaUser))
  add(query_598018, "alt", newJString(alt))
  add(query_598018, "oauth_token", newJString(oauthToken))
  add(query_598018, "callback", newJString(callback))
  add(query_598018, "access_token", newJString(accessToken))
  add(query_598018, "uploadType", newJString(uploadType))
  add(query_598018, "mask", newJString(mask))
  add(query_598018, "key", newJString(key))
  add(path_598017, "appsId", newJString(appsId))
  add(query_598018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598019 = body
  add(query_598018, "prettyPrint", newJBool(prettyPrint))
  result = call_598016.call(path_598017, query_598018, nil, nil, body_598019)

var appengineAppsPatch* = Call_AppengineAppsPatch_597998(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}",
    validator: validate_AppengineAppsPatch_597999, base: "/",
    url: url_AppengineAppsPatch_598000, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_598020 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsLocationsList_598022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsList_598021(path: JsonNode; query: JsonNode;
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
  var valid_598023 = path.getOrDefault("appsId")
  valid_598023 = validateParameter(valid_598023, JString, required = true,
                                 default = nil)
  if valid_598023 != nil:
    section.add "appsId", valid_598023
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
  var valid_598024 = query.getOrDefault("upload_protocol")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "upload_protocol", valid_598024
  var valid_598025 = query.getOrDefault("fields")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "fields", valid_598025
  var valid_598026 = query.getOrDefault("pageToken")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "pageToken", valid_598026
  var valid_598027 = query.getOrDefault("quotaUser")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "quotaUser", valid_598027
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
  var valid_598037 = query.getOrDefault("filter")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "filter", valid_598037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598038: Call_AppengineAppsLocationsList_598020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598038.validator(path, query, header, formData, body)
  let scheme = call_598038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598038.url(scheme.get, call_598038.host, call_598038.base,
                         call_598038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598038, url, valid)

proc call*(call_598039: Call_AppengineAppsLocationsList_598020; appsId: string;
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
  var path_598040 = newJObject()
  var query_598041 = newJObject()
  add(query_598041, "upload_protocol", newJString(uploadProtocol))
  add(query_598041, "fields", newJString(fields))
  add(query_598041, "pageToken", newJString(pageToken))
  add(query_598041, "quotaUser", newJString(quotaUser))
  add(query_598041, "alt", newJString(alt))
  add(query_598041, "oauth_token", newJString(oauthToken))
  add(query_598041, "callback", newJString(callback))
  add(query_598041, "access_token", newJString(accessToken))
  add(query_598041, "uploadType", newJString(uploadType))
  add(query_598041, "key", newJString(key))
  add(path_598040, "appsId", newJString(appsId))
  add(query_598041, "$.xgafv", newJString(Xgafv))
  add(query_598041, "pageSize", newJInt(pageSize))
  add(query_598041, "prettyPrint", newJBool(prettyPrint))
  add(query_598041, "filter", newJString(filter))
  result = call_598039.call(path_598040, query_598041, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_598020(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_598021, base: "/",
    url: url_AppengineAppsLocationsList_598022, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_598042 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsLocationsGet_598044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "locationsId" in path, "`locationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "locationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsLocationsGet_598043(path: JsonNode; query: JsonNode;
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
  var valid_598045 = path.getOrDefault("appsId")
  valid_598045 = validateParameter(valid_598045, JString, required = true,
                                 default = nil)
  if valid_598045 != nil:
    section.add "appsId", valid_598045
  var valid_598046 = path.getOrDefault("locationsId")
  valid_598046 = validateParameter(valid_598046, JString, required = true,
                                 default = nil)
  if valid_598046 != nil:
    section.add "locationsId", valid_598046
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
  var valid_598047 = query.getOrDefault("upload_protocol")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "upload_protocol", valid_598047
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("quotaUser")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "quotaUser", valid_598049
  var valid_598050 = query.getOrDefault("alt")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = newJString("json"))
  if valid_598050 != nil:
    section.add "alt", valid_598050
  var valid_598051 = query.getOrDefault("oauth_token")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "oauth_token", valid_598051
  var valid_598052 = query.getOrDefault("callback")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "callback", valid_598052
  var valid_598053 = query.getOrDefault("access_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "access_token", valid_598053
  var valid_598054 = query.getOrDefault("uploadType")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "uploadType", valid_598054
  var valid_598055 = query.getOrDefault("key")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "key", valid_598055
  var valid_598056 = query.getOrDefault("$.xgafv")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("1"))
  if valid_598056 != nil:
    section.add "$.xgafv", valid_598056
  var valid_598057 = query.getOrDefault("prettyPrint")
  valid_598057 = validateParameter(valid_598057, JBool, required = false,
                                 default = newJBool(true))
  if valid_598057 != nil:
    section.add "prettyPrint", valid_598057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598058: Call_AppengineAppsLocationsGet_598042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_598058.validator(path, query, header, formData, body)
  let scheme = call_598058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598058.url(scheme.get, call_598058.host, call_598058.base,
                         call_598058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598058, url, valid)

proc call*(call_598059: Call_AppengineAppsLocationsGet_598042; appsId: string;
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
  var path_598060 = newJObject()
  var query_598061 = newJObject()
  add(query_598061, "upload_protocol", newJString(uploadProtocol))
  add(query_598061, "fields", newJString(fields))
  add(query_598061, "quotaUser", newJString(quotaUser))
  add(query_598061, "alt", newJString(alt))
  add(query_598061, "oauth_token", newJString(oauthToken))
  add(query_598061, "callback", newJString(callback))
  add(query_598061, "access_token", newJString(accessToken))
  add(query_598061, "uploadType", newJString(uploadType))
  add(query_598061, "key", newJString(key))
  add(path_598060, "appsId", newJString(appsId))
  add(query_598061, "$.xgafv", newJString(Xgafv))
  add(query_598061, "prettyPrint", newJBool(prettyPrint))
  add(path_598060, "locationsId", newJString(locationsId))
  result = call_598059.call(path_598060, query_598061, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_598042(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_598043, base: "/",
    url: url_AppengineAppsLocationsGet_598044, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_598062 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsList_598064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsList_598063(path: JsonNode; query: JsonNode;
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
  var valid_598065 = path.getOrDefault("appsId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "appsId", valid_598065
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
  var valid_598066 = query.getOrDefault("upload_protocol")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "upload_protocol", valid_598066
  var valid_598067 = query.getOrDefault("fields")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "fields", valid_598067
  var valid_598068 = query.getOrDefault("pageToken")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "pageToken", valid_598068
  var valid_598069 = query.getOrDefault("quotaUser")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "quotaUser", valid_598069
  var valid_598070 = query.getOrDefault("alt")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = newJString("json"))
  if valid_598070 != nil:
    section.add "alt", valid_598070
  var valid_598071 = query.getOrDefault("oauth_token")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "oauth_token", valid_598071
  var valid_598072 = query.getOrDefault("callback")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "callback", valid_598072
  var valid_598073 = query.getOrDefault("access_token")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "access_token", valid_598073
  var valid_598074 = query.getOrDefault("uploadType")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "uploadType", valid_598074
  var valid_598075 = query.getOrDefault("key")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "key", valid_598075
  var valid_598076 = query.getOrDefault("$.xgafv")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = newJString("1"))
  if valid_598076 != nil:
    section.add "$.xgafv", valid_598076
  var valid_598077 = query.getOrDefault("pageSize")
  valid_598077 = validateParameter(valid_598077, JInt, required = false, default = nil)
  if valid_598077 != nil:
    section.add "pageSize", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
  var valid_598079 = query.getOrDefault("filter")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "filter", valid_598079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598080: Call_AppengineAppsOperationsList_598062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_598080.validator(path, query, header, formData, body)
  let scheme = call_598080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598080.url(scheme.get, call_598080.host, call_598080.base,
                         call_598080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598080, url, valid)

proc call*(call_598081: Call_AppengineAppsOperationsList_598062; appsId: string;
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
  var path_598082 = newJObject()
  var query_598083 = newJObject()
  add(query_598083, "upload_protocol", newJString(uploadProtocol))
  add(query_598083, "fields", newJString(fields))
  add(query_598083, "pageToken", newJString(pageToken))
  add(query_598083, "quotaUser", newJString(quotaUser))
  add(query_598083, "alt", newJString(alt))
  add(query_598083, "oauth_token", newJString(oauthToken))
  add(query_598083, "callback", newJString(callback))
  add(query_598083, "access_token", newJString(accessToken))
  add(query_598083, "uploadType", newJString(uploadType))
  add(query_598083, "key", newJString(key))
  add(path_598082, "appsId", newJString(appsId))
  add(query_598083, "$.xgafv", newJString(Xgafv))
  add(query_598083, "pageSize", newJInt(pageSize))
  add(query_598083, "prettyPrint", newJBool(prettyPrint))
  add(query_598083, "filter", newJString(filter))
  result = call_598081.call(path_598082, query_598083, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_598062(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_598063, base: "/",
    url: url_AppengineAppsOperationsList_598064, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_598084 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsGet_598086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "operationsId" in path, "`operationsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsOperationsGet_598085(path: JsonNode; query: JsonNode;
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
  var valid_598087 = path.getOrDefault("appsId")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "appsId", valid_598087
  var valid_598088 = path.getOrDefault("operationsId")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "operationsId", valid_598088
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
  var valid_598089 = query.getOrDefault("upload_protocol")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "upload_protocol", valid_598089
  var valid_598090 = query.getOrDefault("fields")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "fields", valid_598090
  var valid_598091 = query.getOrDefault("quotaUser")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "quotaUser", valid_598091
  var valid_598092 = query.getOrDefault("alt")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = newJString("json"))
  if valid_598092 != nil:
    section.add "alt", valid_598092
  var valid_598093 = query.getOrDefault("oauth_token")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "oauth_token", valid_598093
  var valid_598094 = query.getOrDefault("callback")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "callback", valid_598094
  var valid_598095 = query.getOrDefault("access_token")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "access_token", valid_598095
  var valid_598096 = query.getOrDefault("uploadType")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "uploadType", valid_598096
  var valid_598097 = query.getOrDefault("key")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "key", valid_598097
  var valid_598098 = query.getOrDefault("$.xgafv")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("1"))
  if valid_598098 != nil:
    section.add "$.xgafv", valid_598098
  var valid_598099 = query.getOrDefault("prettyPrint")
  valid_598099 = validateParameter(valid_598099, JBool, required = false,
                                 default = newJBool(true))
  if valid_598099 != nil:
    section.add "prettyPrint", valid_598099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598100: Call_AppengineAppsOperationsGet_598084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_598100.validator(path, query, header, formData, body)
  let scheme = call_598100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598100.url(scheme.get, call_598100.host, call_598100.base,
                         call_598100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598100, url, valid)

proc call*(call_598101: Call_AppengineAppsOperationsGet_598084; appsId: string;
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
  var path_598102 = newJObject()
  var query_598103 = newJObject()
  add(query_598103, "upload_protocol", newJString(uploadProtocol))
  add(query_598103, "fields", newJString(fields))
  add(query_598103, "quotaUser", newJString(quotaUser))
  add(query_598103, "alt", newJString(alt))
  add(query_598103, "oauth_token", newJString(oauthToken))
  add(query_598103, "callback", newJString(callback))
  add(query_598103, "access_token", newJString(accessToken))
  add(query_598103, "uploadType", newJString(uploadType))
  add(query_598103, "key", newJString(key))
  add(path_598102, "appsId", newJString(appsId))
  add(query_598103, "$.xgafv", newJString(Xgafv))
  add(path_598102, "operationsId", newJString(operationsId))
  add(query_598103, "prettyPrint", newJBool(prettyPrint))
  result = call_598101.call(path_598102, query_598103, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_598084(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_598085, base: "/",
    url: url_AppengineAppsOperationsGet_598086, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_598104 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesList_598106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesList_598105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the services in the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_598107 = path.getOrDefault("appsId")
  valid_598107 = validateParameter(valid_598107, JString, required = true,
                                 default = nil)
  if valid_598107 != nil:
    section.add "appsId", valid_598107
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
  var valid_598110 = query.getOrDefault("pageToken")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "pageToken", valid_598110
  var valid_598111 = query.getOrDefault("quotaUser")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "quotaUser", valid_598111
  var valid_598112 = query.getOrDefault("alt")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = newJString("json"))
  if valid_598112 != nil:
    section.add "alt", valid_598112
  var valid_598113 = query.getOrDefault("oauth_token")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "oauth_token", valid_598113
  var valid_598114 = query.getOrDefault("callback")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "callback", valid_598114
  var valid_598115 = query.getOrDefault("access_token")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "access_token", valid_598115
  var valid_598116 = query.getOrDefault("uploadType")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "uploadType", valid_598116
  var valid_598117 = query.getOrDefault("key")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "key", valid_598117
  var valid_598118 = query.getOrDefault("$.xgafv")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = newJString("1"))
  if valid_598118 != nil:
    section.add "$.xgafv", valid_598118
  var valid_598119 = query.getOrDefault("pageSize")
  valid_598119 = validateParameter(valid_598119, JInt, required = false, default = nil)
  if valid_598119 != nil:
    section.add "pageSize", valid_598119
  var valid_598120 = query.getOrDefault("prettyPrint")
  valid_598120 = validateParameter(valid_598120, JBool, required = false,
                                 default = newJBool(true))
  if valid_598120 != nil:
    section.add "prettyPrint", valid_598120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598121: Call_AppengineAppsServicesList_598104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_598121.validator(path, query, header, formData, body)
  let scheme = call_598121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598121.url(scheme.get, call_598121.host, call_598121.base,
                         call_598121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598121, url, valid)

proc call*(call_598122: Call_AppengineAppsServicesList_598104; appsId: string;
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598123 = newJObject()
  var query_598124 = newJObject()
  add(query_598124, "upload_protocol", newJString(uploadProtocol))
  add(query_598124, "fields", newJString(fields))
  add(query_598124, "pageToken", newJString(pageToken))
  add(query_598124, "quotaUser", newJString(quotaUser))
  add(query_598124, "alt", newJString(alt))
  add(query_598124, "oauth_token", newJString(oauthToken))
  add(query_598124, "callback", newJString(callback))
  add(query_598124, "access_token", newJString(accessToken))
  add(query_598124, "uploadType", newJString(uploadType))
  add(query_598124, "key", newJString(key))
  add(path_598123, "appsId", newJString(appsId))
  add(query_598124, "$.xgafv", newJString(Xgafv))
  add(query_598124, "pageSize", newJInt(pageSize))
  add(query_598124, "prettyPrint", newJBool(prettyPrint))
  result = call_598122.call(path_598123, query_598124, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_598104(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_598105, base: "/",
    url: url_AppengineAppsServicesList_598106, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_598125 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesGet_598127(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesGet_598126(path: JsonNode; query: JsonNode;
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
  var valid_598128 = path.getOrDefault("servicesId")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "servicesId", valid_598128
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
  var valid_598132 = query.getOrDefault("quotaUser")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "quotaUser", valid_598132
  var valid_598133 = query.getOrDefault("alt")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = newJString("json"))
  if valid_598133 != nil:
    section.add "alt", valid_598133
  var valid_598134 = query.getOrDefault("oauth_token")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "oauth_token", valid_598134
  var valid_598135 = query.getOrDefault("callback")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "callback", valid_598135
  var valid_598136 = query.getOrDefault("access_token")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "access_token", valid_598136
  var valid_598137 = query.getOrDefault("uploadType")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "uploadType", valid_598137
  var valid_598138 = query.getOrDefault("key")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "key", valid_598138
  var valid_598139 = query.getOrDefault("$.xgafv")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = newJString("1"))
  if valid_598139 != nil:
    section.add "$.xgafv", valid_598139
  var valid_598140 = query.getOrDefault("prettyPrint")
  valid_598140 = validateParameter(valid_598140, JBool, required = false,
                                 default = newJBool(true))
  if valid_598140 != nil:
    section.add "prettyPrint", valid_598140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598141: Call_AppengineAppsServicesGet_598125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_598141.validator(path, query, header, formData, body)
  let scheme = call_598141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598141.url(scheme.get, call_598141.host, call_598141.base,
                         call_598141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598141, url, valid)

proc call*(call_598142: Call_AppengineAppsServicesGet_598125; servicesId: string;
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
  var path_598143 = newJObject()
  var query_598144 = newJObject()
  add(query_598144, "upload_protocol", newJString(uploadProtocol))
  add(query_598144, "fields", newJString(fields))
  add(query_598144, "quotaUser", newJString(quotaUser))
  add(query_598144, "alt", newJString(alt))
  add(query_598144, "oauth_token", newJString(oauthToken))
  add(query_598144, "callback", newJString(callback))
  add(query_598144, "access_token", newJString(accessToken))
  add(query_598144, "uploadType", newJString(uploadType))
  add(path_598143, "servicesId", newJString(servicesId))
  add(query_598144, "key", newJString(key))
  add(path_598143, "appsId", newJString(appsId))
  add(query_598144, "$.xgafv", newJString(Xgafv))
  add(query_598144, "prettyPrint", newJBool(prettyPrint))
  result = call_598142.call(path_598143, query_598144, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_598125(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_598126, base: "/",
    url: url_AppengineAppsServicesGet_598127, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_598165 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesPatch_598167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesPatch_598166(path: JsonNode; query: JsonNode;
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
  var valid_598168 = path.getOrDefault("servicesId")
  valid_598168 = validateParameter(valid_598168, JString, required = true,
                                 default = nil)
  if valid_598168 != nil:
    section.add "servicesId", valid_598168
  var valid_598169 = path.getOrDefault("appsId")
  valid_598169 = validateParameter(valid_598169, JString, required = true,
                                 default = nil)
  if valid_598169 != nil:
    section.add "appsId", valid_598169
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
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services#shardby) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  section = newJObject()
  var valid_598170 = query.getOrDefault("upload_protocol")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "upload_protocol", valid_598170
  var valid_598171 = query.getOrDefault("fields")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "fields", valid_598171
  var valid_598172 = query.getOrDefault("quotaUser")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "quotaUser", valid_598172
  var valid_598173 = query.getOrDefault("alt")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = newJString("json"))
  if valid_598173 != nil:
    section.add "alt", valid_598173
  var valid_598174 = query.getOrDefault("oauth_token")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "oauth_token", valid_598174
  var valid_598175 = query.getOrDefault("callback")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "callback", valid_598175
  var valid_598176 = query.getOrDefault("access_token")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "access_token", valid_598176
  var valid_598177 = query.getOrDefault("uploadType")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "uploadType", valid_598177
  var valid_598178 = query.getOrDefault("mask")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "mask", valid_598178
  var valid_598179 = query.getOrDefault("key")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "key", valid_598179
  var valid_598180 = query.getOrDefault("$.xgafv")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = newJString("1"))
  if valid_598180 != nil:
    section.add "$.xgafv", valid_598180
  var valid_598181 = query.getOrDefault("prettyPrint")
  valid_598181 = validateParameter(valid_598181, JBool, required = false,
                                 default = newJBool(true))
  if valid_598181 != nil:
    section.add "prettyPrint", valid_598181
  var valid_598182 = query.getOrDefault("migrateTraffic")
  valid_598182 = validateParameter(valid_598182, JBool, required = false, default = nil)
  if valid_598182 != nil:
    section.add "migrateTraffic", valid_598182
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

proc call*(call_598184: Call_AppengineAppsServicesPatch_598165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_598184.validator(path, query, header, formData, body)
  let scheme = call_598184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598184.url(scheme.get, call_598184.host, call_598184.base,
                         call_598184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598184, url, valid)

proc call*(call_598185: Call_AppengineAppsServicesPatch_598165; servicesId: string;
          appsId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          mask: string = ""; key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; migrateTraffic: bool = false): Recallable =
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
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
  ##   migrateTraffic: bool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services#shardby) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  var path_598186 = newJObject()
  var query_598187 = newJObject()
  var body_598188 = newJObject()
  add(query_598187, "upload_protocol", newJString(uploadProtocol))
  add(query_598187, "fields", newJString(fields))
  add(query_598187, "quotaUser", newJString(quotaUser))
  add(query_598187, "alt", newJString(alt))
  add(query_598187, "oauth_token", newJString(oauthToken))
  add(query_598187, "callback", newJString(callback))
  add(query_598187, "access_token", newJString(accessToken))
  add(query_598187, "uploadType", newJString(uploadType))
  add(query_598187, "mask", newJString(mask))
  add(path_598186, "servicesId", newJString(servicesId))
  add(query_598187, "key", newJString(key))
  add(path_598186, "appsId", newJString(appsId))
  add(query_598187, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598188 = body
  add(query_598187, "prettyPrint", newJBool(prettyPrint))
  add(query_598187, "migrateTraffic", newJBool(migrateTraffic))
  result = call_598185.call(path_598186, query_598187, nil, nil, body_598188)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_598165(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_598166, base: "/",
    url: url_AppengineAppsServicesPatch_598167, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_598145 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesDelete_598147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesDelete_598146(path: JsonNode; query: JsonNode;
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
  var valid_598148 = path.getOrDefault("servicesId")
  valid_598148 = validateParameter(valid_598148, JString, required = true,
                                 default = nil)
  if valid_598148 != nil:
    section.add "servicesId", valid_598148
  var valid_598149 = path.getOrDefault("appsId")
  valid_598149 = validateParameter(valid_598149, JString, required = true,
                                 default = nil)
  if valid_598149 != nil:
    section.add "appsId", valid_598149
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
  var valid_598150 = query.getOrDefault("upload_protocol")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "upload_protocol", valid_598150
  var valid_598151 = query.getOrDefault("fields")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "fields", valid_598151
  var valid_598152 = query.getOrDefault("quotaUser")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "quotaUser", valid_598152
  var valid_598153 = query.getOrDefault("alt")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = newJString("json"))
  if valid_598153 != nil:
    section.add "alt", valid_598153
  var valid_598154 = query.getOrDefault("oauth_token")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "oauth_token", valid_598154
  var valid_598155 = query.getOrDefault("callback")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "callback", valid_598155
  var valid_598156 = query.getOrDefault("access_token")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "access_token", valid_598156
  var valid_598157 = query.getOrDefault("uploadType")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "uploadType", valid_598157
  var valid_598158 = query.getOrDefault("key")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "key", valid_598158
  var valid_598159 = query.getOrDefault("$.xgafv")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = newJString("1"))
  if valid_598159 != nil:
    section.add "$.xgafv", valid_598159
  var valid_598160 = query.getOrDefault("prettyPrint")
  valid_598160 = validateParameter(valid_598160, JBool, required = false,
                                 default = newJBool(true))
  if valid_598160 != nil:
    section.add "prettyPrint", valid_598160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598161: Call_AppengineAppsServicesDelete_598145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_598161.validator(path, query, header, formData, body)
  let scheme = call_598161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598161.url(scheme.get, call_598161.host, call_598161.base,
                         call_598161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598161, url, valid)

proc call*(call_598162: Call_AppengineAppsServicesDelete_598145;
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
  var path_598163 = newJObject()
  var query_598164 = newJObject()
  add(query_598164, "upload_protocol", newJString(uploadProtocol))
  add(query_598164, "fields", newJString(fields))
  add(query_598164, "quotaUser", newJString(quotaUser))
  add(query_598164, "alt", newJString(alt))
  add(query_598164, "oauth_token", newJString(oauthToken))
  add(query_598164, "callback", newJString(callback))
  add(query_598164, "access_token", newJString(accessToken))
  add(query_598164, "uploadType", newJString(uploadType))
  add(path_598163, "servicesId", newJString(servicesId))
  add(query_598164, "key", newJString(key))
  add(path_598163, "appsId", newJString(appsId))
  add(query_598164, "$.xgafv", newJString(Xgafv))
  add(query_598164, "prettyPrint", newJBool(prettyPrint))
  result = call_598162.call(path_598163, query_598164, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_598145(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_598146, base: "/",
    url: url_AppengineAppsServicesDelete_598147, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_598212 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsCreate_598214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsCreate_598213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deploys new code and resource files to a new version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. For example: "apps/myapp/services/default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicesId` field"
  var valid_598215 = path.getOrDefault("servicesId")
  valid_598215 = validateParameter(valid_598215, JString, required = true,
                                 default = nil)
  if valid_598215 != nil:
    section.add "servicesId", valid_598215
  var valid_598216 = path.getOrDefault("appsId")
  valid_598216 = validateParameter(valid_598216, JString, required = true,
                                 default = nil)
  if valid_598216 != nil:
    section.add "appsId", valid_598216
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
  var valid_598217 = query.getOrDefault("upload_protocol")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "upload_protocol", valid_598217
  var valid_598218 = query.getOrDefault("fields")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "fields", valid_598218
  var valid_598219 = query.getOrDefault("quotaUser")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "quotaUser", valid_598219
  var valid_598220 = query.getOrDefault("alt")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = newJString("json"))
  if valid_598220 != nil:
    section.add "alt", valid_598220
  var valid_598221 = query.getOrDefault("oauth_token")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "oauth_token", valid_598221
  var valid_598222 = query.getOrDefault("callback")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "callback", valid_598222
  var valid_598223 = query.getOrDefault("access_token")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "access_token", valid_598223
  var valid_598224 = query.getOrDefault("uploadType")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "uploadType", valid_598224
  var valid_598225 = query.getOrDefault("key")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "key", valid_598225
  var valid_598226 = query.getOrDefault("$.xgafv")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = newJString("1"))
  if valid_598226 != nil:
    section.add "$.xgafv", valid_598226
  var valid_598227 = query.getOrDefault("prettyPrint")
  valid_598227 = validateParameter(valid_598227, JBool, required = false,
                                 default = newJBool(true))
  if valid_598227 != nil:
    section.add "prettyPrint", valid_598227
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

proc call*(call_598229: Call_AppengineAppsServicesVersionsCreate_598212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys new code and resource files to a new version.
  ## 
  let valid = call_598229.validator(path, query, header, formData, body)
  let scheme = call_598229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598229.url(scheme.get, call_598229.host, call_598229.base,
                         call_598229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598229, url, valid)

proc call*(call_598230: Call_AppengineAppsServicesVersionsCreate_598212;
          servicesId: string; appsId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsCreate
  ## Deploys new code and resource files to a new version.
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
  ##         : Part of `name`. Name of the resource to update. For example: "apps/myapp/services/default".
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598231 = newJObject()
  var query_598232 = newJObject()
  var body_598233 = newJObject()
  add(query_598232, "upload_protocol", newJString(uploadProtocol))
  add(query_598232, "fields", newJString(fields))
  add(query_598232, "quotaUser", newJString(quotaUser))
  add(query_598232, "alt", newJString(alt))
  add(query_598232, "oauth_token", newJString(oauthToken))
  add(query_598232, "callback", newJString(callback))
  add(query_598232, "access_token", newJString(accessToken))
  add(query_598232, "uploadType", newJString(uploadType))
  add(path_598231, "servicesId", newJString(servicesId))
  add(query_598232, "key", newJString(key))
  add(path_598231, "appsId", newJString(appsId))
  add(query_598232, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598233 = body
  add(query_598232, "prettyPrint", newJBool(prettyPrint))
  result = call_598230.call(path_598231, query_598232, nil, nil, body_598233)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_598212(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_598213, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_598214, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_598189 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsList_598191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsList_598190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the versions of a service.
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
  var valid_598192 = path.getOrDefault("servicesId")
  valid_598192 = validateParameter(valid_598192, JString, required = true,
                                 default = nil)
  if valid_598192 != nil:
    section.add "servicesId", valid_598192
  var valid_598193 = path.getOrDefault("appsId")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "appsId", valid_598193
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
  var valid_598194 = query.getOrDefault("upload_protocol")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "upload_protocol", valid_598194
  var valid_598195 = query.getOrDefault("fields")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "fields", valid_598195
  var valid_598196 = query.getOrDefault("pageToken")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "pageToken", valid_598196
  var valid_598197 = query.getOrDefault("quotaUser")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "quotaUser", valid_598197
  var valid_598198 = query.getOrDefault("view")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598198 != nil:
    section.add "view", valid_598198
  var valid_598199 = query.getOrDefault("alt")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = newJString("json"))
  if valid_598199 != nil:
    section.add "alt", valid_598199
  var valid_598200 = query.getOrDefault("oauth_token")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "oauth_token", valid_598200
  var valid_598201 = query.getOrDefault("callback")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "callback", valid_598201
  var valid_598202 = query.getOrDefault("access_token")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "access_token", valid_598202
  var valid_598203 = query.getOrDefault("uploadType")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "uploadType", valid_598203
  var valid_598204 = query.getOrDefault("key")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "key", valid_598204
  var valid_598205 = query.getOrDefault("$.xgafv")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = newJString("1"))
  if valid_598205 != nil:
    section.add "$.xgafv", valid_598205
  var valid_598206 = query.getOrDefault("pageSize")
  valid_598206 = validateParameter(valid_598206, JInt, required = false, default = nil)
  if valid_598206 != nil:
    section.add "pageSize", valid_598206
  var valid_598207 = query.getOrDefault("prettyPrint")
  valid_598207 = validateParameter(valid_598207, JBool, required = false,
                                 default = newJBool(true))
  if valid_598207 != nil:
    section.add "prettyPrint", valid_598207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598208: Call_AppengineAppsServicesVersionsList_598189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_598208.validator(path, query, header, formData, body)
  let scheme = call_598208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598208.url(scheme.get, call_598208.host, call_598208.base,
                         call_598208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598208, url, valid)

proc call*(call_598209: Call_AppengineAppsServicesVersionsList_598189;
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
  ##             : Part of `name`. See documentation of `appsId`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598210 = newJObject()
  var query_598211 = newJObject()
  add(query_598211, "upload_protocol", newJString(uploadProtocol))
  add(query_598211, "fields", newJString(fields))
  add(query_598211, "pageToken", newJString(pageToken))
  add(query_598211, "quotaUser", newJString(quotaUser))
  add(query_598211, "view", newJString(view))
  add(query_598211, "alt", newJString(alt))
  add(query_598211, "oauth_token", newJString(oauthToken))
  add(query_598211, "callback", newJString(callback))
  add(query_598211, "access_token", newJString(accessToken))
  add(query_598211, "uploadType", newJString(uploadType))
  add(path_598210, "servicesId", newJString(servicesId))
  add(query_598211, "key", newJString(key))
  add(path_598210, "appsId", newJString(appsId))
  add(query_598211, "$.xgafv", newJString(Xgafv))
  add(query_598211, "pageSize", newJInt(pageSize))
  add(query_598211, "prettyPrint", newJBool(prettyPrint))
  result = call_598209.call(path_598210, query_598211, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_598189(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_598190, base: "/",
    url: url_AppengineAppsServicesVersionsList_598191, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_598234 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsGet_598236(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsGet_598235(path: JsonNode;
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
  var valid_598237 = path.getOrDefault("versionsId")
  valid_598237 = validateParameter(valid_598237, JString, required = true,
                                 default = nil)
  if valid_598237 != nil:
    section.add "versionsId", valid_598237
  var valid_598238 = path.getOrDefault("servicesId")
  valid_598238 = validateParameter(valid_598238, JString, required = true,
                                 default = nil)
  if valid_598238 != nil:
    section.add "servicesId", valid_598238
  var valid_598239 = path.getOrDefault("appsId")
  valid_598239 = validateParameter(valid_598239, JString, required = true,
                                 default = nil)
  if valid_598239 != nil:
    section.add "appsId", valid_598239
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
  var valid_598240 = query.getOrDefault("upload_protocol")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "upload_protocol", valid_598240
  var valid_598241 = query.getOrDefault("fields")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "fields", valid_598241
  var valid_598242 = query.getOrDefault("view")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598242 != nil:
    section.add "view", valid_598242
  var valid_598243 = query.getOrDefault("quotaUser")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "quotaUser", valid_598243
  var valid_598244 = query.getOrDefault("alt")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = newJString("json"))
  if valid_598244 != nil:
    section.add "alt", valid_598244
  var valid_598245 = query.getOrDefault("oauth_token")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "oauth_token", valid_598245
  var valid_598246 = query.getOrDefault("callback")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "callback", valid_598246
  var valid_598247 = query.getOrDefault("access_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "access_token", valid_598247
  var valid_598248 = query.getOrDefault("uploadType")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "uploadType", valid_598248
  var valid_598249 = query.getOrDefault("key")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "key", valid_598249
  var valid_598250 = query.getOrDefault("$.xgafv")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = newJString("1"))
  if valid_598250 != nil:
    section.add "$.xgafv", valid_598250
  var valid_598251 = query.getOrDefault("prettyPrint")
  valid_598251 = validateParameter(valid_598251, JBool, required = false,
                                 default = newJBool(true))
  if valid_598251 != nil:
    section.add "prettyPrint", valid_598251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598252: Call_AppengineAppsServicesVersionsGet_598234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_598252.validator(path, query, header, formData, body)
  let scheme = call_598252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598252.url(scheme.get, call_598252.host, call_598252.base,
                         call_598252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598252, url, valid)

proc call*(call_598253: Call_AppengineAppsServicesVersionsGet_598234;
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
  var path_598254 = newJObject()
  var query_598255 = newJObject()
  add(query_598255, "upload_protocol", newJString(uploadProtocol))
  add(query_598255, "fields", newJString(fields))
  add(query_598255, "view", newJString(view))
  add(query_598255, "quotaUser", newJString(quotaUser))
  add(path_598254, "versionsId", newJString(versionsId))
  add(query_598255, "alt", newJString(alt))
  add(query_598255, "oauth_token", newJString(oauthToken))
  add(query_598255, "callback", newJString(callback))
  add(query_598255, "access_token", newJString(accessToken))
  add(query_598255, "uploadType", newJString(uploadType))
  add(path_598254, "servicesId", newJString(servicesId))
  add(query_598255, "key", newJString(key))
  add(path_598254, "appsId", newJString(appsId))
  add(query_598255, "$.xgafv", newJString(Xgafv))
  add(query_598255, "prettyPrint", newJBool(prettyPrint))
  result = call_598253.call(path_598254, query_598255, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_598234(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_598235, base: "/",
    url: url_AppengineAppsServicesVersionsGet_598236, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_598277 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsPatch_598279(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsPatch_598278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
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
  var valid_598280 = path.getOrDefault("versionsId")
  valid_598280 = validateParameter(valid_598280, JString, required = true,
                                 default = nil)
  if valid_598280 != nil:
    section.add "versionsId", valid_598280
  var valid_598281 = path.getOrDefault("servicesId")
  valid_598281 = validateParameter(valid_598281, JString, required = true,
                                 default = nil)
  if valid_598281 != nil:
    section.add "servicesId", valid_598281
  var valid_598282 = path.getOrDefault("appsId")
  valid_598282 = validateParameter(valid_598282, JString, required = true,
                                 default = nil)
  if valid_598282 != nil:
    section.add "appsId", valid_598282
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
  var valid_598283 = query.getOrDefault("upload_protocol")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "upload_protocol", valid_598283
  var valid_598284 = query.getOrDefault("fields")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "fields", valid_598284
  var valid_598285 = query.getOrDefault("quotaUser")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "quotaUser", valid_598285
  var valid_598286 = query.getOrDefault("alt")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = newJString("json"))
  if valid_598286 != nil:
    section.add "alt", valid_598286
  var valid_598287 = query.getOrDefault("oauth_token")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "oauth_token", valid_598287
  var valid_598288 = query.getOrDefault("callback")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "callback", valid_598288
  var valid_598289 = query.getOrDefault("access_token")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "access_token", valid_598289
  var valid_598290 = query.getOrDefault("uploadType")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "uploadType", valid_598290
  var valid_598291 = query.getOrDefault("mask")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "mask", valid_598291
  var valid_598292 = query.getOrDefault("key")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "key", valid_598292
  var valid_598293 = query.getOrDefault("$.xgafv")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = newJString("1"))
  if valid_598293 != nil:
    section.add "$.xgafv", valid_598293
  var valid_598294 = query.getOrDefault("prettyPrint")
  valid_598294 = validateParameter(valid_598294, JBool, required = false,
                                 default = newJBool(true))
  if valid_598294 != nil:
    section.add "prettyPrint", valid_598294
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

proc call*(call_598296: Call_AppengineAppsServicesVersionsPatch_598277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  let valid = call_598296.validator(path, query, header, formData, body)
  let scheme = call_598296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598296.url(scheme.get, call_598296.host, call_598296.base,
                         call_598296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598296, url, valid)

proc call*(call_598297: Call_AppengineAppsServicesVersionsPatch_598277;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; mask: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsPatch
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
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
  var path_598298 = newJObject()
  var query_598299 = newJObject()
  var body_598300 = newJObject()
  add(query_598299, "upload_protocol", newJString(uploadProtocol))
  add(query_598299, "fields", newJString(fields))
  add(query_598299, "quotaUser", newJString(quotaUser))
  add(path_598298, "versionsId", newJString(versionsId))
  add(query_598299, "alt", newJString(alt))
  add(query_598299, "oauth_token", newJString(oauthToken))
  add(query_598299, "callback", newJString(callback))
  add(query_598299, "access_token", newJString(accessToken))
  add(query_598299, "uploadType", newJString(uploadType))
  add(query_598299, "mask", newJString(mask))
  add(path_598298, "servicesId", newJString(servicesId))
  add(query_598299, "key", newJString(key))
  add(path_598298, "appsId", newJString(appsId))
  add(query_598299, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598300 = body
  add(query_598299, "prettyPrint", newJBool(prettyPrint))
  result = call_598297.call(path_598298, query_598299, nil, nil, body_598300)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_598277(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_598278, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_598279, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_598256 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsDelete_598258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "servicesId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsServicesVersionsDelete_598257(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing version.
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
  var valid_598259 = path.getOrDefault("versionsId")
  valid_598259 = validateParameter(valid_598259, JString, required = true,
                                 default = nil)
  if valid_598259 != nil:
    section.add "versionsId", valid_598259
  var valid_598260 = path.getOrDefault("servicesId")
  valid_598260 = validateParameter(valid_598260, JString, required = true,
                                 default = nil)
  if valid_598260 != nil:
    section.add "servicesId", valid_598260
  var valid_598261 = path.getOrDefault("appsId")
  valid_598261 = validateParameter(valid_598261, JString, required = true,
                                 default = nil)
  if valid_598261 != nil:
    section.add "appsId", valid_598261
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
  var valid_598262 = query.getOrDefault("upload_protocol")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "upload_protocol", valid_598262
  var valid_598263 = query.getOrDefault("fields")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "fields", valid_598263
  var valid_598264 = query.getOrDefault("quotaUser")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "quotaUser", valid_598264
  var valid_598265 = query.getOrDefault("alt")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = newJString("json"))
  if valid_598265 != nil:
    section.add "alt", valid_598265
  var valid_598266 = query.getOrDefault("oauth_token")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "oauth_token", valid_598266
  var valid_598267 = query.getOrDefault("callback")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "callback", valid_598267
  var valid_598268 = query.getOrDefault("access_token")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "access_token", valid_598268
  var valid_598269 = query.getOrDefault("uploadType")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "uploadType", valid_598269
  var valid_598270 = query.getOrDefault("key")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "key", valid_598270
  var valid_598271 = query.getOrDefault("$.xgafv")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = newJString("1"))
  if valid_598271 != nil:
    section.add "$.xgafv", valid_598271
  var valid_598272 = query.getOrDefault("prettyPrint")
  valid_598272 = validateParameter(valid_598272, JBool, required = false,
                                 default = newJBool(true))
  if valid_598272 != nil:
    section.add "prettyPrint", valid_598272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598273: Call_AppengineAppsServicesVersionsDelete_598256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing version.
  ## 
  let valid = call_598273.validator(path, query, header, formData, body)
  let scheme = call_598273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598273.url(scheme.get, call_598273.host, call_598273.base,
                         call_598273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598273, url, valid)

proc call*(call_598274: Call_AppengineAppsServicesVersionsDelete_598256;
          versionsId: string; servicesId: string; appsId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## appengineAppsServicesVersionsDelete
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
  var path_598275 = newJObject()
  var query_598276 = newJObject()
  add(query_598276, "upload_protocol", newJString(uploadProtocol))
  add(query_598276, "fields", newJString(fields))
  add(query_598276, "quotaUser", newJString(quotaUser))
  add(path_598275, "versionsId", newJString(versionsId))
  add(query_598276, "alt", newJString(alt))
  add(query_598276, "oauth_token", newJString(oauthToken))
  add(query_598276, "callback", newJString(callback))
  add(query_598276, "access_token", newJString(accessToken))
  add(query_598276, "uploadType", newJString(uploadType))
  add(path_598275, "servicesId", newJString(servicesId))
  add(query_598276, "key", newJString(key))
  add(path_598275, "appsId", newJString(appsId))
  add(query_598276, "$.xgafv", newJString(Xgafv))
  add(query_598276, "prettyPrint", newJBool(prettyPrint))
  result = call_598274.call(path_598275, query_598276, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_598256(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_598257, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_598258, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_598301 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesList_598303(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  assert "servicesId" in path, "`servicesId` is a required path parameter"
  assert "versionsId" in path, "`versionsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesList_598302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
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
  var valid_598304 = path.getOrDefault("versionsId")
  valid_598304 = validateParameter(valid_598304, JString, required = true,
                                 default = nil)
  if valid_598304 != nil:
    section.add "versionsId", valid_598304
  var valid_598305 = path.getOrDefault("servicesId")
  valid_598305 = validateParameter(valid_598305, JString, required = true,
                                 default = nil)
  if valid_598305 != nil:
    section.add "servicesId", valid_598305
  var valid_598306 = path.getOrDefault("appsId")
  valid_598306 = validateParameter(valid_598306, JString, required = true,
                                 default = nil)
  if valid_598306 != nil:
    section.add "appsId", valid_598306
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
  var valid_598307 = query.getOrDefault("upload_protocol")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "upload_protocol", valid_598307
  var valid_598308 = query.getOrDefault("fields")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "fields", valid_598308
  var valid_598309 = query.getOrDefault("pageToken")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "pageToken", valid_598309
  var valid_598310 = query.getOrDefault("quotaUser")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "quotaUser", valid_598310
  var valid_598311 = query.getOrDefault("alt")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = newJString("json"))
  if valid_598311 != nil:
    section.add "alt", valid_598311
  var valid_598312 = query.getOrDefault("oauth_token")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "oauth_token", valid_598312
  var valid_598313 = query.getOrDefault("callback")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "callback", valid_598313
  var valid_598314 = query.getOrDefault("access_token")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "access_token", valid_598314
  var valid_598315 = query.getOrDefault("uploadType")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "uploadType", valid_598315
  var valid_598316 = query.getOrDefault("key")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "key", valid_598316
  var valid_598317 = query.getOrDefault("$.xgafv")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("1"))
  if valid_598317 != nil:
    section.add "$.xgafv", valid_598317
  var valid_598318 = query.getOrDefault("pageSize")
  valid_598318 = validateParameter(valid_598318, JInt, required = false, default = nil)
  if valid_598318 != nil:
    section.add "pageSize", valid_598318
  var valid_598319 = query.getOrDefault("prettyPrint")
  valid_598319 = validateParameter(valid_598319, JBool, required = false,
                                 default = newJBool(true))
  if valid_598319 != nil:
    section.add "prettyPrint", valid_598319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598320: Call_AppengineAppsServicesVersionsInstancesList_598301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_598320.validator(path, query, header, formData, body)
  let scheme = call_598320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598320.url(scheme.get, call_598320.host, call_598320.base,
                         call_598320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598320, url, valid)

proc call*(call_598321: Call_AppengineAppsServicesVersionsInstancesList_598301;
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
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598322 = newJObject()
  var query_598323 = newJObject()
  add(query_598323, "upload_protocol", newJString(uploadProtocol))
  add(query_598323, "fields", newJString(fields))
  add(query_598323, "pageToken", newJString(pageToken))
  add(query_598323, "quotaUser", newJString(quotaUser))
  add(path_598322, "versionsId", newJString(versionsId))
  add(query_598323, "alt", newJString(alt))
  add(query_598323, "oauth_token", newJString(oauthToken))
  add(query_598323, "callback", newJString(callback))
  add(query_598323, "access_token", newJString(accessToken))
  add(query_598323, "uploadType", newJString(uploadType))
  add(path_598322, "servicesId", newJString(servicesId))
  add(query_598323, "key", newJString(key))
  add(path_598322, "appsId", newJString(appsId))
  add(query_598323, "$.xgafv", newJString(Xgafv))
  add(query_598323, "pageSize", newJInt(pageSize))
  add(query_598323, "prettyPrint", newJBool(prettyPrint))
  result = call_598321.call(path_598322, query_598323, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_598301(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_598302,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_598303,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_598324 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesGet_598326(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesGet_598325(path: JsonNode;
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
  var valid_598327 = path.getOrDefault("versionsId")
  valid_598327 = validateParameter(valid_598327, JString, required = true,
                                 default = nil)
  if valid_598327 != nil:
    section.add "versionsId", valid_598327
  var valid_598328 = path.getOrDefault("instancesId")
  valid_598328 = validateParameter(valid_598328, JString, required = true,
                                 default = nil)
  if valid_598328 != nil:
    section.add "instancesId", valid_598328
  var valid_598329 = path.getOrDefault("servicesId")
  valid_598329 = validateParameter(valid_598329, JString, required = true,
                                 default = nil)
  if valid_598329 != nil:
    section.add "servicesId", valid_598329
  var valid_598330 = path.getOrDefault("appsId")
  valid_598330 = validateParameter(valid_598330, JString, required = true,
                                 default = nil)
  if valid_598330 != nil:
    section.add "appsId", valid_598330
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
  var valid_598331 = query.getOrDefault("upload_protocol")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "upload_protocol", valid_598331
  var valid_598332 = query.getOrDefault("fields")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "fields", valid_598332
  var valid_598333 = query.getOrDefault("quotaUser")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "quotaUser", valid_598333
  var valid_598334 = query.getOrDefault("alt")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = newJString("json"))
  if valid_598334 != nil:
    section.add "alt", valid_598334
  var valid_598335 = query.getOrDefault("oauth_token")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "oauth_token", valid_598335
  var valid_598336 = query.getOrDefault("callback")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "callback", valid_598336
  var valid_598337 = query.getOrDefault("access_token")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "access_token", valid_598337
  var valid_598338 = query.getOrDefault("uploadType")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "uploadType", valid_598338
  var valid_598339 = query.getOrDefault("key")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "key", valid_598339
  var valid_598340 = query.getOrDefault("$.xgafv")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = newJString("1"))
  if valid_598340 != nil:
    section.add "$.xgafv", valid_598340
  var valid_598341 = query.getOrDefault("prettyPrint")
  valid_598341 = validateParameter(valid_598341, JBool, required = false,
                                 default = newJBool(true))
  if valid_598341 != nil:
    section.add "prettyPrint", valid_598341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598342: Call_AppengineAppsServicesVersionsInstancesGet_598324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_598342.validator(path, query, header, formData, body)
  let scheme = call_598342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598342.url(scheme.get, call_598342.host, call_598342.base,
                         call_598342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598342, url, valid)

proc call*(call_598343: Call_AppengineAppsServicesVersionsInstancesGet_598324;
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
  var path_598344 = newJObject()
  var query_598345 = newJObject()
  add(query_598345, "upload_protocol", newJString(uploadProtocol))
  add(query_598345, "fields", newJString(fields))
  add(query_598345, "quotaUser", newJString(quotaUser))
  add(path_598344, "versionsId", newJString(versionsId))
  add(query_598345, "alt", newJString(alt))
  add(path_598344, "instancesId", newJString(instancesId))
  add(query_598345, "oauth_token", newJString(oauthToken))
  add(query_598345, "callback", newJString(callback))
  add(query_598345, "access_token", newJString(accessToken))
  add(query_598345, "uploadType", newJString(uploadType))
  add(path_598344, "servicesId", newJString(servicesId))
  add(query_598345, "key", newJString(key))
  add(path_598344, "appsId", newJString(appsId))
  add(query_598345, "$.xgafv", newJString(Xgafv))
  add(query_598345, "prettyPrint", newJBool(prettyPrint))
  result = call_598343.call(path_598344, query_598345, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_598324(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_598325,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_598326,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_598346 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesDelete_598348(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesDelete_598347(path: JsonNode;
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
  ##         : Part of `name`. Name of the resource requested. For example: "apps/myapp/services/default/versions/v1/instances/instance-1".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_598349 = path.getOrDefault("versionsId")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "versionsId", valid_598349
  var valid_598350 = path.getOrDefault("instancesId")
  valid_598350 = validateParameter(valid_598350, JString, required = true,
                                 default = nil)
  if valid_598350 != nil:
    section.add "instancesId", valid_598350
  var valid_598351 = path.getOrDefault("servicesId")
  valid_598351 = validateParameter(valid_598351, JString, required = true,
                                 default = nil)
  if valid_598351 != nil:
    section.add "servicesId", valid_598351
  var valid_598352 = path.getOrDefault("appsId")
  valid_598352 = validateParameter(valid_598352, JString, required = true,
                                 default = nil)
  if valid_598352 != nil:
    section.add "appsId", valid_598352
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
  var valid_598353 = query.getOrDefault("upload_protocol")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "upload_protocol", valid_598353
  var valid_598354 = query.getOrDefault("fields")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "fields", valid_598354
  var valid_598355 = query.getOrDefault("quotaUser")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "quotaUser", valid_598355
  var valid_598356 = query.getOrDefault("alt")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = newJString("json"))
  if valid_598356 != nil:
    section.add "alt", valid_598356
  var valid_598357 = query.getOrDefault("oauth_token")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "oauth_token", valid_598357
  var valid_598358 = query.getOrDefault("callback")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "callback", valid_598358
  var valid_598359 = query.getOrDefault("access_token")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "access_token", valid_598359
  var valid_598360 = query.getOrDefault("uploadType")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "uploadType", valid_598360
  var valid_598361 = query.getOrDefault("key")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "key", valid_598361
  var valid_598362 = query.getOrDefault("$.xgafv")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = newJString("1"))
  if valid_598362 != nil:
    section.add "$.xgafv", valid_598362
  var valid_598363 = query.getOrDefault("prettyPrint")
  valid_598363 = validateParameter(valid_598363, JBool, required = false,
                                 default = newJBool(true))
  if valid_598363 != nil:
    section.add "prettyPrint", valid_598363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598364: Call_AppengineAppsServicesVersionsInstancesDelete_598346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_598364.validator(path, query, header, formData, body)
  let scheme = call_598364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598364.url(scheme.get, call_598364.host, call_598364.base,
                         call_598364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598364, url, valid)

proc call*(call_598365: Call_AppengineAppsServicesVersionsInstancesDelete_598346;
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
  ##         : Part of `name`. Name of the resource requested. For example: "apps/myapp/services/default/versions/v1/instances/instance-1".
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598366 = newJObject()
  var query_598367 = newJObject()
  add(query_598367, "upload_protocol", newJString(uploadProtocol))
  add(query_598367, "fields", newJString(fields))
  add(query_598367, "quotaUser", newJString(quotaUser))
  add(path_598366, "versionsId", newJString(versionsId))
  add(query_598367, "alt", newJString(alt))
  add(path_598366, "instancesId", newJString(instancesId))
  add(query_598367, "oauth_token", newJString(oauthToken))
  add(query_598367, "callback", newJString(callback))
  add(query_598367, "access_token", newJString(accessToken))
  add(query_598367, "uploadType", newJString(uploadType))
  add(path_598366, "servicesId", newJString(servicesId))
  add(query_598367, "key", newJString(key))
  add(path_598366, "appsId", newJString(appsId))
  add(query_598367, "$.xgafv", newJString(Xgafv))
  add(query_598367, "prettyPrint", newJBool(prettyPrint))
  result = call_598365.call(path_598366, query_598367, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_598346(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_598347,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_598348,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_598368 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsServicesVersionsInstancesDebug_598370(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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

proc validate_AppengineAppsServicesVersionsInstancesDebug_598369(path: JsonNode;
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
  var valid_598371 = path.getOrDefault("versionsId")
  valid_598371 = validateParameter(valid_598371, JString, required = true,
                                 default = nil)
  if valid_598371 != nil:
    section.add "versionsId", valid_598371
  var valid_598372 = path.getOrDefault("instancesId")
  valid_598372 = validateParameter(valid_598372, JString, required = true,
                                 default = nil)
  if valid_598372 != nil:
    section.add "instancesId", valid_598372
  var valid_598373 = path.getOrDefault("servicesId")
  valid_598373 = validateParameter(valid_598373, JString, required = true,
                                 default = nil)
  if valid_598373 != nil:
    section.add "servicesId", valid_598373
  var valid_598374 = path.getOrDefault("appsId")
  valid_598374 = validateParameter(valid_598374, JString, required = true,
                                 default = nil)
  if valid_598374 != nil:
    section.add "appsId", valid_598374
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
  var valid_598375 = query.getOrDefault("upload_protocol")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "upload_protocol", valid_598375
  var valid_598376 = query.getOrDefault("fields")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "fields", valid_598376
  var valid_598377 = query.getOrDefault("quotaUser")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "quotaUser", valid_598377
  var valid_598378 = query.getOrDefault("alt")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = newJString("json"))
  if valid_598378 != nil:
    section.add "alt", valid_598378
  var valid_598379 = query.getOrDefault("oauth_token")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = nil)
  if valid_598379 != nil:
    section.add "oauth_token", valid_598379
  var valid_598380 = query.getOrDefault("callback")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "callback", valid_598380
  var valid_598381 = query.getOrDefault("access_token")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "access_token", valid_598381
  var valid_598382 = query.getOrDefault("uploadType")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "uploadType", valid_598382
  var valid_598383 = query.getOrDefault("key")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "key", valid_598383
  var valid_598384 = query.getOrDefault("$.xgafv")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = newJString("1"))
  if valid_598384 != nil:
    section.add "$.xgafv", valid_598384
  var valid_598385 = query.getOrDefault("prettyPrint")
  valid_598385 = validateParameter(valid_598385, JBool, required = false,
                                 default = newJBool(true))
  if valid_598385 != nil:
    section.add "prettyPrint", valid_598385
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

proc call*(call_598387: Call_AppengineAppsServicesVersionsInstancesDebug_598368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_598387.validator(path, query, header, formData, body)
  let scheme = call_598387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598387.url(scheme.get, call_598387.host, call_598387.base,
                         call_598387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598387, url, valid)

proc call*(call_598388: Call_AppengineAppsServicesVersionsInstancesDebug_598368;
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
  var path_598389 = newJObject()
  var query_598390 = newJObject()
  var body_598391 = newJObject()
  add(query_598390, "upload_protocol", newJString(uploadProtocol))
  add(query_598390, "fields", newJString(fields))
  add(query_598390, "quotaUser", newJString(quotaUser))
  add(path_598389, "versionsId", newJString(versionsId))
  add(query_598390, "alt", newJString(alt))
  add(path_598389, "instancesId", newJString(instancesId))
  add(query_598390, "oauth_token", newJString(oauthToken))
  add(query_598390, "callback", newJString(callback))
  add(query_598390, "access_token", newJString(accessToken))
  add(query_598390, "uploadType", newJString(uploadType))
  add(path_598389, "servicesId", newJString(servicesId))
  add(query_598390, "key", newJString(key))
  add(path_598389, "appsId", newJString(appsId))
  add(query_598390, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598391 = body
  add(query_598390, "prettyPrint", newJBool(prettyPrint))
  result = call_598388.call(path_598389, query_598390, nil, nil, body_598391)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_598368(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_598369,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_598370,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
