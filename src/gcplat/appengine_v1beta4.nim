
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
    host: "appengine.googleapis.com", route: "/v1beta4/apps",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
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
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete.
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
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete.
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
    route: "/v1beta4/apps/{appsId}", validator: validate_AppengineAppsGet_597965,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_597999(path: JsonNode; query: JsonNode;
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
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps#Application.FIELDS.default_cookie_expiration)
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
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
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
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/locations",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta4/apps/"),
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
    route: "/v1beta4/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_598043, base: "/",
    url: url_AppengineAppsLocationsGet_598044, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesList_598062 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesList_598064(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesList_598063(path: JsonNode; query: JsonNode;
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598079: Call_AppengineAppsModulesList_598062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the modules in the application.
  ## 
  let valid = call_598079.validator(path, query, header, formData, body)
  let scheme = call_598079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598079.url(scheme.get, call_598079.host, call_598079.base,
                         call_598079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598079, url, valid)

proc call*(call_598080: Call_AppengineAppsModulesList_598062; appsId: string;
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
  var path_598081 = newJObject()
  var query_598082 = newJObject()
  add(query_598082, "upload_protocol", newJString(uploadProtocol))
  add(query_598082, "fields", newJString(fields))
  add(query_598082, "pageToken", newJString(pageToken))
  add(query_598082, "quotaUser", newJString(quotaUser))
  add(query_598082, "alt", newJString(alt))
  add(query_598082, "oauth_token", newJString(oauthToken))
  add(query_598082, "callback", newJString(callback))
  add(query_598082, "access_token", newJString(accessToken))
  add(query_598082, "uploadType", newJString(uploadType))
  add(query_598082, "key", newJString(key))
  add(path_598081, "appsId", newJString(appsId))
  add(query_598082, "$.xgafv", newJString(Xgafv))
  add(query_598082, "pageSize", newJInt(pageSize))
  add(query_598082, "prettyPrint", newJBool(prettyPrint))
  result = call_598080.call(path_598081, query_598082, nil, nil, nil)

var appengineAppsModulesList* = Call_AppengineAppsModulesList_598062(
    name: "appengineAppsModulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules",
    validator: validate_AppengineAppsModulesList_598063, base: "/",
    url: url_AppengineAppsModulesList_598064, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesGet_598083 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesGet_598085(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesGet_598084(path: JsonNode; query: JsonNode;
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
  var valid_598086 = path.getOrDefault("modulesId")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "modulesId", valid_598086
  var valid_598087 = path.getOrDefault("appsId")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "appsId", valid_598087
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

proc call*(call_598099: Call_AppengineAppsModulesGet_598083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified module.
  ## 
  let valid = call_598099.validator(path, query, header, formData, body)
  let scheme = call_598099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598099.url(scheme.get, call_598099.host, call_598099.base,
                         call_598099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598099, url, valid)

proc call*(call_598100: Call_AppengineAppsModulesGet_598083; modulesId: string;
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
  add(path_598101, "modulesId", newJString(modulesId))
  add(query_598102, "key", newJString(key))
  add(path_598101, "appsId", newJString(appsId))
  add(query_598102, "$.xgafv", newJString(Xgafv))
  add(query_598102, "prettyPrint", newJBool(prettyPrint))
  result = call_598100.call(path_598101, query_598102, nil, nil, nil)

var appengineAppsModulesGet* = Call_AppengineAppsModulesGet_598083(
    name: "appengineAppsModulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesGet_598084, base: "/",
    url: url_AppengineAppsModulesGet_598085, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesPatch_598123 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesPatch_598125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesPatch_598124(path: JsonNode; query: JsonNode;
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
  var valid_598126 = path.getOrDefault("modulesId")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "modulesId", valid_598126
  var valid_598127 = path.getOrDefault("appsId")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "appsId", valid_598127
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
  var valid_598128 = query.getOrDefault("upload_protocol")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "upload_protocol", valid_598128
  var valid_598129 = query.getOrDefault("fields")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "fields", valid_598129
  var valid_598130 = query.getOrDefault("quotaUser")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "quotaUser", valid_598130
  var valid_598131 = query.getOrDefault("alt")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = newJString("json"))
  if valid_598131 != nil:
    section.add "alt", valid_598131
  var valid_598132 = query.getOrDefault("oauth_token")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "oauth_token", valid_598132
  var valid_598133 = query.getOrDefault("callback")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "callback", valid_598133
  var valid_598134 = query.getOrDefault("access_token")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "access_token", valid_598134
  var valid_598135 = query.getOrDefault("uploadType")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "uploadType", valid_598135
  var valid_598136 = query.getOrDefault("mask")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "mask", valid_598136
  var valid_598137 = query.getOrDefault("key")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "key", valid_598137
  var valid_598138 = query.getOrDefault("$.xgafv")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = newJString("1"))
  if valid_598138 != nil:
    section.add "$.xgafv", valid_598138
  var valid_598139 = query.getOrDefault("prettyPrint")
  valid_598139 = validateParameter(valid_598139, JBool, required = false,
                                 default = newJBool(true))
  if valid_598139 != nil:
    section.add "prettyPrint", valid_598139
  var valid_598140 = query.getOrDefault("migrateTraffic")
  valid_598140 = validateParameter(valid_598140, JBool, required = false, default = nil)
  if valid_598140 != nil:
    section.add "migrateTraffic", valid_598140
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

proc call*(call_598142: Call_AppengineAppsModulesPatch_598123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified module.
  ## 
  let valid = call_598142.validator(path, query, header, formData, body)
  let scheme = call_598142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598142.url(scheme.get, call_598142.host, call_598142.base,
                         call_598142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598142, url, valid)

proc call*(call_598143: Call_AppengineAppsModulesPatch_598123; modulesId: string;
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
  var path_598144 = newJObject()
  var query_598145 = newJObject()
  var body_598146 = newJObject()
  add(query_598145, "upload_protocol", newJString(uploadProtocol))
  add(query_598145, "fields", newJString(fields))
  add(query_598145, "quotaUser", newJString(quotaUser))
  add(query_598145, "alt", newJString(alt))
  add(query_598145, "oauth_token", newJString(oauthToken))
  add(query_598145, "callback", newJString(callback))
  add(query_598145, "access_token", newJString(accessToken))
  add(query_598145, "uploadType", newJString(uploadType))
  add(query_598145, "mask", newJString(mask))
  add(path_598144, "modulesId", newJString(modulesId))
  add(query_598145, "key", newJString(key))
  add(path_598144, "appsId", newJString(appsId))
  add(query_598145, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598146 = body
  add(query_598145, "prettyPrint", newJBool(prettyPrint))
  add(query_598145, "migrateTraffic", newJBool(migrateTraffic))
  result = call_598143.call(path_598144, query_598145, nil, nil, body_598146)

var appengineAppsModulesPatch* = Call_AppengineAppsModulesPatch_598123(
    name: "appengineAppsModulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesPatch_598124, base: "/",
    url: url_AppengineAppsModulesPatch_598125, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesDelete_598103 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesDelete_598105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesDelete_598104(path: JsonNode; query: JsonNode;
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
  var valid_598106 = path.getOrDefault("modulesId")
  valid_598106 = validateParameter(valid_598106, JString, required = true,
                                 default = nil)
  if valid_598106 != nil:
    section.add "modulesId", valid_598106
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598119: Call_AppengineAppsModulesDelete_598103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified module and all enclosed versions.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AppengineAppsModulesDelete_598103; modulesId: string;
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
  var path_598121 = newJObject()
  var query_598122 = newJObject()
  add(query_598122, "upload_protocol", newJString(uploadProtocol))
  add(query_598122, "fields", newJString(fields))
  add(query_598122, "quotaUser", newJString(quotaUser))
  add(query_598122, "alt", newJString(alt))
  add(query_598122, "oauth_token", newJString(oauthToken))
  add(query_598122, "callback", newJString(callback))
  add(query_598122, "access_token", newJString(accessToken))
  add(query_598122, "uploadType", newJString(uploadType))
  add(path_598121, "modulesId", newJString(modulesId))
  add(query_598122, "key", newJString(key))
  add(path_598121, "appsId", newJString(appsId))
  add(query_598122, "$.xgafv", newJString(Xgafv))
  add(query_598122, "prettyPrint", newJBool(prettyPrint))
  result = call_598120.call(path_598121, query_598122, nil, nil, nil)

var appengineAppsModulesDelete* = Call_AppengineAppsModulesDelete_598103(
    name: "appengineAppsModulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}",
    validator: validate_AppengineAppsModulesDelete_598104, base: "/",
    url: url_AppengineAppsModulesDelete_598105, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsCreate_598170 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsCreate_598172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsCreate_598171(path: JsonNode;
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
  var valid_598173 = path.getOrDefault("modulesId")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "modulesId", valid_598173
  var valid_598174 = path.getOrDefault("appsId")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "appsId", valid_598174
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
  var valid_598175 = query.getOrDefault("upload_protocol")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "upload_protocol", valid_598175
  var valid_598176 = query.getOrDefault("fields")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "fields", valid_598176
  var valid_598177 = query.getOrDefault("quotaUser")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "quotaUser", valid_598177
  var valid_598178 = query.getOrDefault("alt")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = newJString("json"))
  if valid_598178 != nil:
    section.add "alt", valid_598178
  var valid_598179 = query.getOrDefault("oauth_token")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "oauth_token", valid_598179
  var valid_598180 = query.getOrDefault("callback")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "callback", valid_598180
  var valid_598181 = query.getOrDefault("access_token")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "access_token", valid_598181
  var valid_598182 = query.getOrDefault("uploadType")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "uploadType", valid_598182
  var valid_598183 = query.getOrDefault("key")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "key", valid_598183
  var valid_598184 = query.getOrDefault("$.xgafv")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = newJString("1"))
  if valid_598184 != nil:
    section.add "$.xgafv", valid_598184
  var valid_598185 = query.getOrDefault("prettyPrint")
  valid_598185 = validateParameter(valid_598185, JBool, required = false,
                                 default = newJBool(true))
  if valid_598185 != nil:
    section.add "prettyPrint", valid_598185
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

proc call*(call_598187: Call_AppengineAppsModulesVersionsCreate_598170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_598187.validator(path, query, header, formData, body)
  let scheme = call_598187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598187.url(scheme.get, call_598187.host, call_598187.base,
                         call_598187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598187, url, valid)

proc call*(call_598188: Call_AppengineAppsModulesVersionsCreate_598170;
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
  var path_598189 = newJObject()
  var query_598190 = newJObject()
  var body_598191 = newJObject()
  add(query_598190, "upload_protocol", newJString(uploadProtocol))
  add(query_598190, "fields", newJString(fields))
  add(query_598190, "quotaUser", newJString(quotaUser))
  add(query_598190, "alt", newJString(alt))
  add(query_598190, "oauth_token", newJString(oauthToken))
  add(query_598190, "callback", newJString(callback))
  add(query_598190, "access_token", newJString(accessToken))
  add(query_598190, "uploadType", newJString(uploadType))
  add(path_598189, "modulesId", newJString(modulesId))
  add(query_598190, "key", newJString(key))
  add(path_598189, "appsId", newJString(appsId))
  add(query_598190, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598191 = body
  add(query_598190, "prettyPrint", newJBool(prettyPrint))
  result = call_598188.call(path_598189, query_598190, nil, nil, body_598191)

var appengineAppsModulesVersionsCreate* = Call_AppengineAppsModulesVersionsCreate_598170(
    name: "appengineAppsModulesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsCreate_598171, base: "/",
    url: url_AppengineAppsModulesVersionsCreate_598172, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsList_598147 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsList_598149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsList_598148(path: JsonNode;
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
  var valid_598150 = path.getOrDefault("modulesId")
  valid_598150 = validateParameter(valid_598150, JString, required = true,
                                 default = nil)
  if valid_598150 != nil:
    section.add "modulesId", valid_598150
  var valid_598151 = path.getOrDefault("appsId")
  valid_598151 = validateParameter(valid_598151, JString, required = true,
                                 default = nil)
  if valid_598151 != nil:
    section.add "appsId", valid_598151
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
  var valid_598152 = query.getOrDefault("upload_protocol")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "upload_protocol", valid_598152
  var valid_598153 = query.getOrDefault("fields")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "fields", valid_598153
  var valid_598154 = query.getOrDefault("pageToken")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "pageToken", valid_598154
  var valid_598155 = query.getOrDefault("quotaUser")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "quotaUser", valid_598155
  var valid_598156 = query.getOrDefault("view")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598156 != nil:
    section.add "view", valid_598156
  var valid_598157 = query.getOrDefault("alt")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = newJString("json"))
  if valid_598157 != nil:
    section.add "alt", valid_598157
  var valid_598158 = query.getOrDefault("oauth_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "oauth_token", valid_598158
  var valid_598159 = query.getOrDefault("callback")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "callback", valid_598159
  var valid_598160 = query.getOrDefault("access_token")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "access_token", valid_598160
  var valid_598161 = query.getOrDefault("uploadType")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "uploadType", valid_598161
  var valid_598162 = query.getOrDefault("key")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "key", valid_598162
  var valid_598163 = query.getOrDefault("$.xgafv")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = newJString("1"))
  if valid_598163 != nil:
    section.add "$.xgafv", valid_598163
  var valid_598164 = query.getOrDefault("pageSize")
  valid_598164 = validateParameter(valid_598164, JInt, required = false, default = nil)
  if valid_598164 != nil:
    section.add "pageSize", valid_598164
  var valid_598165 = query.getOrDefault("prettyPrint")
  valid_598165 = validateParameter(valid_598165, JBool, required = false,
                                 default = newJBool(true))
  if valid_598165 != nil:
    section.add "prettyPrint", valid_598165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598166: Call_AppengineAppsModulesVersionsList_598147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a module.
  ## 
  let valid = call_598166.validator(path, query, header, formData, body)
  let scheme = call_598166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598166.url(scheme.get, call_598166.host, call_598166.base,
                         call_598166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598166, url, valid)

proc call*(call_598167: Call_AppengineAppsModulesVersionsList_598147;
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
  var path_598168 = newJObject()
  var query_598169 = newJObject()
  add(query_598169, "upload_protocol", newJString(uploadProtocol))
  add(query_598169, "fields", newJString(fields))
  add(query_598169, "pageToken", newJString(pageToken))
  add(query_598169, "quotaUser", newJString(quotaUser))
  add(query_598169, "view", newJString(view))
  add(query_598169, "alt", newJString(alt))
  add(query_598169, "oauth_token", newJString(oauthToken))
  add(query_598169, "callback", newJString(callback))
  add(query_598169, "access_token", newJString(accessToken))
  add(query_598169, "uploadType", newJString(uploadType))
  add(path_598168, "modulesId", newJString(modulesId))
  add(query_598169, "key", newJString(key))
  add(path_598168, "appsId", newJString(appsId))
  add(query_598169, "$.xgafv", newJString(Xgafv))
  add(query_598169, "pageSize", newJInt(pageSize))
  add(query_598169, "prettyPrint", newJBool(prettyPrint))
  result = call_598167.call(path_598168, query_598169, nil, nil, nil)

var appengineAppsModulesVersionsList* = Call_AppengineAppsModulesVersionsList_598147(
    name: "appengineAppsModulesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions",
    validator: validate_AppengineAppsModulesVersionsList_598148, base: "/",
    url: url_AppengineAppsModulesVersionsList_598149, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsGet_598192 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsGet_598194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsGet_598193(path: JsonNode;
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
  var valid_598195 = path.getOrDefault("versionsId")
  valid_598195 = validateParameter(valid_598195, JString, required = true,
                                 default = nil)
  if valid_598195 != nil:
    section.add "versionsId", valid_598195
  var valid_598196 = path.getOrDefault("modulesId")
  valid_598196 = validateParameter(valid_598196, JString, required = true,
                                 default = nil)
  if valid_598196 != nil:
    section.add "modulesId", valid_598196
  var valid_598197 = path.getOrDefault("appsId")
  valid_598197 = validateParameter(valid_598197, JString, required = true,
                                 default = nil)
  if valid_598197 != nil:
    section.add "appsId", valid_598197
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
  var valid_598198 = query.getOrDefault("upload_protocol")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "upload_protocol", valid_598198
  var valid_598199 = query.getOrDefault("fields")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "fields", valid_598199
  var valid_598200 = query.getOrDefault("view")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598200 != nil:
    section.add "view", valid_598200
  var valid_598201 = query.getOrDefault("quotaUser")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "quotaUser", valid_598201
  var valid_598202 = query.getOrDefault("alt")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = newJString("json"))
  if valid_598202 != nil:
    section.add "alt", valid_598202
  var valid_598203 = query.getOrDefault("oauth_token")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "oauth_token", valid_598203
  var valid_598204 = query.getOrDefault("callback")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "callback", valid_598204
  var valid_598205 = query.getOrDefault("access_token")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "access_token", valid_598205
  var valid_598206 = query.getOrDefault("uploadType")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "uploadType", valid_598206
  var valid_598207 = query.getOrDefault("key")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "key", valid_598207
  var valid_598208 = query.getOrDefault("$.xgafv")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = newJString("1"))
  if valid_598208 != nil:
    section.add "$.xgafv", valid_598208
  var valid_598209 = query.getOrDefault("prettyPrint")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "prettyPrint", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598210: Call_AppengineAppsModulesVersionsGet_598192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_AppengineAppsModulesVersionsGet_598192;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  add(query_598213, "upload_protocol", newJString(uploadProtocol))
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "view", newJString(view))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(path_598212, "versionsId", newJString(versionsId))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(query_598213, "callback", newJString(callback))
  add(query_598213, "access_token", newJString(accessToken))
  add(query_598213, "uploadType", newJString(uploadType))
  add(path_598212, "modulesId", newJString(modulesId))
  add(query_598213, "key", newJString(key))
  add(path_598212, "appsId", newJString(appsId))
  add(query_598213, "$.xgafv", newJString(Xgafv))
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  result = call_598211.call(path_598212, query_598213, nil, nil, nil)

var appengineAppsModulesVersionsGet* = Call_AppengineAppsModulesVersionsGet_598192(
    name: "appengineAppsModulesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsGet_598193, base: "/",
    url: url_AppengineAppsModulesVersionsGet_598194, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsPatch_598235 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsPatch_598237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsPatch_598236(path: JsonNode;
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
  var valid_598238 = path.getOrDefault("versionsId")
  valid_598238 = validateParameter(valid_598238, JString, required = true,
                                 default = nil)
  if valid_598238 != nil:
    section.add "versionsId", valid_598238
  var valid_598239 = path.getOrDefault("modulesId")
  valid_598239 = validateParameter(valid_598239, JString, required = true,
                                 default = nil)
  if valid_598239 != nil:
    section.add "modulesId", valid_598239
  var valid_598240 = path.getOrDefault("appsId")
  valid_598240 = validateParameter(valid_598240, JString, required = true,
                                 default = nil)
  if valid_598240 != nil:
    section.add "appsId", valid_598240
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
  var valid_598241 = query.getOrDefault("upload_protocol")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "upload_protocol", valid_598241
  var valid_598242 = query.getOrDefault("fields")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "fields", valid_598242
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
  var valid_598249 = query.getOrDefault("mask")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "mask", valid_598249
  var valid_598250 = query.getOrDefault("key")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "key", valid_598250
  var valid_598251 = query.getOrDefault("$.xgafv")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = newJString("1"))
  if valid_598251 != nil:
    section.add "$.xgafv", valid_598251
  var valid_598252 = query.getOrDefault("prettyPrint")
  valid_598252 = validateParameter(valid_598252, JBool, required = false,
                                 default = newJBool(true))
  if valid_598252 != nil:
    section.add "prettyPrint", valid_598252
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

proc call*(call_598254: Call_AppengineAppsModulesVersionsPatch_598235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta4/apps.modules.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  let valid = call_598254.validator(path, query, header, formData, body)
  let scheme = call_598254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598254.url(scheme.get, call_598254.host, call_598254.base,
                         call_598254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598254, url, valid)

proc call*(call_598255: Call_AppengineAppsModulesVersionsPatch_598235;
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
  var path_598256 = newJObject()
  var query_598257 = newJObject()
  var body_598258 = newJObject()
  add(query_598257, "upload_protocol", newJString(uploadProtocol))
  add(query_598257, "fields", newJString(fields))
  add(query_598257, "quotaUser", newJString(quotaUser))
  add(path_598256, "versionsId", newJString(versionsId))
  add(query_598257, "alt", newJString(alt))
  add(query_598257, "oauth_token", newJString(oauthToken))
  add(query_598257, "callback", newJString(callback))
  add(query_598257, "access_token", newJString(accessToken))
  add(query_598257, "uploadType", newJString(uploadType))
  add(query_598257, "mask", newJString(mask))
  add(path_598256, "modulesId", newJString(modulesId))
  add(query_598257, "key", newJString(key))
  add(path_598256, "appsId", newJString(appsId))
  add(query_598257, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598258 = body
  add(query_598257, "prettyPrint", newJBool(prettyPrint))
  result = call_598255.call(path_598256, query_598257, nil, nil, body_598258)

var appengineAppsModulesVersionsPatch* = Call_AppengineAppsModulesVersionsPatch_598235(
    name: "appengineAppsModulesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsPatch_598236, base: "/",
    url: url_AppengineAppsModulesVersionsPatch_598237, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsDelete_598214 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsDelete_598216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsDelete_598215(path: JsonNode;
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
  var valid_598217 = path.getOrDefault("versionsId")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "versionsId", valid_598217
  var valid_598218 = path.getOrDefault("modulesId")
  valid_598218 = validateParameter(valid_598218, JString, required = true,
                                 default = nil)
  if valid_598218 != nil:
    section.add "modulesId", valid_598218
  var valid_598219 = path.getOrDefault("appsId")
  valid_598219 = validateParameter(valid_598219, JString, required = true,
                                 default = nil)
  if valid_598219 != nil:
    section.add "appsId", valid_598219
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
  var valid_598220 = query.getOrDefault("upload_protocol")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "upload_protocol", valid_598220
  var valid_598221 = query.getOrDefault("fields")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "fields", valid_598221
  var valid_598222 = query.getOrDefault("quotaUser")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "quotaUser", valid_598222
  var valid_598223 = query.getOrDefault("alt")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = newJString("json"))
  if valid_598223 != nil:
    section.add "alt", valid_598223
  var valid_598224 = query.getOrDefault("oauth_token")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "oauth_token", valid_598224
  var valid_598225 = query.getOrDefault("callback")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "callback", valid_598225
  var valid_598226 = query.getOrDefault("access_token")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "access_token", valid_598226
  var valid_598227 = query.getOrDefault("uploadType")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "uploadType", valid_598227
  var valid_598228 = query.getOrDefault("key")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "key", valid_598228
  var valid_598229 = query.getOrDefault("$.xgafv")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = newJString("1"))
  if valid_598229 != nil:
    section.add "$.xgafv", valid_598229
  var valid_598230 = query.getOrDefault("prettyPrint")
  valid_598230 = validateParameter(valid_598230, JBool, required = false,
                                 default = newJBool(true))
  if valid_598230 != nil:
    section.add "prettyPrint", valid_598230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598231: Call_AppengineAppsModulesVersionsDelete_598214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing version.
  ## 
  let valid = call_598231.validator(path, query, header, formData, body)
  let scheme = call_598231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598231.url(scheme.get, call_598231.host, call_598231.base,
                         call_598231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598231, url, valid)

proc call*(call_598232: Call_AppengineAppsModulesVersionsDelete_598214;
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
  var path_598233 = newJObject()
  var query_598234 = newJObject()
  add(query_598234, "upload_protocol", newJString(uploadProtocol))
  add(query_598234, "fields", newJString(fields))
  add(query_598234, "quotaUser", newJString(quotaUser))
  add(path_598233, "versionsId", newJString(versionsId))
  add(query_598234, "alt", newJString(alt))
  add(query_598234, "oauth_token", newJString(oauthToken))
  add(query_598234, "callback", newJString(callback))
  add(query_598234, "access_token", newJString(accessToken))
  add(query_598234, "uploadType", newJString(uploadType))
  add(path_598233, "modulesId", newJString(modulesId))
  add(query_598234, "key", newJString(key))
  add(path_598233, "appsId", newJString(appsId))
  add(query_598234, "$.xgafv", newJString(Xgafv))
  add(query_598234, "prettyPrint", newJBool(prettyPrint))
  result = call_598232.call(path_598233, query_598234, nil, nil, nil)

var appengineAppsModulesVersionsDelete* = Call_AppengineAppsModulesVersionsDelete_598214(
    name: "appengineAppsModulesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}",
    validator: validate_AppengineAppsModulesVersionsDelete_598215, base: "/",
    url: url_AppengineAppsModulesVersionsDelete_598216, schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesList_598259 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsInstancesList_598261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsInstancesList_598260(path: JsonNode;
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
  var valid_598262 = path.getOrDefault("versionsId")
  valid_598262 = validateParameter(valid_598262, JString, required = true,
                                 default = nil)
  if valid_598262 != nil:
    section.add "versionsId", valid_598262
  var valid_598263 = path.getOrDefault("modulesId")
  valid_598263 = validateParameter(valid_598263, JString, required = true,
                                 default = nil)
  if valid_598263 != nil:
    section.add "modulesId", valid_598263
  var valid_598264 = path.getOrDefault("appsId")
  valid_598264 = validateParameter(valid_598264, JString, required = true,
                                 default = nil)
  if valid_598264 != nil:
    section.add "appsId", valid_598264
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
  var valid_598265 = query.getOrDefault("upload_protocol")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "upload_protocol", valid_598265
  var valid_598266 = query.getOrDefault("fields")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "fields", valid_598266
  var valid_598267 = query.getOrDefault("pageToken")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "pageToken", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("callback")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "callback", valid_598271
  var valid_598272 = query.getOrDefault("access_token")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "access_token", valid_598272
  var valid_598273 = query.getOrDefault("uploadType")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "uploadType", valid_598273
  var valid_598274 = query.getOrDefault("key")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "key", valid_598274
  var valid_598275 = query.getOrDefault("$.xgafv")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = newJString("1"))
  if valid_598275 != nil:
    section.add "$.xgafv", valid_598275
  var valid_598276 = query.getOrDefault("pageSize")
  valid_598276 = validateParameter(valid_598276, JInt, required = false, default = nil)
  if valid_598276 != nil:
    section.add "pageSize", valid_598276
  var valid_598277 = query.getOrDefault("prettyPrint")
  valid_598277 = validateParameter(valid_598277, JBool, required = false,
                                 default = newJBool(true))
  if valid_598277 != nil:
    section.add "prettyPrint", valid_598277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598278: Call_AppengineAppsModulesVersionsInstancesList_598259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_598278.validator(path, query, header, formData, body)
  let scheme = call_598278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598278.url(scheme.get, call_598278.host, call_598278.base,
                         call_598278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598278, url, valid)

proc call*(call_598279: Call_AppengineAppsModulesVersionsInstancesList_598259;
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
  var path_598280 = newJObject()
  var query_598281 = newJObject()
  add(query_598281, "upload_protocol", newJString(uploadProtocol))
  add(query_598281, "fields", newJString(fields))
  add(query_598281, "pageToken", newJString(pageToken))
  add(query_598281, "quotaUser", newJString(quotaUser))
  add(path_598280, "versionsId", newJString(versionsId))
  add(query_598281, "alt", newJString(alt))
  add(query_598281, "oauth_token", newJString(oauthToken))
  add(query_598281, "callback", newJString(callback))
  add(query_598281, "access_token", newJString(accessToken))
  add(query_598281, "uploadType", newJString(uploadType))
  add(path_598280, "modulesId", newJString(modulesId))
  add(query_598281, "key", newJString(key))
  add(path_598280, "appsId", newJString(appsId))
  add(query_598281, "$.xgafv", newJString(Xgafv))
  add(query_598281, "pageSize", newJInt(pageSize))
  add(query_598281, "prettyPrint", newJBool(prettyPrint))
  result = call_598279.call(path_598280, query_598281, nil, nil, nil)

var appengineAppsModulesVersionsInstancesList* = Call_AppengineAppsModulesVersionsInstancesList_598259(
    name: "appengineAppsModulesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsModulesVersionsInstancesList_598260,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesList_598261,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesGet_598282 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsInstancesGet_598284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsInstancesGet_598283(path: JsonNode;
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
  var valid_598285 = path.getOrDefault("versionsId")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "versionsId", valid_598285
  var valid_598286 = path.getOrDefault("instancesId")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "instancesId", valid_598286
  var valid_598287 = path.getOrDefault("modulesId")
  valid_598287 = validateParameter(valid_598287, JString, required = true,
                                 default = nil)
  if valid_598287 != nil:
    section.add "modulesId", valid_598287
  var valid_598288 = path.getOrDefault("appsId")
  valid_598288 = validateParameter(valid_598288, JString, required = true,
                                 default = nil)
  if valid_598288 != nil:
    section.add "appsId", valid_598288
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
  var valid_598289 = query.getOrDefault("upload_protocol")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "upload_protocol", valid_598289
  var valid_598290 = query.getOrDefault("fields")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "fields", valid_598290
  var valid_598291 = query.getOrDefault("quotaUser")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "quotaUser", valid_598291
  var valid_598292 = query.getOrDefault("alt")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("json"))
  if valid_598292 != nil:
    section.add "alt", valid_598292
  var valid_598293 = query.getOrDefault("oauth_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "oauth_token", valid_598293
  var valid_598294 = query.getOrDefault("callback")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "callback", valid_598294
  var valid_598295 = query.getOrDefault("access_token")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "access_token", valid_598295
  var valid_598296 = query.getOrDefault("uploadType")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = nil)
  if valid_598296 != nil:
    section.add "uploadType", valid_598296
  var valid_598297 = query.getOrDefault("key")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "key", valid_598297
  var valid_598298 = query.getOrDefault("$.xgafv")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = newJString("1"))
  if valid_598298 != nil:
    section.add "$.xgafv", valid_598298
  var valid_598299 = query.getOrDefault("prettyPrint")
  valid_598299 = validateParameter(valid_598299, JBool, required = false,
                                 default = newJBool(true))
  if valid_598299 != nil:
    section.add "prettyPrint", valid_598299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598300: Call_AppengineAppsModulesVersionsInstancesGet_598282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_598300.validator(path, query, header, formData, body)
  let scheme = call_598300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598300.url(scheme.get, call_598300.host, call_598300.base,
                         call_598300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598300, url, valid)

proc call*(call_598301: Call_AppengineAppsModulesVersionsInstancesGet_598282;
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
  var path_598302 = newJObject()
  var query_598303 = newJObject()
  add(query_598303, "upload_protocol", newJString(uploadProtocol))
  add(query_598303, "fields", newJString(fields))
  add(query_598303, "quotaUser", newJString(quotaUser))
  add(path_598302, "versionsId", newJString(versionsId))
  add(query_598303, "alt", newJString(alt))
  add(path_598302, "instancesId", newJString(instancesId))
  add(query_598303, "oauth_token", newJString(oauthToken))
  add(query_598303, "callback", newJString(callback))
  add(query_598303, "access_token", newJString(accessToken))
  add(query_598303, "uploadType", newJString(uploadType))
  add(path_598302, "modulesId", newJString(modulesId))
  add(query_598303, "key", newJString(key))
  add(path_598302, "appsId", newJString(appsId))
  add(query_598303, "$.xgafv", newJString(Xgafv))
  add(query_598303, "prettyPrint", newJBool(prettyPrint))
  result = call_598301.call(path_598302, query_598303, nil, nil, nil)

var appengineAppsModulesVersionsInstancesGet* = Call_AppengineAppsModulesVersionsInstancesGet_598282(
    name: "appengineAppsModulesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesGet_598283,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesGet_598284,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDelete_598304 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsInstancesDelete_598306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsInstancesDelete_598305(path: JsonNode;
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
  var valid_598307 = path.getOrDefault("versionsId")
  valid_598307 = validateParameter(valid_598307, JString, required = true,
                                 default = nil)
  if valid_598307 != nil:
    section.add "versionsId", valid_598307
  var valid_598308 = path.getOrDefault("instancesId")
  valid_598308 = validateParameter(valid_598308, JString, required = true,
                                 default = nil)
  if valid_598308 != nil:
    section.add "instancesId", valid_598308
  var valid_598309 = path.getOrDefault("modulesId")
  valid_598309 = validateParameter(valid_598309, JString, required = true,
                                 default = nil)
  if valid_598309 != nil:
    section.add "modulesId", valid_598309
  var valid_598310 = path.getOrDefault("appsId")
  valid_598310 = validateParameter(valid_598310, JString, required = true,
                                 default = nil)
  if valid_598310 != nil:
    section.add "appsId", valid_598310
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
  var valid_598311 = query.getOrDefault("upload_protocol")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "upload_protocol", valid_598311
  var valid_598312 = query.getOrDefault("fields")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "fields", valid_598312
  var valid_598313 = query.getOrDefault("quotaUser")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "quotaUser", valid_598313
  var valid_598314 = query.getOrDefault("alt")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = newJString("json"))
  if valid_598314 != nil:
    section.add "alt", valid_598314
  var valid_598315 = query.getOrDefault("oauth_token")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "oauth_token", valid_598315
  var valid_598316 = query.getOrDefault("callback")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "callback", valid_598316
  var valid_598317 = query.getOrDefault("access_token")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "access_token", valid_598317
  var valid_598318 = query.getOrDefault("uploadType")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "uploadType", valid_598318
  var valid_598319 = query.getOrDefault("key")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "key", valid_598319
  var valid_598320 = query.getOrDefault("$.xgafv")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = newJString("1"))
  if valid_598320 != nil:
    section.add "$.xgafv", valid_598320
  var valid_598321 = query.getOrDefault("prettyPrint")
  valid_598321 = validateParameter(valid_598321, JBool, required = false,
                                 default = newJBool(true))
  if valid_598321 != nil:
    section.add "prettyPrint", valid_598321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598322: Call_AppengineAppsModulesVersionsInstancesDelete_598304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_598322.validator(path, query, header, formData, body)
  let scheme = call_598322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598322.url(scheme.get, call_598322.host, call_598322.base,
                         call_598322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598322, url, valid)

proc call*(call_598323: Call_AppengineAppsModulesVersionsInstancesDelete_598304;
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
  var path_598324 = newJObject()
  var query_598325 = newJObject()
  add(query_598325, "upload_protocol", newJString(uploadProtocol))
  add(query_598325, "fields", newJString(fields))
  add(query_598325, "quotaUser", newJString(quotaUser))
  add(path_598324, "versionsId", newJString(versionsId))
  add(query_598325, "alt", newJString(alt))
  add(path_598324, "instancesId", newJString(instancesId))
  add(query_598325, "oauth_token", newJString(oauthToken))
  add(query_598325, "callback", newJString(callback))
  add(query_598325, "access_token", newJString(accessToken))
  add(query_598325, "uploadType", newJString(uploadType))
  add(path_598324, "modulesId", newJString(modulesId))
  add(query_598325, "key", newJString(key))
  add(path_598324, "appsId", newJString(appsId))
  add(query_598325, "$.xgafv", newJString(Xgafv))
  add(query_598325, "prettyPrint", newJBool(prettyPrint))
  result = call_598323.call(path_598324, query_598325, nil, nil, nil)

var appengineAppsModulesVersionsInstancesDelete* = Call_AppengineAppsModulesVersionsInstancesDelete_598304(
    name: "appengineAppsModulesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsModulesVersionsInstancesDelete_598305,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDelete_598306,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsModulesVersionsInstancesDebug_598326 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsModulesVersionsInstancesDebug_598328(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsModulesVersionsInstancesDebug_598327(path: JsonNode;
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
  var valid_598329 = path.getOrDefault("versionsId")
  valid_598329 = validateParameter(valid_598329, JString, required = true,
                                 default = nil)
  if valid_598329 != nil:
    section.add "versionsId", valid_598329
  var valid_598330 = path.getOrDefault("instancesId")
  valid_598330 = validateParameter(valid_598330, JString, required = true,
                                 default = nil)
  if valid_598330 != nil:
    section.add "instancesId", valid_598330
  var valid_598331 = path.getOrDefault("modulesId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "modulesId", valid_598331
  var valid_598332 = path.getOrDefault("appsId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "appsId", valid_598332
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
  var valid_598333 = query.getOrDefault("upload_protocol")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "upload_protocol", valid_598333
  var valid_598334 = query.getOrDefault("fields")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "fields", valid_598334
  var valid_598335 = query.getOrDefault("quotaUser")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "quotaUser", valid_598335
  var valid_598336 = query.getOrDefault("alt")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = newJString("json"))
  if valid_598336 != nil:
    section.add "alt", valid_598336
  var valid_598337 = query.getOrDefault("oauth_token")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "oauth_token", valid_598337
  var valid_598338 = query.getOrDefault("callback")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "callback", valid_598338
  var valid_598339 = query.getOrDefault("access_token")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "access_token", valid_598339
  var valid_598340 = query.getOrDefault("uploadType")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "uploadType", valid_598340
  var valid_598341 = query.getOrDefault("key")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "key", valid_598341
  var valid_598342 = query.getOrDefault("$.xgafv")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = newJString("1"))
  if valid_598342 != nil:
    section.add "$.xgafv", valid_598342
  var valid_598343 = query.getOrDefault("prettyPrint")
  valid_598343 = validateParameter(valid_598343, JBool, required = false,
                                 default = newJBool(true))
  if valid_598343 != nil:
    section.add "prettyPrint", valid_598343
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

proc call*(call_598345: Call_AppengineAppsModulesVersionsInstancesDebug_598326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_598345.validator(path, query, header, formData, body)
  let scheme = call_598345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598345.url(scheme.get, call_598345.host, call_598345.base,
                         call_598345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598345, url, valid)

proc call*(call_598346: Call_AppengineAppsModulesVersionsInstancesDebug_598326;
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
  var path_598347 = newJObject()
  var query_598348 = newJObject()
  var body_598349 = newJObject()
  add(query_598348, "upload_protocol", newJString(uploadProtocol))
  add(query_598348, "fields", newJString(fields))
  add(query_598348, "quotaUser", newJString(quotaUser))
  add(path_598347, "versionsId", newJString(versionsId))
  add(query_598348, "alt", newJString(alt))
  add(path_598347, "instancesId", newJString(instancesId))
  add(query_598348, "oauth_token", newJString(oauthToken))
  add(query_598348, "callback", newJString(callback))
  add(query_598348, "access_token", newJString(accessToken))
  add(query_598348, "uploadType", newJString(uploadType))
  add(path_598347, "modulesId", newJString(modulesId))
  add(query_598348, "key", newJString(key))
  add(path_598347, "appsId", newJString(appsId))
  add(query_598348, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598349 = body
  add(query_598348, "prettyPrint", newJBool(prettyPrint))
  result = call_598346.call(path_598347, query_598348, nil, nil, body_598349)

var appengineAppsModulesVersionsInstancesDebug* = Call_AppengineAppsModulesVersionsInstancesDebug_598326(
    name: "appengineAppsModulesVersionsInstancesDebug", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/modules/{modulesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsModulesVersionsInstancesDebug_598327,
    base: "/", url: url_AppengineAppsModulesVersionsInstancesDebug_598328,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_598350 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsList_598352(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsList_598351(path: JsonNode; query: JsonNode;
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
  var valid_598353 = path.getOrDefault("appsId")
  valid_598353 = validateParameter(valid_598353, JString, required = true,
                                 default = nil)
  if valid_598353 != nil:
    section.add "appsId", valid_598353
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
  var valid_598354 = query.getOrDefault("upload_protocol")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "upload_protocol", valid_598354
  var valid_598355 = query.getOrDefault("fields")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "fields", valid_598355
  var valid_598356 = query.getOrDefault("pageToken")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "pageToken", valid_598356
  var valid_598357 = query.getOrDefault("quotaUser")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "quotaUser", valid_598357
  var valid_598358 = query.getOrDefault("alt")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = newJString("json"))
  if valid_598358 != nil:
    section.add "alt", valid_598358
  var valid_598359 = query.getOrDefault("oauth_token")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "oauth_token", valid_598359
  var valid_598360 = query.getOrDefault("callback")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "callback", valid_598360
  var valid_598361 = query.getOrDefault("access_token")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "access_token", valid_598361
  var valid_598362 = query.getOrDefault("uploadType")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "uploadType", valid_598362
  var valid_598363 = query.getOrDefault("key")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = nil)
  if valid_598363 != nil:
    section.add "key", valid_598363
  var valid_598364 = query.getOrDefault("$.xgafv")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = newJString("1"))
  if valid_598364 != nil:
    section.add "$.xgafv", valid_598364
  var valid_598365 = query.getOrDefault("pageSize")
  valid_598365 = validateParameter(valid_598365, JInt, required = false, default = nil)
  if valid_598365 != nil:
    section.add "pageSize", valid_598365
  var valid_598366 = query.getOrDefault("prettyPrint")
  valid_598366 = validateParameter(valid_598366, JBool, required = false,
                                 default = newJBool(true))
  if valid_598366 != nil:
    section.add "prettyPrint", valid_598366
  var valid_598367 = query.getOrDefault("filter")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "filter", valid_598367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598368: Call_AppengineAppsOperationsList_598350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_598368.validator(path, query, header, formData, body)
  let scheme = call_598368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598368.url(scheme.get, call_598368.host, call_598368.base,
                         call_598368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598368, url, valid)

proc call*(call_598369: Call_AppengineAppsOperationsList_598350; appsId: string;
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
  var path_598370 = newJObject()
  var query_598371 = newJObject()
  add(query_598371, "upload_protocol", newJString(uploadProtocol))
  add(query_598371, "fields", newJString(fields))
  add(query_598371, "pageToken", newJString(pageToken))
  add(query_598371, "quotaUser", newJString(quotaUser))
  add(query_598371, "alt", newJString(alt))
  add(query_598371, "oauth_token", newJString(oauthToken))
  add(query_598371, "callback", newJString(callback))
  add(query_598371, "access_token", newJString(accessToken))
  add(query_598371, "uploadType", newJString(uploadType))
  add(query_598371, "key", newJString(key))
  add(path_598370, "appsId", newJString(appsId))
  add(query_598371, "$.xgafv", newJString(Xgafv))
  add(query_598371, "pageSize", newJInt(pageSize))
  add(query_598371, "prettyPrint", newJBool(prettyPrint))
  add(query_598371, "filter", newJString(filter))
  result = call_598369.call(path_598370, query_598371, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_598350(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta4/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_598351, base: "/",
    url: url_AppengineAppsOperationsList_598352, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_598372 = ref object of OpenApiRestCall_597421
proc url_AppengineAppsOperationsGet_598374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppengineAppsOperationsGet_598373(path: JsonNode; query: JsonNode;
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
  var valid_598375 = path.getOrDefault("appsId")
  valid_598375 = validateParameter(valid_598375, JString, required = true,
                                 default = nil)
  if valid_598375 != nil:
    section.add "appsId", valid_598375
  var valid_598376 = path.getOrDefault("operationsId")
  valid_598376 = validateParameter(valid_598376, JString, required = true,
                                 default = nil)
  if valid_598376 != nil:
    section.add "operationsId", valid_598376
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
  var valid_598377 = query.getOrDefault("upload_protocol")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "upload_protocol", valid_598377
  var valid_598378 = query.getOrDefault("fields")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = nil)
  if valid_598378 != nil:
    section.add "fields", valid_598378
  var valid_598379 = query.getOrDefault("quotaUser")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = nil)
  if valid_598379 != nil:
    section.add "quotaUser", valid_598379
  var valid_598380 = query.getOrDefault("alt")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = newJString("json"))
  if valid_598380 != nil:
    section.add "alt", valid_598380
  var valid_598381 = query.getOrDefault("oauth_token")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "oauth_token", valid_598381
  var valid_598382 = query.getOrDefault("callback")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "callback", valid_598382
  var valid_598383 = query.getOrDefault("access_token")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "access_token", valid_598383
  var valid_598384 = query.getOrDefault("uploadType")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "uploadType", valid_598384
  var valid_598385 = query.getOrDefault("key")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "key", valid_598385
  var valid_598386 = query.getOrDefault("$.xgafv")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = newJString("1"))
  if valid_598386 != nil:
    section.add "$.xgafv", valid_598386
  var valid_598387 = query.getOrDefault("prettyPrint")
  valid_598387 = validateParameter(valid_598387, JBool, required = false,
                                 default = newJBool(true))
  if valid_598387 != nil:
    section.add "prettyPrint", valid_598387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598388: Call_AppengineAppsOperationsGet_598372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_598388.validator(path, query, header, formData, body)
  let scheme = call_598388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598388.url(scheme.get, call_598388.host, call_598388.base,
                         call_598388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598388, url, valid)

proc call*(call_598389: Call_AppengineAppsOperationsGet_598372; appsId: string;
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
  var path_598390 = newJObject()
  var query_598391 = newJObject()
  add(query_598391, "upload_protocol", newJString(uploadProtocol))
  add(query_598391, "fields", newJString(fields))
  add(query_598391, "quotaUser", newJString(quotaUser))
  add(query_598391, "alt", newJString(alt))
  add(query_598391, "oauth_token", newJString(oauthToken))
  add(query_598391, "callback", newJString(callback))
  add(query_598391, "access_token", newJString(accessToken))
  add(query_598391, "uploadType", newJString(uploadType))
  add(query_598391, "key", newJString(key))
  add(path_598390, "appsId", newJString(appsId))
  add(query_598391, "$.xgafv", newJString(Xgafv))
  add(path_598390, "operationsId", newJString(operationsId))
  add(query_598391, "prettyPrint", newJBool(prettyPrint))
  result = call_598389.call(path_598390, query_598391, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_598372(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta4/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_598373, base: "/",
    url: url_AppengineAppsOperationsGet_598374, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
