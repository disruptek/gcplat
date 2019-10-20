
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_AppengineAppsCreate_578619 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsCreate_578621(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppengineAppsCreate_578620(path: JsonNode; query: JsonNode;
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
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("callback")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "callback", valid_578753
  var valid_578754 = query.getOrDefault("fields")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "fields", valid_578754
  var valid_578755 = query.getOrDefault("access_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "access_token", valid_578755
  var valid_578756 = query.getOrDefault("upload_protocol")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "upload_protocol", valid_578756
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

proc call*(call_578780: Call_AppengineAppsCreate_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_AppengineAppsCreate_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsCreate
  ## Creates an App Engine application for a Google Cloud Platform project. Required fields:
  ## id - The ID of the target Cloud Platform project.
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/standard/python/console/).
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
  var query_578852 = newJObject()
  var body_578854 = newJObject()
  add(query_578852, "key", newJString(key))
  add(query_578852, "prettyPrint", newJBool(prettyPrint))
  add(query_578852, "oauth_token", newJString(oauthToken))
  add(query_578852, "$.xgafv", newJString(Xgafv))
  add(query_578852, "alt", newJString(alt))
  add(query_578852, "uploadType", newJString(uploadType))
  add(query_578852, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578854 = body
  add(query_578852, "callback", newJString(callback))
  add(query_578852, "fields", newJString(fields))
  add(query_578852, "access_token", newJString(accessToken))
  add(query_578852, "upload_protocol", newJString(uploadProtocol))
  result = call_578851.call(nil, query_578852, nil, nil, body_578854)

var appengineAppsCreate* = Call_AppengineAppsCreate_578619(
    name: "appengineAppsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps",
    validator: validate_AppengineAppsCreate_578620, base: "/",
    url: url_AppengineAppsCreate_578621, schemes: {Scheme.Https})
type
  Call_AppengineAppsGet_578893 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsGet_578895(protocol: Scheme; host: string; base: string;
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

proc validate_AppengineAppsGet_578894(path: JsonNode; query: JsonNode;
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
  var valid_578910 = path.getOrDefault("appsId")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "appsId", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_AppengineAppsGet_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_AppengineAppsGet_578893; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsGet
  ## Gets information about an application.
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
  ##         : Part of `name`. Name of the Application resource to get. Example: apps/myapp.
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
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(path_578924, "appsId", newJString(appsId))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_578893(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}", validator: validate_AppengineAppsGet_578894,
    base: "/", url: url_AppengineAppsGet_578895, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_578926 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsPatch_578928(protocol: Scheme; host: string; base: string;
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

proc validate_AppengineAppsPatch_578927(path: JsonNode; query: JsonNode;
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
  var valid_578929 = path.getOrDefault("appsId")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "appsId", valid_578929
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
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("updateMask")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "updateMask", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
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

proc call*(call_578943: Call_AppengineAppsPatch_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_AppengineAppsPatch_578926; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsPatch
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain - Google authentication domain for controlling user access to the application.
  ## default_cookie_expiration - Cookie expiration policy for the application.
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
  ##         : Part of `name`. Name of the Application resource to update. Example: apps/myapp.
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
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(path_578945, "appsId", newJString(appsId))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(query_578946, "updateMask", newJString(updateMask))
  if body != nil:
    body_578947 = body
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var appengineAppsPatch* = Call_AppengineAppsPatch_578926(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}",
    validator: validate_AppengineAppsPatch_578927, base: "/",
    url: url_AppengineAppsPatch_578928, schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesCreate_578970 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedCertificatesCreate_578972(protocol: Scheme;
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

proc validate_AppengineAppsAuthorizedCertificatesCreate_578971(path: JsonNode;
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
  var valid_578973 = path.getOrDefault("appsId")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "appsId", valid_578973
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
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("$.xgafv")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("1"))
  if valid_578977 != nil:
    section.add "$.xgafv", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("uploadType")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "uploadType", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("callback")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "callback", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  var valid_578983 = query.getOrDefault("access_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "access_token", valid_578983
  var valid_578984 = query.getOrDefault("upload_protocol")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "upload_protocol", valid_578984
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

proc call*(call_578986: Call_AppengineAppsAuthorizedCertificatesCreate_578970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads the specified SSL certificate.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_AppengineAppsAuthorizedCertificatesCreate_578970;
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
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  var body_578990 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "$.xgafv", newJString(Xgafv))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "uploadType", newJString(uploadType))
  add(path_578988, "appsId", newJString(appsId))
  add(query_578989, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578990 = body
  add(query_578989, "callback", newJString(callback))
  add(query_578989, "fields", newJString(fields))
  add(query_578989, "access_token", newJString(accessToken))
  add(query_578989, "upload_protocol", newJString(uploadProtocol))
  result = call_578987.call(path_578988, query_578989, nil, nil, body_578990)

var appengineAppsAuthorizedCertificatesCreate* = Call_AppengineAppsAuthorizedCertificatesCreate_578970(
    name: "appengineAppsAuthorizedCertificatesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesCreate_578971,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesCreate_578972,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesList_578948 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedCertificatesList_578950(protocol: Scheme;
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

proc validate_AppengineAppsAuthorizedCertificatesList_578949(path: JsonNode;
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
  var valid_578951 = path.getOrDefault("appsId")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "appsId", valid_578951
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
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("pageSize")
  valid_578956 = validateParameter(valid_578956, JInt, required = false, default = nil)
  if valid_578956 != nil:
    section.add "pageSize", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("uploadType")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "uploadType", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("pageToken")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "pageToken", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  var valid_578965 = query.getOrDefault("view")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_578965 != nil:
    section.add "view", valid_578965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578966: Call_AppengineAppsAuthorizedCertificatesList_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all SSL certificates the user is authorized to administer.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_AppengineAppsAuthorizedCertificatesList_578948;
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
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "pageSize", newJInt(pageSize))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "uploadType", newJString(uploadType))
  add(path_578968, "appsId", newJString(appsId))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(query_578969, "pageToken", newJString(pageToken))
  add(query_578969, "callback", newJString(callback))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "access_token", newJString(accessToken))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  add(query_578969, "view", newJString(view))
  result = call_578967.call(path_578968, query_578969, nil, nil, nil)

var appengineAppsAuthorizedCertificatesList* = Call_AppengineAppsAuthorizedCertificatesList_578948(
    name: "appengineAppsAuthorizedCertificatesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedCertificates",
    validator: validate_AppengineAppsAuthorizedCertificatesList_578949, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesList_578950,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesGet_578991 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedCertificatesGet_578993(protocol: Scheme;
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

proc validate_AppengineAppsAuthorizedCertificatesGet_578992(path: JsonNode;
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
  var valid_578994 = path.getOrDefault("appsId")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "appsId", valid_578994
  var valid_578995 = path.getOrDefault("authorizedCertificatesId")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "authorizedCertificatesId", valid_578995
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
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("$.xgafv")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("1"))
  if valid_578999 != nil:
    section.add "$.xgafv", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("uploadType")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "uploadType", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("callback")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "callback", valid_579003
  var valid_579004 = query.getOrDefault("fields")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "fields", valid_579004
  var valid_579005 = query.getOrDefault("access_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "access_token", valid_579005
  var valid_579006 = query.getOrDefault("upload_protocol")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "upload_protocol", valid_579006
  var valid_579007 = query.getOrDefault("view")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("BASIC_CERTIFICATE"))
  if valid_579007 != nil:
    section.add "view", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_AppengineAppsAuthorizedCertificatesGet_578991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified SSL certificate.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_AppengineAppsAuthorizedCertificatesGet_578991;
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
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "$.xgafv", newJString(Xgafv))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "uploadType", newJString(uploadType))
  add(path_579010, "appsId", newJString(appsId))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(query_579011, "callback", newJString(callback))
  add(path_579010, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "access_token", newJString(accessToken))
  add(query_579011, "upload_protocol", newJString(uploadProtocol))
  add(query_579011, "view", newJString(view))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var appengineAppsAuthorizedCertificatesGet* = Call_AppengineAppsAuthorizedCertificatesGet_578991(
    name: "appengineAppsAuthorizedCertificatesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesGet_578992, base: "/",
    url: url_AppengineAppsAuthorizedCertificatesGet_578993,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesPatch_579032 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedCertificatesPatch_579034(protocol: Scheme;
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

proc validate_AppengineAppsAuthorizedCertificatesPatch_579033(path: JsonNode;
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
  var valid_579035 = path.getOrDefault("appsId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "appsId", valid_579035
  var valid_579036 = path.getOrDefault("authorizedCertificatesId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "authorizedCertificatesId", valid_579036
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
  var valid_579037 = query.getOrDefault("key")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "key", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("$.xgafv")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("1"))
  if valid_579040 != nil:
    section.add "$.xgafv", valid_579040
  var valid_579041 = query.getOrDefault("alt")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("json"))
  if valid_579041 != nil:
    section.add "alt", valid_579041
  var valid_579042 = query.getOrDefault("uploadType")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "uploadType", valid_579042
  var valid_579043 = query.getOrDefault("quotaUser")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "quotaUser", valid_579043
  var valid_579044 = query.getOrDefault("updateMask")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "updateMask", valid_579044
  var valid_579045 = query.getOrDefault("callback")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "callback", valid_579045
  var valid_579046 = query.getOrDefault("fields")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "fields", valid_579046
  var valid_579047 = query.getOrDefault("access_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "access_token", valid_579047
  var valid_579048 = query.getOrDefault("upload_protocol")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "upload_protocol", valid_579048
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

proc call*(call_579050: Call_AppengineAppsAuthorizedCertificatesPatch_579032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified SSL certificate. To renew a certificate and maintain its existing domain mappings, update certificate_data with a new certificate. The new certificate must be applicable to the same domains as the original certificate. The certificate display_name may also be updated.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_AppengineAppsAuthorizedCertificatesPatch_579032;
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
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  var body_579054 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "$.xgafv", newJString(Xgafv))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "uploadType", newJString(uploadType))
  add(path_579052, "appsId", newJString(appsId))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(query_579053, "updateMask", newJString(updateMask))
  if body != nil:
    body_579054 = body
  add(query_579053, "callback", newJString(callback))
  add(path_579052, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, body_579054)

var appengineAppsAuthorizedCertificatesPatch* = Call_AppengineAppsAuthorizedCertificatesPatch_579032(
    name: "appengineAppsAuthorizedCertificatesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesPatch_579033,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesPatch_579034,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedCertificatesDelete_579012 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedCertificatesDelete_579014(protocol: Scheme;
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

proc validate_AppengineAppsAuthorizedCertificatesDelete_579013(path: JsonNode;
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
  var valid_579015 = path.getOrDefault("appsId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "appsId", valid_579015
  var valid_579016 = path.getOrDefault("authorizedCertificatesId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "authorizedCertificatesId", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("$.xgafv")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("1"))
  if valid_579020 != nil:
    section.add "$.xgafv", valid_579020
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("uploadType")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "uploadType", valid_579022
  var valid_579023 = query.getOrDefault("quotaUser")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "quotaUser", valid_579023
  var valid_579024 = query.getOrDefault("callback")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "callback", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("access_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "access_token", valid_579026
  var valid_579027 = query.getOrDefault("upload_protocol")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "upload_protocol", valid_579027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_AppengineAppsAuthorizedCertificatesDelete_579012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified SSL certificate.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_AppengineAppsAuthorizedCertificatesDelete_579012;
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
  var path_579030 = newJObject()
  var query_579031 = newJObject()
  add(query_579031, "key", newJString(key))
  add(query_579031, "prettyPrint", newJBool(prettyPrint))
  add(query_579031, "oauth_token", newJString(oauthToken))
  add(query_579031, "$.xgafv", newJString(Xgafv))
  add(query_579031, "alt", newJString(alt))
  add(query_579031, "uploadType", newJString(uploadType))
  add(path_579030, "appsId", newJString(appsId))
  add(query_579031, "quotaUser", newJString(quotaUser))
  add(query_579031, "callback", newJString(callback))
  add(path_579030, "authorizedCertificatesId",
      newJString(authorizedCertificatesId))
  add(query_579031, "fields", newJString(fields))
  add(query_579031, "access_token", newJString(accessToken))
  add(query_579031, "upload_protocol", newJString(uploadProtocol))
  result = call_579029.call(path_579030, query_579031, nil, nil, nil)

var appengineAppsAuthorizedCertificatesDelete* = Call_AppengineAppsAuthorizedCertificatesDelete_579012(
    name: "appengineAppsAuthorizedCertificatesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/authorizedCertificates/{authorizedCertificatesId}",
    validator: validate_AppengineAppsAuthorizedCertificatesDelete_579013,
    base: "/", url: url_AppengineAppsAuthorizedCertificatesDelete_579014,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsAuthorizedDomainsList_579055 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsAuthorizedDomainsList_579057(protocol: Scheme; host: string;
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

proc validate_AppengineAppsAuthorizedDomainsList_579056(path: JsonNode;
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
  var valid_579058 = path.getOrDefault("appsId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "appsId", valid_579058
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
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("$.xgafv")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("1"))
  if valid_579062 != nil:
    section.add "$.xgafv", valid_579062
  var valid_579063 = query.getOrDefault("pageSize")
  valid_579063 = validateParameter(valid_579063, JInt, required = false, default = nil)
  if valid_579063 != nil:
    section.add "pageSize", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("pageToken")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "pageToken", valid_579067
  var valid_579068 = query.getOrDefault("callback")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "callback", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  var valid_579070 = query.getOrDefault("access_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "access_token", valid_579070
  var valid_579071 = query.getOrDefault("upload_protocol")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "upload_protocol", valid_579071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579072: Call_AppengineAppsAuthorizedDomainsList_579055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all domains the user is authorized to administer.
  ## 
  let valid = call_579072.validator(path, query, header, formData, body)
  let scheme = call_579072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579072.url(scheme.get, call_579072.host, call_579072.base,
                         call_579072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579072, url, valid)

proc call*(call_579073: Call_AppengineAppsAuthorizedDomainsList_579055;
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
  var path_579074 = newJObject()
  var query_579075 = newJObject()
  add(query_579075, "key", newJString(key))
  add(query_579075, "prettyPrint", newJBool(prettyPrint))
  add(query_579075, "oauth_token", newJString(oauthToken))
  add(query_579075, "$.xgafv", newJString(Xgafv))
  add(query_579075, "pageSize", newJInt(pageSize))
  add(query_579075, "alt", newJString(alt))
  add(query_579075, "uploadType", newJString(uploadType))
  add(path_579074, "appsId", newJString(appsId))
  add(query_579075, "quotaUser", newJString(quotaUser))
  add(query_579075, "pageToken", newJString(pageToken))
  add(query_579075, "callback", newJString(callback))
  add(query_579075, "fields", newJString(fields))
  add(query_579075, "access_token", newJString(accessToken))
  add(query_579075, "upload_protocol", newJString(uploadProtocol))
  result = call_579073.call(path_579074, query_579075, nil, nil, nil)

var appengineAppsAuthorizedDomainsList* = Call_AppengineAppsAuthorizedDomainsList_579055(
    name: "appengineAppsAuthorizedDomainsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/authorizedDomains",
    validator: validate_AppengineAppsAuthorizedDomainsList_579056, base: "/",
    url: url_AppengineAppsAuthorizedDomainsList_579057, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsCreate_579097 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsDomainMappingsCreate_579099(protocol: Scheme; host: string;
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

proc validate_AppengineAppsDomainMappingsCreate_579098(path: JsonNode;
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
  var valid_579100 = path.getOrDefault("appsId")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "appsId", valid_579100
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
  section = newJObject()
  var valid_579101 = query.getOrDefault("key")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "key", valid_579101
  var valid_579102 = query.getOrDefault("prettyPrint")
  valid_579102 = validateParameter(valid_579102, JBool, required = false,
                                 default = newJBool(true))
  if valid_579102 != nil:
    section.add "prettyPrint", valid_579102
  var valid_579103 = query.getOrDefault("oauth_token")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "oauth_token", valid_579103
  var valid_579104 = query.getOrDefault("$.xgafv")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("1"))
  if valid_579104 != nil:
    section.add "$.xgafv", valid_579104
  var valid_579105 = query.getOrDefault("alt")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("json"))
  if valid_579105 != nil:
    section.add "alt", valid_579105
  var valid_579106 = query.getOrDefault("uploadType")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "uploadType", valid_579106
  var valid_579107 = query.getOrDefault("quotaUser")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "quotaUser", valid_579107
  var valid_579108 = query.getOrDefault("overrideStrategy")
  valid_579108 = validateParameter(valid_579108, JString, required = false, default = newJString(
      "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY"))
  if valid_579108 != nil:
    section.add "overrideStrategy", valid_579108
  var valid_579109 = query.getOrDefault("callback")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "callback", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  var valid_579111 = query.getOrDefault("access_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "access_token", valid_579111
  var valid_579112 = query.getOrDefault("upload_protocol")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "upload_protocol", valid_579112
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

proc call*(call_579114: Call_AppengineAppsDomainMappingsCreate_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Maps a domain to an application. A user must be authorized to administer a domain in order to map it to an application. For a list of available authorized domains, see AuthorizedDomains.ListAuthorizedDomains.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_AppengineAppsDomainMappingsCreate_579097;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          overrideStrategy: string = "UNSPECIFIED_DOMAIN_OVERRIDE_STRATEGY";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  var body_579118 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(query_579117, "$.xgafv", newJString(Xgafv))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "uploadType", newJString(uploadType))
  add(path_579116, "appsId", newJString(appsId))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(query_579117, "overrideStrategy", newJString(overrideStrategy))
  if body != nil:
    body_579118 = body
  add(query_579117, "callback", newJString(callback))
  add(query_579117, "fields", newJString(fields))
  add(query_579117, "access_token", newJString(accessToken))
  add(query_579117, "upload_protocol", newJString(uploadProtocol))
  result = call_579115.call(path_579116, query_579117, nil, nil, body_579118)

var appengineAppsDomainMappingsCreate* = Call_AppengineAppsDomainMappingsCreate_579097(
    name: "appengineAppsDomainMappingsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsCreate_579098, base: "/",
    url: url_AppengineAppsDomainMappingsCreate_579099, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsList_579076 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsDomainMappingsList_579078(protocol: Scheme; host: string;
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

proc validate_AppengineAppsDomainMappingsList_579077(path: JsonNode;
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
  var valid_579079 = path.getOrDefault("appsId")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "appsId", valid_579079
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
  var valid_579080 = query.getOrDefault("key")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "key", valid_579080
  var valid_579081 = query.getOrDefault("prettyPrint")
  valid_579081 = validateParameter(valid_579081, JBool, required = false,
                                 default = newJBool(true))
  if valid_579081 != nil:
    section.add "prettyPrint", valid_579081
  var valid_579082 = query.getOrDefault("oauth_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "oauth_token", valid_579082
  var valid_579083 = query.getOrDefault("$.xgafv")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("1"))
  if valid_579083 != nil:
    section.add "$.xgafv", valid_579083
  var valid_579084 = query.getOrDefault("pageSize")
  valid_579084 = validateParameter(valid_579084, JInt, required = false, default = nil)
  if valid_579084 != nil:
    section.add "pageSize", valid_579084
  var valid_579085 = query.getOrDefault("alt")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("json"))
  if valid_579085 != nil:
    section.add "alt", valid_579085
  var valid_579086 = query.getOrDefault("uploadType")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "uploadType", valid_579086
  var valid_579087 = query.getOrDefault("quotaUser")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "quotaUser", valid_579087
  var valid_579088 = query.getOrDefault("pageToken")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "pageToken", valid_579088
  var valid_579089 = query.getOrDefault("callback")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "callback", valid_579089
  var valid_579090 = query.getOrDefault("fields")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "fields", valid_579090
  var valid_579091 = query.getOrDefault("access_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "access_token", valid_579091
  var valid_579092 = query.getOrDefault("upload_protocol")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "upload_protocol", valid_579092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579093: Call_AppengineAppsDomainMappingsList_579076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the domain mappings on an application.
  ## 
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_AppengineAppsDomainMappingsList_579076;
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
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(query_579096, "$.xgafv", newJString(Xgafv))
  add(query_579096, "pageSize", newJInt(pageSize))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "uploadType", newJString(uploadType))
  add(path_579095, "appsId", newJString(appsId))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(query_579096, "pageToken", newJString(pageToken))
  add(query_579096, "callback", newJString(callback))
  add(query_579096, "fields", newJString(fields))
  add(query_579096, "access_token", newJString(accessToken))
  add(query_579096, "upload_protocol", newJString(uploadProtocol))
  result = call_579094.call(path_579095, query_579096, nil, nil, nil)

var appengineAppsDomainMappingsList* = Call_AppengineAppsDomainMappingsList_579076(
    name: "appengineAppsDomainMappingsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/domainMappings",
    validator: validate_AppengineAppsDomainMappingsList_579077, base: "/",
    url: url_AppengineAppsDomainMappingsList_579078, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsGet_579119 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsDomainMappingsGet_579121(protocol: Scheme; host: string;
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

proc validate_AppengineAppsDomainMappingsGet_579120(path: JsonNode;
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
  var valid_579122 = path.getOrDefault("domainMappingsId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "domainMappingsId", valid_579122
  var valid_579123 = path.getOrDefault("appsId")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "appsId", valid_579123
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
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("$.xgafv")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("1"))
  if valid_579127 != nil:
    section.add "$.xgafv", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("uploadType")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "uploadType", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("callback")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "callback", valid_579131
  var valid_579132 = query.getOrDefault("fields")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "fields", valid_579132
  var valid_579133 = query.getOrDefault("access_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "access_token", valid_579133
  var valid_579134 = query.getOrDefault("upload_protocol")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "upload_protocol", valid_579134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579135: Call_AppengineAppsDomainMappingsGet_579119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified domain mapping.
  ## 
  let valid = call_579135.validator(path, query, header, formData, body)
  let scheme = call_579135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579135.url(scheme.get, call_579135.host, call_579135.base,
                         call_579135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579135, url, valid)

proc call*(call_579136: Call_AppengineAppsDomainMappingsGet_579119;
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
  var path_579137 = newJObject()
  var query_579138 = newJObject()
  add(query_579138, "key", newJString(key))
  add(query_579138, "prettyPrint", newJBool(prettyPrint))
  add(query_579138, "oauth_token", newJString(oauthToken))
  add(query_579138, "$.xgafv", newJString(Xgafv))
  add(path_579137, "domainMappingsId", newJString(domainMappingsId))
  add(query_579138, "alt", newJString(alt))
  add(query_579138, "uploadType", newJString(uploadType))
  add(path_579137, "appsId", newJString(appsId))
  add(query_579138, "quotaUser", newJString(quotaUser))
  add(query_579138, "callback", newJString(callback))
  add(query_579138, "fields", newJString(fields))
  add(query_579138, "access_token", newJString(accessToken))
  add(query_579138, "upload_protocol", newJString(uploadProtocol))
  result = call_579136.call(path_579137, query_579138, nil, nil, nil)

var appengineAppsDomainMappingsGet* = Call_AppengineAppsDomainMappingsGet_579119(
    name: "appengineAppsDomainMappingsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsGet_579120, base: "/",
    url: url_AppengineAppsDomainMappingsGet_579121, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsPatch_579159 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsDomainMappingsPatch_579161(protocol: Scheme; host: string;
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

proc validate_AppengineAppsDomainMappingsPatch_579160(path: JsonNode;
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
  var valid_579162 = path.getOrDefault("domainMappingsId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "domainMappingsId", valid_579162
  var valid_579163 = path.getOrDefault("appsId")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "appsId", valid_579163
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
  section = newJObject()
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("prettyPrint")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "prettyPrint", valid_579165
  var valid_579166 = query.getOrDefault("oauth_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "oauth_token", valid_579166
  var valid_579167 = query.getOrDefault("$.xgafv")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("1"))
  if valid_579167 != nil:
    section.add "$.xgafv", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("uploadType")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "uploadType", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("updateMask")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "updateMask", valid_579171
  var valid_579172 = query.getOrDefault("callback")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "callback", valid_579172
  var valid_579173 = query.getOrDefault("fields")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "fields", valid_579173
  var valid_579174 = query.getOrDefault("access_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "access_token", valid_579174
  var valid_579175 = query.getOrDefault("upload_protocol")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "upload_protocol", valid_579175
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

proc call*(call_579177: Call_AppengineAppsDomainMappingsPatch_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified domain mapping. To map an SSL certificate to a domain mapping, update certificate_id to point to an AuthorizedCertificate resource. A user must be authorized to administer the associated domain in order to update a DomainMapping resource.
  ## 
  let valid = call_579177.validator(path, query, header, formData, body)
  let scheme = call_579177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579177.url(scheme.get, call_579177.host, call_579177.base,
                         call_579177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579177, url, valid)

proc call*(call_579178: Call_AppengineAppsDomainMappingsPatch_579159;
          domainMappingsId: string; appsId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  var path_579179 = newJObject()
  var query_579180 = newJObject()
  var body_579181 = newJObject()
  add(query_579180, "key", newJString(key))
  add(query_579180, "prettyPrint", newJBool(prettyPrint))
  add(query_579180, "oauth_token", newJString(oauthToken))
  add(query_579180, "$.xgafv", newJString(Xgafv))
  add(path_579179, "domainMappingsId", newJString(domainMappingsId))
  add(query_579180, "alt", newJString(alt))
  add(query_579180, "uploadType", newJString(uploadType))
  add(path_579179, "appsId", newJString(appsId))
  add(query_579180, "quotaUser", newJString(quotaUser))
  add(query_579180, "updateMask", newJString(updateMask))
  if body != nil:
    body_579181 = body
  add(query_579180, "callback", newJString(callback))
  add(query_579180, "fields", newJString(fields))
  add(query_579180, "access_token", newJString(accessToken))
  add(query_579180, "upload_protocol", newJString(uploadProtocol))
  result = call_579178.call(path_579179, query_579180, nil, nil, body_579181)

var appengineAppsDomainMappingsPatch* = Call_AppengineAppsDomainMappingsPatch_579159(
    name: "appengineAppsDomainMappingsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsPatch_579160, base: "/",
    url: url_AppengineAppsDomainMappingsPatch_579161, schemes: {Scheme.Https})
type
  Call_AppengineAppsDomainMappingsDelete_579139 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsDomainMappingsDelete_579141(protocol: Scheme; host: string;
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

proc validate_AppengineAppsDomainMappingsDelete_579140(path: JsonNode;
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
  var valid_579142 = path.getOrDefault("domainMappingsId")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = nil)
  if valid_579142 != nil:
    section.add "domainMappingsId", valid_579142
  var valid_579143 = path.getOrDefault("appsId")
  valid_579143 = validateParameter(valid_579143, JString, required = true,
                                 default = nil)
  if valid_579143 != nil:
    section.add "appsId", valid_579143
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
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("$.xgafv")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("1"))
  if valid_579147 != nil:
    section.add "$.xgafv", valid_579147
  var valid_579148 = query.getOrDefault("alt")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = newJString("json"))
  if valid_579148 != nil:
    section.add "alt", valid_579148
  var valid_579149 = query.getOrDefault("uploadType")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "uploadType", valid_579149
  var valid_579150 = query.getOrDefault("quotaUser")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "quotaUser", valid_579150
  var valid_579151 = query.getOrDefault("callback")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "callback", valid_579151
  var valid_579152 = query.getOrDefault("fields")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "fields", valid_579152
  var valid_579153 = query.getOrDefault("access_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "access_token", valid_579153
  var valid_579154 = query.getOrDefault("upload_protocol")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "upload_protocol", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_AppengineAppsDomainMappingsDelete_579139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified domain mapping. A user must be authorized to administer the associated domain in order to delete a DomainMapping resource.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_AppengineAppsDomainMappingsDelete_579139;
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
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "$.xgafv", newJString(Xgafv))
  add(path_579157, "domainMappingsId", newJString(domainMappingsId))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "uploadType", newJString(uploadType))
  add(path_579157, "appsId", newJString(appsId))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(query_579158, "callback", newJString(callback))
  add(query_579158, "fields", newJString(fields))
  add(query_579158, "access_token", newJString(accessToken))
  add(query_579158, "upload_protocol", newJString(uploadProtocol))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var appengineAppsDomainMappingsDelete* = Call_AppengineAppsDomainMappingsDelete_579139(
    name: "appengineAppsDomainMappingsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/domainMappings/{domainMappingsId}",
    validator: validate_AppengineAppsDomainMappingsDelete_579140, base: "/",
    url: url_AppengineAppsDomainMappingsDelete_579141, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesCreate_579204 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesCreate_579206(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesCreate_579205(path: JsonNode;
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
  var valid_579207 = path.getOrDefault("appsId")
  valid_579207 = validateParameter(valid_579207, JString, required = true,
                                 default = nil)
  if valid_579207 != nil:
    section.add "appsId", valid_579207
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
  var valid_579208 = query.getOrDefault("key")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "key", valid_579208
  var valid_579209 = query.getOrDefault("prettyPrint")
  valid_579209 = validateParameter(valid_579209, JBool, required = false,
                                 default = newJBool(true))
  if valid_579209 != nil:
    section.add "prettyPrint", valid_579209
  var valid_579210 = query.getOrDefault("oauth_token")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "oauth_token", valid_579210
  var valid_579211 = query.getOrDefault("$.xgafv")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = newJString("1"))
  if valid_579211 != nil:
    section.add "$.xgafv", valid_579211
  var valid_579212 = query.getOrDefault("alt")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("json"))
  if valid_579212 != nil:
    section.add "alt", valid_579212
  var valid_579213 = query.getOrDefault("uploadType")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "uploadType", valid_579213
  var valid_579214 = query.getOrDefault("quotaUser")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "quotaUser", valid_579214
  var valid_579215 = query.getOrDefault("callback")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "callback", valid_579215
  var valid_579216 = query.getOrDefault("fields")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "fields", valid_579216
  var valid_579217 = query.getOrDefault("access_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "access_token", valid_579217
  var valid_579218 = query.getOrDefault("upload_protocol")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "upload_protocol", valid_579218
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

proc call*(call_579220: Call_AppengineAppsFirewallIngressRulesCreate_579204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a firewall rule for the application.
  ## 
  let valid = call_579220.validator(path, query, header, formData, body)
  let scheme = call_579220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579220.url(scheme.get, call_579220.host, call_579220.base,
                         call_579220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579220, url, valid)

proc call*(call_579221: Call_AppengineAppsFirewallIngressRulesCreate_579204;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesCreate
  ## Creates a firewall rule for the application.
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
  ##         : Part of `parent`. Name of the parent Firewall collection in which to create a new rule. Example: apps/myapp/firewall/ingressRules.
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
  var path_579222 = newJObject()
  var query_579223 = newJObject()
  var body_579224 = newJObject()
  add(query_579223, "key", newJString(key))
  add(query_579223, "prettyPrint", newJBool(prettyPrint))
  add(query_579223, "oauth_token", newJString(oauthToken))
  add(query_579223, "$.xgafv", newJString(Xgafv))
  add(query_579223, "alt", newJString(alt))
  add(query_579223, "uploadType", newJString(uploadType))
  add(path_579222, "appsId", newJString(appsId))
  add(query_579223, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579224 = body
  add(query_579223, "callback", newJString(callback))
  add(query_579223, "fields", newJString(fields))
  add(query_579223, "access_token", newJString(accessToken))
  add(query_579223, "upload_protocol", newJString(uploadProtocol))
  result = call_579221.call(path_579222, query_579223, nil, nil, body_579224)

var appengineAppsFirewallIngressRulesCreate* = Call_AppengineAppsFirewallIngressRulesCreate_579204(
    name: "appengineAppsFirewallIngressRulesCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesCreate_579205, base: "/",
    url: url_AppengineAppsFirewallIngressRulesCreate_579206,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesList_579182 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesList_579184(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesList_579183(path: JsonNode;
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
  var valid_579185 = path.getOrDefault("appsId")
  valid_579185 = validateParameter(valid_579185, JString, required = true,
                                 default = nil)
  if valid_579185 != nil:
    section.add "appsId", valid_579185
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
  ##   matchingAddress: JString
  ##                  : A valid IP Address. If set, only rules matching this address will be returned. The first returned rule will be the rule that fires on requests from this IP.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579186 = query.getOrDefault("key")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "key", valid_579186
  var valid_579187 = query.getOrDefault("prettyPrint")
  valid_579187 = validateParameter(valid_579187, JBool, required = false,
                                 default = newJBool(true))
  if valid_579187 != nil:
    section.add "prettyPrint", valid_579187
  var valid_579188 = query.getOrDefault("oauth_token")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "oauth_token", valid_579188
  var valid_579189 = query.getOrDefault("$.xgafv")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = newJString("1"))
  if valid_579189 != nil:
    section.add "$.xgafv", valid_579189
  var valid_579190 = query.getOrDefault("pageSize")
  valid_579190 = validateParameter(valid_579190, JInt, required = false, default = nil)
  if valid_579190 != nil:
    section.add "pageSize", valid_579190
  var valid_579191 = query.getOrDefault("alt")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("json"))
  if valid_579191 != nil:
    section.add "alt", valid_579191
  var valid_579192 = query.getOrDefault("uploadType")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "uploadType", valid_579192
  var valid_579193 = query.getOrDefault("quotaUser")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "quotaUser", valid_579193
  var valid_579194 = query.getOrDefault("pageToken")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "pageToken", valid_579194
  var valid_579195 = query.getOrDefault("callback")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "callback", valid_579195
  var valid_579196 = query.getOrDefault("matchingAddress")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "matchingAddress", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579200: Call_AppengineAppsFirewallIngressRulesList_579182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the firewall rules of an application.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_AppengineAppsFirewallIngressRulesList_579182;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; matchingAddress: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesList
  ## Lists the firewall rules of an application.
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
  ##         : Part of `parent`. Name of the Firewall collection to retrieve. Example: apps/myapp/firewall/ingressRules.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   matchingAddress: string
  ##                  : A valid IP Address. If set, only rules matching this address will be returned. The first returned rule will be the rule that fires on requests from this IP.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "$.xgafv", newJString(Xgafv))
  add(query_579203, "pageSize", newJInt(pageSize))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "uploadType", newJString(uploadType))
  add(path_579202, "appsId", newJString(appsId))
  add(query_579203, "quotaUser", newJString(quotaUser))
  add(query_579203, "pageToken", newJString(pageToken))
  add(query_579203, "callback", newJString(callback))
  add(query_579203, "matchingAddress", newJString(matchingAddress))
  add(query_579203, "fields", newJString(fields))
  add(query_579203, "access_token", newJString(accessToken))
  add(query_579203, "upload_protocol", newJString(uploadProtocol))
  result = call_579201.call(path_579202, query_579203, nil, nil, nil)

var appengineAppsFirewallIngressRulesList* = Call_AppengineAppsFirewallIngressRulesList_579182(
    name: "appengineAppsFirewallIngressRulesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules",
    validator: validate_AppengineAppsFirewallIngressRulesList_579183, base: "/",
    url: url_AppengineAppsFirewallIngressRulesList_579184, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesGet_579225 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesGet_579227(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesGet_579226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to retrieve. Example: apps/myapp/firewall/ingressRules/100.
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579228 = path.getOrDefault("appsId")
  valid_579228 = validateParameter(valid_579228, JString, required = true,
                                 default = nil)
  if valid_579228 != nil:
    section.add "appsId", valid_579228
  var valid_579229 = path.getOrDefault("ingressRulesId")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "ingressRulesId", valid_579229
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
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("$.xgafv")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("1"))
  if valid_579233 != nil:
    section.add "$.xgafv", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("uploadType")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "uploadType", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("callback")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "callback", valid_579237
  var valid_579238 = query.getOrDefault("fields")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "fields", valid_579238
  var valid_579239 = query.getOrDefault("access_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "access_token", valid_579239
  var valid_579240 = query.getOrDefault("upload_protocol")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "upload_protocol", valid_579240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579241: Call_AppengineAppsFirewallIngressRulesGet_579225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified firewall rule.
  ## 
  let valid = call_579241.validator(path, query, header, formData, body)
  let scheme = call_579241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579241.url(scheme.get, call_579241.host, call_579241.base,
                         call_579241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579241, url, valid)

proc call*(call_579242: Call_AppengineAppsFirewallIngressRulesGet_579225;
          appsId: string; ingressRulesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesGet
  ## Gets the specified firewall rule.
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
  ##         : Part of `name`. Name of the Firewall resource to retrieve. Example: apps/myapp/firewall/ingressRules/100.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579243 = newJObject()
  var query_579244 = newJObject()
  add(query_579244, "key", newJString(key))
  add(query_579244, "prettyPrint", newJBool(prettyPrint))
  add(query_579244, "oauth_token", newJString(oauthToken))
  add(query_579244, "$.xgafv", newJString(Xgafv))
  add(query_579244, "alt", newJString(alt))
  add(query_579244, "uploadType", newJString(uploadType))
  add(path_579243, "appsId", newJString(appsId))
  add(query_579244, "quotaUser", newJString(quotaUser))
  add(path_579243, "ingressRulesId", newJString(ingressRulesId))
  add(query_579244, "callback", newJString(callback))
  add(query_579244, "fields", newJString(fields))
  add(query_579244, "access_token", newJString(accessToken))
  add(query_579244, "upload_protocol", newJString(uploadProtocol))
  result = call_579242.call(path_579243, query_579244, nil, nil, nil)

var appengineAppsFirewallIngressRulesGet* = Call_AppengineAppsFirewallIngressRulesGet_579225(
    name: "appengineAppsFirewallIngressRulesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesGet_579226, base: "/",
    url: url_AppengineAppsFirewallIngressRulesGet_579227, schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesPatch_579265 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesPatch_579267(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesPatch_579266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to update. Example: apps/myapp/firewall/ingressRules/100.
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579268 = path.getOrDefault("appsId")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "appsId", valid_579268
  var valid_579269 = path.getOrDefault("ingressRulesId")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "ingressRulesId", valid_579269
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
  section = newJObject()
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("$.xgafv")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("1"))
  if valid_579273 != nil:
    section.add "$.xgafv", valid_579273
  var valid_579274 = query.getOrDefault("alt")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = newJString("json"))
  if valid_579274 != nil:
    section.add "alt", valid_579274
  var valid_579275 = query.getOrDefault("uploadType")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "uploadType", valid_579275
  var valid_579276 = query.getOrDefault("quotaUser")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "quotaUser", valid_579276
  var valid_579277 = query.getOrDefault("updateMask")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "updateMask", valid_579277
  var valid_579278 = query.getOrDefault("callback")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "callback", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  var valid_579280 = query.getOrDefault("access_token")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "access_token", valid_579280
  var valid_579281 = query.getOrDefault("upload_protocol")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "upload_protocol", valid_579281
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

proc call*(call_579283: Call_AppengineAppsFirewallIngressRulesPatch_579265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified firewall rule.
  ## 
  let valid = call_579283.validator(path, query, header, formData, body)
  let scheme = call_579283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579283.url(scheme.get, call_579283.host, call_579283.base,
                         call_579283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579283, url, valid)

proc call*(call_579284: Call_AppengineAppsFirewallIngressRulesPatch_579265;
          appsId: string; ingressRulesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesPatch
  ## Updates the specified firewall rule.
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
  ##         : Part of `name`. Name of the Firewall resource to update. Example: apps/myapp/firewall/ingressRules/100.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579285 = newJObject()
  var query_579286 = newJObject()
  var body_579287 = newJObject()
  add(query_579286, "key", newJString(key))
  add(query_579286, "prettyPrint", newJBool(prettyPrint))
  add(query_579286, "oauth_token", newJString(oauthToken))
  add(query_579286, "$.xgafv", newJString(Xgafv))
  add(query_579286, "alt", newJString(alt))
  add(query_579286, "uploadType", newJString(uploadType))
  add(path_579285, "appsId", newJString(appsId))
  add(query_579286, "quotaUser", newJString(quotaUser))
  add(query_579286, "updateMask", newJString(updateMask))
  add(path_579285, "ingressRulesId", newJString(ingressRulesId))
  if body != nil:
    body_579287 = body
  add(query_579286, "callback", newJString(callback))
  add(query_579286, "fields", newJString(fields))
  add(query_579286, "access_token", newJString(accessToken))
  add(query_579286, "upload_protocol", newJString(uploadProtocol))
  result = call_579284.call(path_579285, query_579286, nil, nil, body_579287)

var appengineAppsFirewallIngressRulesPatch* = Call_AppengineAppsFirewallIngressRulesPatch_579265(
    name: "appengineAppsFirewallIngressRulesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesPatch_579266, base: "/",
    url: url_AppengineAppsFirewallIngressRulesPatch_579267,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesDelete_579245 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesDelete_579247(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesDelete_579246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified firewall rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the Firewall resource to delete. Example: apps/myapp/firewall/ingressRules/100.
  ##   ingressRulesId: JString (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579248 = path.getOrDefault("appsId")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "appsId", valid_579248
  var valid_579249 = path.getOrDefault("ingressRulesId")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "ingressRulesId", valid_579249
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
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("$.xgafv")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("1"))
  if valid_579253 != nil:
    section.add "$.xgafv", valid_579253
  var valid_579254 = query.getOrDefault("alt")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = newJString("json"))
  if valid_579254 != nil:
    section.add "alt", valid_579254
  var valid_579255 = query.getOrDefault("uploadType")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "uploadType", valid_579255
  var valid_579256 = query.getOrDefault("quotaUser")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "quotaUser", valid_579256
  var valid_579257 = query.getOrDefault("callback")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "callback", valid_579257
  var valid_579258 = query.getOrDefault("fields")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "fields", valid_579258
  var valid_579259 = query.getOrDefault("access_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "access_token", valid_579259
  var valid_579260 = query.getOrDefault("upload_protocol")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "upload_protocol", valid_579260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579261: Call_AppengineAppsFirewallIngressRulesDelete_579245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified firewall rule.
  ## 
  let valid = call_579261.validator(path, query, header, formData, body)
  let scheme = call_579261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579261.url(scheme.get, call_579261.host, call_579261.base,
                         call_579261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579261, url, valid)

proc call*(call_579262: Call_AppengineAppsFirewallIngressRulesDelete_579245;
          appsId: string; ingressRulesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesDelete
  ## Deletes the specified firewall rule.
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
  ##         : Part of `name`. Name of the Firewall resource to delete. Example: apps/myapp/firewall/ingressRules/100.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   ingressRulesId: string (required)
  ##                 : Part of `name`. See documentation of `appsId`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579263 = newJObject()
  var query_579264 = newJObject()
  add(query_579264, "key", newJString(key))
  add(query_579264, "prettyPrint", newJBool(prettyPrint))
  add(query_579264, "oauth_token", newJString(oauthToken))
  add(query_579264, "$.xgafv", newJString(Xgafv))
  add(query_579264, "alt", newJString(alt))
  add(query_579264, "uploadType", newJString(uploadType))
  add(path_579263, "appsId", newJString(appsId))
  add(query_579264, "quotaUser", newJString(quotaUser))
  add(path_579263, "ingressRulesId", newJString(ingressRulesId))
  add(query_579264, "callback", newJString(callback))
  add(query_579264, "fields", newJString(fields))
  add(query_579264, "access_token", newJString(accessToken))
  add(query_579264, "upload_protocol", newJString(uploadProtocol))
  result = call_579262.call(path_579263, query_579264, nil, nil, nil)

var appengineAppsFirewallIngressRulesDelete* = Call_AppengineAppsFirewallIngressRulesDelete_579245(
    name: "appengineAppsFirewallIngressRulesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules/{ingressRulesId}",
    validator: validate_AppengineAppsFirewallIngressRulesDelete_579246, base: "/",
    url: url_AppengineAppsFirewallIngressRulesDelete_579247,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsFirewallIngressRulesBatchUpdate_579288 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsFirewallIngressRulesBatchUpdate_579290(protocol: Scheme;
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

proc validate_AppengineAppsFirewallIngressRulesBatchUpdate_579289(path: JsonNode;
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
  var valid_579291 = path.getOrDefault("appsId")
  valid_579291 = validateParameter(valid_579291, JString, required = true,
                                 default = nil)
  if valid_579291 != nil:
    section.add "appsId", valid_579291
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
  var valid_579292 = query.getOrDefault("key")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "key", valid_579292
  var valid_579293 = query.getOrDefault("prettyPrint")
  valid_579293 = validateParameter(valid_579293, JBool, required = false,
                                 default = newJBool(true))
  if valid_579293 != nil:
    section.add "prettyPrint", valid_579293
  var valid_579294 = query.getOrDefault("oauth_token")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "oauth_token", valid_579294
  var valid_579295 = query.getOrDefault("$.xgafv")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("1"))
  if valid_579295 != nil:
    section.add "$.xgafv", valid_579295
  var valid_579296 = query.getOrDefault("alt")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("json"))
  if valid_579296 != nil:
    section.add "alt", valid_579296
  var valid_579297 = query.getOrDefault("uploadType")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "uploadType", valid_579297
  var valid_579298 = query.getOrDefault("quotaUser")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "quotaUser", valid_579298
  var valid_579299 = query.getOrDefault("callback")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "callback", valid_579299
  var valid_579300 = query.getOrDefault("fields")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "fields", valid_579300
  var valid_579301 = query.getOrDefault("access_token")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "access_token", valid_579301
  var valid_579302 = query.getOrDefault("upload_protocol")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "upload_protocol", valid_579302
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

proc call*(call_579304: Call_AppengineAppsFirewallIngressRulesBatchUpdate_579288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
  ## 
  let valid = call_579304.validator(path, query, header, formData, body)
  let scheme = call_579304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579304.url(scheme.get, call_579304.host, call_579304.base,
                         call_579304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579304, url, valid)

proc call*(call_579305: Call_AppengineAppsFirewallIngressRulesBatchUpdate_579288;
          appsId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsFirewallIngressRulesBatchUpdate
  ## Replaces the entire firewall ruleset in one bulk operation. This overrides and replaces the rules of an existing firewall with the new rules.If the final rule does not match traffic with the '*' wildcard IP range, then an "allow all" rule is explicitly added to the end of the list.
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
  ##         : Part of `name`. Name of the Firewall collection to set. Example: apps/myapp/firewall/ingressRules.
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
  var path_579306 = newJObject()
  var query_579307 = newJObject()
  var body_579308 = newJObject()
  add(query_579307, "key", newJString(key))
  add(query_579307, "prettyPrint", newJBool(prettyPrint))
  add(query_579307, "oauth_token", newJString(oauthToken))
  add(query_579307, "$.xgafv", newJString(Xgafv))
  add(query_579307, "alt", newJString(alt))
  add(query_579307, "uploadType", newJString(uploadType))
  add(path_579306, "appsId", newJString(appsId))
  add(query_579307, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579308 = body
  add(query_579307, "callback", newJString(callback))
  add(query_579307, "fields", newJString(fields))
  add(query_579307, "access_token", newJString(accessToken))
  add(query_579307, "upload_protocol", newJString(uploadProtocol))
  result = call_579305.call(path_579306, query_579307, nil, nil, body_579308)

var appengineAppsFirewallIngressRulesBatchUpdate* = Call_AppengineAppsFirewallIngressRulesBatchUpdate_579288(
    name: "appengineAppsFirewallIngressRulesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/firewall/ingressRules:batchUpdate",
    validator: validate_AppengineAppsFirewallIngressRulesBatchUpdate_579289,
    base: "/", url: url_AppengineAppsFirewallIngressRulesBatchUpdate_579290,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_579309 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsLocationsList_579311(protocol: Scheme; host: string;
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

proc validate_AppengineAppsLocationsList_579310(path: JsonNode; query: JsonNode;
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
  var valid_579312 = path.getOrDefault("appsId")
  valid_579312 = validateParameter(valid_579312, JString, required = true,
                                 default = nil)
  if valid_579312 != nil:
    section.add "appsId", valid_579312
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
  var valid_579313 = query.getOrDefault("key")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "key", valid_579313
  var valid_579314 = query.getOrDefault("prettyPrint")
  valid_579314 = validateParameter(valid_579314, JBool, required = false,
                                 default = newJBool(true))
  if valid_579314 != nil:
    section.add "prettyPrint", valid_579314
  var valid_579315 = query.getOrDefault("oauth_token")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "oauth_token", valid_579315
  var valid_579316 = query.getOrDefault("$.xgafv")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = newJString("1"))
  if valid_579316 != nil:
    section.add "$.xgafv", valid_579316
  var valid_579317 = query.getOrDefault("pageSize")
  valid_579317 = validateParameter(valid_579317, JInt, required = false, default = nil)
  if valid_579317 != nil:
    section.add "pageSize", valid_579317
  var valid_579318 = query.getOrDefault("alt")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("json"))
  if valid_579318 != nil:
    section.add "alt", valid_579318
  var valid_579319 = query.getOrDefault("uploadType")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "uploadType", valid_579319
  var valid_579320 = query.getOrDefault("quotaUser")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "quotaUser", valid_579320
  var valid_579321 = query.getOrDefault("filter")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "filter", valid_579321
  var valid_579322 = query.getOrDefault("pageToken")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "pageToken", valid_579322
  var valid_579323 = query.getOrDefault("callback")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "callback", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  var valid_579325 = query.getOrDefault("access_token")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "access_token", valid_579325
  var valid_579326 = query.getOrDefault("upload_protocol")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "upload_protocol", valid_579326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579327: Call_AppengineAppsLocationsList_579309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579327.validator(path, query, header, formData, body)
  let scheme = call_579327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579327.url(scheme.get, call_579327.host, call_579327.base,
                         call_579327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579327, url, valid)

proc call*(call_579328: Call_AppengineAppsLocationsList_579309; appsId: string;
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
  var path_579329 = newJObject()
  var query_579330 = newJObject()
  add(query_579330, "key", newJString(key))
  add(query_579330, "prettyPrint", newJBool(prettyPrint))
  add(query_579330, "oauth_token", newJString(oauthToken))
  add(query_579330, "$.xgafv", newJString(Xgafv))
  add(query_579330, "pageSize", newJInt(pageSize))
  add(query_579330, "alt", newJString(alt))
  add(query_579330, "uploadType", newJString(uploadType))
  add(path_579329, "appsId", newJString(appsId))
  add(query_579330, "quotaUser", newJString(quotaUser))
  add(query_579330, "filter", newJString(filter))
  add(query_579330, "pageToken", newJString(pageToken))
  add(query_579330, "callback", newJString(callback))
  add(query_579330, "fields", newJString(fields))
  add(query_579330, "access_token", newJString(accessToken))
  add(query_579330, "upload_protocol", newJString(uploadProtocol))
  result = call_579328.call(path_579329, query_579330, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_579309(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_579310, base: "/",
    url: url_AppengineAppsLocationsList_579311, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_579331 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsLocationsGet_579333(protocol: Scheme; host: string;
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

proc validate_AppengineAppsLocationsGet_579332(path: JsonNode; query: JsonNode;
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
  var valid_579334 = path.getOrDefault("locationsId")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "locationsId", valid_579334
  var valid_579335 = path.getOrDefault("appsId")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "appsId", valid_579335
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
  var valid_579336 = query.getOrDefault("key")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "key", valid_579336
  var valid_579337 = query.getOrDefault("prettyPrint")
  valid_579337 = validateParameter(valid_579337, JBool, required = false,
                                 default = newJBool(true))
  if valid_579337 != nil:
    section.add "prettyPrint", valid_579337
  var valid_579338 = query.getOrDefault("oauth_token")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "oauth_token", valid_579338
  var valid_579339 = query.getOrDefault("$.xgafv")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = newJString("1"))
  if valid_579339 != nil:
    section.add "$.xgafv", valid_579339
  var valid_579340 = query.getOrDefault("alt")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = newJString("json"))
  if valid_579340 != nil:
    section.add "alt", valid_579340
  var valid_579341 = query.getOrDefault("uploadType")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "uploadType", valid_579341
  var valid_579342 = query.getOrDefault("quotaUser")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "quotaUser", valid_579342
  var valid_579343 = query.getOrDefault("callback")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "callback", valid_579343
  var valid_579344 = query.getOrDefault("fields")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "fields", valid_579344
  var valid_579345 = query.getOrDefault("access_token")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "access_token", valid_579345
  var valid_579346 = query.getOrDefault("upload_protocol")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "upload_protocol", valid_579346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579347: Call_AppengineAppsLocationsGet_579331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_579347.validator(path, query, header, formData, body)
  let scheme = call_579347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579347.url(scheme.get, call_579347.host, call_579347.base,
                         call_579347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579347, url, valid)

proc call*(call_579348: Call_AppengineAppsLocationsGet_579331; locationsId: string;
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
  var path_579349 = newJObject()
  var query_579350 = newJObject()
  add(query_579350, "key", newJString(key))
  add(query_579350, "prettyPrint", newJBool(prettyPrint))
  add(query_579350, "oauth_token", newJString(oauthToken))
  add(query_579350, "$.xgafv", newJString(Xgafv))
  add(path_579349, "locationsId", newJString(locationsId))
  add(query_579350, "alt", newJString(alt))
  add(query_579350, "uploadType", newJString(uploadType))
  add(path_579349, "appsId", newJString(appsId))
  add(query_579350, "quotaUser", newJString(quotaUser))
  add(query_579350, "callback", newJString(callback))
  add(query_579350, "fields", newJString(fields))
  add(query_579350, "access_token", newJString(accessToken))
  add(query_579350, "upload_protocol", newJString(uploadProtocol))
  result = call_579348.call(path_579349, query_579350, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_579331(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_579332, base: "/",
    url: url_AppengineAppsLocationsGet_579333, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_579351 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsOperationsList_579353(protocol: Scheme; host: string;
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

proc validate_AppengineAppsOperationsList_579352(path: JsonNode; query: JsonNode;
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
  var valid_579354 = path.getOrDefault("appsId")
  valid_579354 = validateParameter(valid_579354, JString, required = true,
                                 default = nil)
  if valid_579354 != nil:
    section.add "appsId", valid_579354
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
  var valid_579355 = query.getOrDefault("key")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "key", valid_579355
  var valid_579356 = query.getOrDefault("prettyPrint")
  valid_579356 = validateParameter(valid_579356, JBool, required = false,
                                 default = newJBool(true))
  if valid_579356 != nil:
    section.add "prettyPrint", valid_579356
  var valid_579357 = query.getOrDefault("oauth_token")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "oauth_token", valid_579357
  var valid_579358 = query.getOrDefault("$.xgafv")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = newJString("1"))
  if valid_579358 != nil:
    section.add "$.xgafv", valid_579358
  var valid_579359 = query.getOrDefault("pageSize")
  valid_579359 = validateParameter(valid_579359, JInt, required = false, default = nil)
  if valid_579359 != nil:
    section.add "pageSize", valid_579359
  var valid_579360 = query.getOrDefault("alt")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = newJString("json"))
  if valid_579360 != nil:
    section.add "alt", valid_579360
  var valid_579361 = query.getOrDefault("uploadType")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "uploadType", valid_579361
  var valid_579362 = query.getOrDefault("quotaUser")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "quotaUser", valid_579362
  var valid_579363 = query.getOrDefault("filter")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "filter", valid_579363
  var valid_579364 = query.getOrDefault("pageToken")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "pageToken", valid_579364
  var valid_579365 = query.getOrDefault("callback")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "callback", valid_579365
  var valid_579366 = query.getOrDefault("fields")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "fields", valid_579366
  var valid_579367 = query.getOrDefault("access_token")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "access_token", valid_579367
  var valid_579368 = query.getOrDefault("upload_protocol")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "upload_protocol", valid_579368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579369: Call_AppengineAppsOperationsList_579351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_579369.validator(path, query, header, formData, body)
  let scheme = call_579369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579369.url(scheme.get, call_579369.host, call_579369.base,
                         call_579369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579369, url, valid)

proc call*(call_579370: Call_AppengineAppsOperationsList_579351; appsId: string;
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
  var path_579371 = newJObject()
  var query_579372 = newJObject()
  add(query_579372, "key", newJString(key))
  add(query_579372, "prettyPrint", newJBool(prettyPrint))
  add(query_579372, "oauth_token", newJString(oauthToken))
  add(query_579372, "$.xgafv", newJString(Xgafv))
  add(query_579372, "pageSize", newJInt(pageSize))
  add(query_579372, "alt", newJString(alt))
  add(query_579372, "uploadType", newJString(uploadType))
  add(path_579371, "appsId", newJString(appsId))
  add(query_579372, "quotaUser", newJString(quotaUser))
  add(query_579372, "filter", newJString(filter))
  add(query_579372, "pageToken", newJString(pageToken))
  add(query_579372, "callback", newJString(callback))
  add(query_579372, "fields", newJString(fields))
  add(query_579372, "access_token", newJString(accessToken))
  add(query_579372, "upload_protocol", newJString(uploadProtocol))
  result = call_579370.call(path_579371, query_579372, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_579351(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_579352, base: "/",
    url: url_AppengineAppsOperationsList_579353, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_579373 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsOperationsGet_579375(protocol: Scheme; host: string;
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

proc validate_AppengineAppsOperationsGet_579374(path: JsonNode; query: JsonNode;
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
  var valid_579376 = path.getOrDefault("appsId")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "appsId", valid_579376
  var valid_579377 = path.getOrDefault("operationsId")
  valid_579377 = validateParameter(valid_579377, JString, required = true,
                                 default = nil)
  if valid_579377 != nil:
    section.add "operationsId", valid_579377
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
  var valid_579378 = query.getOrDefault("key")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "key", valid_579378
  var valid_579379 = query.getOrDefault("prettyPrint")
  valid_579379 = validateParameter(valid_579379, JBool, required = false,
                                 default = newJBool(true))
  if valid_579379 != nil:
    section.add "prettyPrint", valid_579379
  var valid_579380 = query.getOrDefault("oauth_token")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "oauth_token", valid_579380
  var valid_579381 = query.getOrDefault("$.xgafv")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = newJString("1"))
  if valid_579381 != nil:
    section.add "$.xgafv", valid_579381
  var valid_579382 = query.getOrDefault("alt")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = newJString("json"))
  if valid_579382 != nil:
    section.add "alt", valid_579382
  var valid_579383 = query.getOrDefault("uploadType")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "uploadType", valid_579383
  var valid_579384 = query.getOrDefault("quotaUser")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "quotaUser", valid_579384
  var valid_579385 = query.getOrDefault("callback")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "callback", valid_579385
  var valid_579386 = query.getOrDefault("fields")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "fields", valid_579386
  var valid_579387 = query.getOrDefault("access_token")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "access_token", valid_579387
  var valid_579388 = query.getOrDefault("upload_protocol")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "upload_protocol", valid_579388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579389: Call_AppengineAppsOperationsGet_579373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_579389.validator(path, query, header, formData, body)
  let scheme = call_579389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579389.url(scheme.get, call_579389.host, call_579389.base,
                         call_579389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579389, url, valid)

proc call*(call_579390: Call_AppengineAppsOperationsGet_579373; appsId: string;
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
  var path_579391 = newJObject()
  var query_579392 = newJObject()
  add(query_579392, "key", newJString(key))
  add(query_579392, "prettyPrint", newJBool(prettyPrint))
  add(query_579392, "oauth_token", newJString(oauthToken))
  add(query_579392, "$.xgafv", newJString(Xgafv))
  add(query_579392, "alt", newJString(alt))
  add(query_579392, "uploadType", newJString(uploadType))
  add(path_579391, "appsId", newJString(appsId))
  add(query_579392, "quotaUser", newJString(quotaUser))
  add(path_579391, "operationsId", newJString(operationsId))
  add(query_579392, "callback", newJString(callback))
  add(query_579392, "fields", newJString(fields))
  add(query_579392, "access_token", newJString(accessToken))
  add(query_579392, "upload_protocol", newJString(uploadProtocol))
  result = call_579390.call(path_579391, query_579392, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_579373(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_579374, base: "/",
    url: url_AppengineAppsOperationsGet_579375, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_579393 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesList_579395(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesList_579394(path: JsonNode; query: JsonNode;
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
  var valid_579396 = path.getOrDefault("appsId")
  valid_579396 = validateParameter(valid_579396, JString, required = true,
                                 default = nil)
  if valid_579396 != nil:
    section.add "appsId", valid_579396
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
  var valid_579397 = query.getOrDefault("key")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "key", valid_579397
  var valid_579398 = query.getOrDefault("prettyPrint")
  valid_579398 = validateParameter(valid_579398, JBool, required = false,
                                 default = newJBool(true))
  if valid_579398 != nil:
    section.add "prettyPrint", valid_579398
  var valid_579399 = query.getOrDefault("oauth_token")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "oauth_token", valid_579399
  var valid_579400 = query.getOrDefault("$.xgafv")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = newJString("1"))
  if valid_579400 != nil:
    section.add "$.xgafv", valid_579400
  var valid_579401 = query.getOrDefault("pageSize")
  valid_579401 = validateParameter(valid_579401, JInt, required = false, default = nil)
  if valid_579401 != nil:
    section.add "pageSize", valid_579401
  var valid_579402 = query.getOrDefault("alt")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = newJString("json"))
  if valid_579402 != nil:
    section.add "alt", valid_579402
  var valid_579403 = query.getOrDefault("uploadType")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "uploadType", valid_579403
  var valid_579404 = query.getOrDefault("quotaUser")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "quotaUser", valid_579404
  var valid_579405 = query.getOrDefault("pageToken")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "pageToken", valid_579405
  var valid_579406 = query.getOrDefault("callback")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "callback", valid_579406
  var valid_579407 = query.getOrDefault("fields")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "fields", valid_579407
  var valid_579408 = query.getOrDefault("access_token")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "access_token", valid_579408
  var valid_579409 = query.getOrDefault("upload_protocol")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "upload_protocol", valid_579409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579410: Call_AppengineAppsServicesList_579393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_579410.validator(path, query, header, formData, body)
  let scheme = call_579410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579410.url(scheme.get, call_579410.host, call_579410.base,
                         call_579410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579410, url, valid)

proc call*(call_579411: Call_AppengineAppsServicesList_579393; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesList
  ## Lists all the services in the application.
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
  var path_579412 = newJObject()
  var query_579413 = newJObject()
  add(query_579413, "key", newJString(key))
  add(query_579413, "prettyPrint", newJBool(prettyPrint))
  add(query_579413, "oauth_token", newJString(oauthToken))
  add(query_579413, "$.xgafv", newJString(Xgafv))
  add(query_579413, "pageSize", newJInt(pageSize))
  add(query_579413, "alt", newJString(alt))
  add(query_579413, "uploadType", newJString(uploadType))
  add(path_579412, "appsId", newJString(appsId))
  add(query_579413, "quotaUser", newJString(quotaUser))
  add(query_579413, "pageToken", newJString(pageToken))
  add(query_579413, "callback", newJString(callback))
  add(query_579413, "fields", newJString(fields))
  add(query_579413, "access_token", newJString(accessToken))
  add(query_579413, "upload_protocol", newJString(uploadProtocol))
  result = call_579411.call(path_579412, query_579413, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_579393(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_579394, base: "/",
    url: url_AppengineAppsServicesList_579395, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_579414 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesGet_579416(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesGet_579415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current configuration of the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579417 = path.getOrDefault("appsId")
  valid_579417 = validateParameter(valid_579417, JString, required = true,
                                 default = nil)
  if valid_579417 != nil:
    section.add "appsId", valid_579417
  var valid_579418 = path.getOrDefault("servicesId")
  valid_579418 = validateParameter(valid_579418, JString, required = true,
                                 default = nil)
  if valid_579418 != nil:
    section.add "servicesId", valid_579418
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
  var valid_579419 = query.getOrDefault("key")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "key", valid_579419
  var valid_579420 = query.getOrDefault("prettyPrint")
  valid_579420 = validateParameter(valid_579420, JBool, required = false,
                                 default = newJBool(true))
  if valid_579420 != nil:
    section.add "prettyPrint", valid_579420
  var valid_579421 = query.getOrDefault("oauth_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "oauth_token", valid_579421
  var valid_579422 = query.getOrDefault("$.xgafv")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("1"))
  if valid_579422 != nil:
    section.add "$.xgafv", valid_579422
  var valid_579423 = query.getOrDefault("alt")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = newJString("json"))
  if valid_579423 != nil:
    section.add "alt", valid_579423
  var valid_579424 = query.getOrDefault("uploadType")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "uploadType", valid_579424
  var valid_579425 = query.getOrDefault("quotaUser")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "quotaUser", valid_579425
  var valid_579426 = query.getOrDefault("callback")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "callback", valid_579426
  var valid_579427 = query.getOrDefault("fields")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "fields", valid_579427
  var valid_579428 = query.getOrDefault("access_token")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "access_token", valid_579428
  var valid_579429 = query.getOrDefault("upload_protocol")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "upload_protocol", valid_579429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579430: Call_AppengineAppsServicesGet_579414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_579430.validator(path, query, header, formData, body)
  let scheme = call_579430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579430.url(scheme.get, call_579430.host, call_579430.base,
                         call_579430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579430, url, valid)

proc call*(call_579431: Call_AppengineAppsServicesGet_579414; appsId: string;
          servicesId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesGet
  ## Gets the current configuration of the specified service.
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579432 = newJObject()
  var query_579433 = newJObject()
  add(query_579433, "key", newJString(key))
  add(query_579433, "prettyPrint", newJBool(prettyPrint))
  add(query_579433, "oauth_token", newJString(oauthToken))
  add(query_579433, "$.xgafv", newJString(Xgafv))
  add(query_579433, "alt", newJString(alt))
  add(query_579433, "uploadType", newJString(uploadType))
  add(path_579432, "appsId", newJString(appsId))
  add(query_579433, "quotaUser", newJString(quotaUser))
  add(query_579433, "callback", newJString(callback))
  add(path_579432, "servicesId", newJString(servicesId))
  add(query_579433, "fields", newJString(fields))
  add(query_579433, "access_token", newJString(accessToken))
  add(query_579433, "upload_protocol", newJString(uploadProtocol))
  result = call_579431.call(path_579432, query_579433, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_579414(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_579415, base: "/",
    url: url_AppengineAppsServicesGet_579416, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_579454 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesPatch_579456(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesPatch_579455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the configuration of the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579457 = path.getOrDefault("appsId")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "appsId", valid_579457
  var valid_579458 = path.getOrDefault("servicesId")
  valid_579458 = validateParameter(valid_579458, JString, required = true,
                                 default = nil)
  if valid_579458 != nil:
    section.add "servicesId", valid_579458
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   migrateTraffic: JBool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
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
  section = newJObject()
  var valid_579459 = query.getOrDefault("key")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "key", valid_579459
  var valid_579460 = query.getOrDefault("prettyPrint")
  valid_579460 = validateParameter(valid_579460, JBool, required = false,
                                 default = newJBool(true))
  if valid_579460 != nil:
    section.add "prettyPrint", valid_579460
  var valid_579461 = query.getOrDefault("oauth_token")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "oauth_token", valid_579461
  var valid_579462 = query.getOrDefault("migrateTraffic")
  valid_579462 = validateParameter(valid_579462, JBool, required = false, default = nil)
  if valid_579462 != nil:
    section.add "migrateTraffic", valid_579462
  var valid_579463 = query.getOrDefault("$.xgafv")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("1"))
  if valid_579463 != nil:
    section.add "$.xgafv", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("uploadType")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "uploadType", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("updateMask")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "updateMask", valid_579467
  var valid_579468 = query.getOrDefault("callback")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "callback", valid_579468
  var valid_579469 = query.getOrDefault("fields")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "fields", valid_579469
  var valid_579470 = query.getOrDefault("access_token")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "access_token", valid_579470
  var valid_579471 = query.getOrDefault("upload_protocol")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "upload_protocol", valid_579471
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

proc call*(call_579473: Call_AppengineAppsServicesPatch_579454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_579473.validator(path, query, header, formData, body)
  let scheme = call_579473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579473.url(scheme.get, call_579473.host, call_579473.base,
                         call_579473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579473, url, valid)

proc call*(call_579474: Call_AppengineAppsServicesPatch_579454; appsId: string;
          servicesId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; migrateTraffic: bool = false; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesPatch
  ## Updates the configuration of the specified service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   migrateTraffic: bool
  ##                 : Set to true to gradually shift traffic to one or more versions that you specify. By default, traffic is shifted immediately. For gradual traffic migration, the target versions must be located within instances that are configured for both warmup requests 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#InboundServiceType) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services.versions#AutomaticScaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1/apps.services#ShardBy) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579475 = newJObject()
  var query_579476 = newJObject()
  var body_579477 = newJObject()
  add(query_579476, "key", newJString(key))
  add(query_579476, "prettyPrint", newJBool(prettyPrint))
  add(query_579476, "oauth_token", newJString(oauthToken))
  add(query_579476, "migrateTraffic", newJBool(migrateTraffic))
  add(query_579476, "$.xgafv", newJString(Xgafv))
  add(query_579476, "alt", newJString(alt))
  add(query_579476, "uploadType", newJString(uploadType))
  add(path_579475, "appsId", newJString(appsId))
  add(query_579476, "quotaUser", newJString(quotaUser))
  add(query_579476, "updateMask", newJString(updateMask))
  if body != nil:
    body_579477 = body
  add(query_579476, "callback", newJString(callback))
  add(path_579475, "servicesId", newJString(servicesId))
  add(query_579476, "fields", newJString(fields))
  add(query_579476, "access_token", newJString(accessToken))
  add(query_579476, "upload_protocol", newJString(uploadProtocol))
  result = call_579474.call(path_579475, query_579476, nil, nil, body_579477)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_579454(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_579455, base: "/",
    url: url_AppengineAppsServicesPatch_579456, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_579434 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesDelete_579436(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesDelete_579435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified service and all enclosed versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579437 = path.getOrDefault("appsId")
  valid_579437 = validateParameter(valid_579437, JString, required = true,
                                 default = nil)
  if valid_579437 != nil:
    section.add "appsId", valid_579437
  var valid_579438 = path.getOrDefault("servicesId")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "servicesId", valid_579438
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
  var valid_579439 = query.getOrDefault("key")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "key", valid_579439
  var valid_579440 = query.getOrDefault("prettyPrint")
  valid_579440 = validateParameter(valid_579440, JBool, required = false,
                                 default = newJBool(true))
  if valid_579440 != nil:
    section.add "prettyPrint", valid_579440
  var valid_579441 = query.getOrDefault("oauth_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "oauth_token", valid_579441
  var valid_579442 = query.getOrDefault("$.xgafv")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("1"))
  if valid_579442 != nil:
    section.add "$.xgafv", valid_579442
  var valid_579443 = query.getOrDefault("alt")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = newJString("json"))
  if valid_579443 != nil:
    section.add "alt", valid_579443
  var valid_579444 = query.getOrDefault("uploadType")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "uploadType", valid_579444
  var valid_579445 = query.getOrDefault("quotaUser")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "quotaUser", valid_579445
  var valid_579446 = query.getOrDefault("callback")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "callback", valid_579446
  var valid_579447 = query.getOrDefault("fields")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "fields", valid_579447
  var valid_579448 = query.getOrDefault("access_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "access_token", valid_579448
  var valid_579449 = query.getOrDefault("upload_protocol")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "upload_protocol", valid_579449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579450: Call_AppengineAppsServicesDelete_579434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_579450.validator(path, query, header, formData, body)
  let scheme = call_579450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579450.url(scheme.get, call_579450.host, call_579450.base,
                         call_579450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579450, url, valid)

proc call*(call_579451: Call_AppengineAppsServicesDelete_579434; appsId: string;
          servicesId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesDelete
  ## Deletes the specified service and all enclosed versions.
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579452 = newJObject()
  var query_579453 = newJObject()
  add(query_579453, "key", newJString(key))
  add(query_579453, "prettyPrint", newJBool(prettyPrint))
  add(query_579453, "oauth_token", newJString(oauthToken))
  add(query_579453, "$.xgafv", newJString(Xgafv))
  add(query_579453, "alt", newJString(alt))
  add(query_579453, "uploadType", newJString(uploadType))
  add(path_579452, "appsId", newJString(appsId))
  add(query_579453, "quotaUser", newJString(quotaUser))
  add(query_579453, "callback", newJString(callback))
  add(path_579452, "servicesId", newJString(servicesId))
  add(query_579453, "fields", newJString(fields))
  add(query_579453, "access_token", newJString(accessToken))
  add(query_579453, "upload_protocol", newJString(uploadProtocol))
  result = call_579451.call(path_579452, query_579453, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_579434(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_579435, base: "/",
    url: url_AppengineAppsServicesDelete_579436, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_579501 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsCreate_579503(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesVersionsCreate_579502(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deploys code and resource files to a new version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent resource to create this version under. Example: apps/myapp/services/default.
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579504 = path.getOrDefault("appsId")
  valid_579504 = validateParameter(valid_579504, JString, required = true,
                                 default = nil)
  if valid_579504 != nil:
    section.add "appsId", valid_579504
  var valid_579505 = path.getOrDefault("servicesId")
  valid_579505 = validateParameter(valid_579505, JString, required = true,
                                 default = nil)
  if valid_579505 != nil:
    section.add "servicesId", valid_579505
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
  var valid_579506 = query.getOrDefault("key")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "key", valid_579506
  var valid_579507 = query.getOrDefault("prettyPrint")
  valid_579507 = validateParameter(valid_579507, JBool, required = false,
                                 default = newJBool(true))
  if valid_579507 != nil:
    section.add "prettyPrint", valid_579507
  var valid_579508 = query.getOrDefault("oauth_token")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "oauth_token", valid_579508
  var valid_579509 = query.getOrDefault("$.xgafv")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = newJString("1"))
  if valid_579509 != nil:
    section.add "$.xgafv", valid_579509
  var valid_579510 = query.getOrDefault("alt")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = newJString("json"))
  if valid_579510 != nil:
    section.add "alt", valid_579510
  var valid_579511 = query.getOrDefault("uploadType")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "uploadType", valid_579511
  var valid_579512 = query.getOrDefault("quotaUser")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "quotaUser", valid_579512
  var valid_579513 = query.getOrDefault("callback")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "callback", valid_579513
  var valid_579514 = query.getOrDefault("fields")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "fields", valid_579514
  var valid_579515 = query.getOrDefault("access_token")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "access_token", valid_579515
  var valid_579516 = query.getOrDefault("upload_protocol")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "upload_protocol", valid_579516
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

proc call*(call_579518: Call_AppengineAppsServicesVersionsCreate_579501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys code and resource files to a new version.
  ## 
  let valid = call_579518.validator(path, query, header, formData, body)
  let scheme = call_579518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579518.url(scheme.get, call_579518.host, call_579518.base,
                         call_579518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579518, url, valid)

proc call*(call_579519: Call_AppengineAppsServicesVersionsCreate_579501;
          appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsCreate
  ## Deploys code and resource files to a new version.
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
  ##         : Part of `parent`. Name of the parent resource to create this version under. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579520 = newJObject()
  var query_579521 = newJObject()
  var body_579522 = newJObject()
  add(query_579521, "key", newJString(key))
  add(query_579521, "prettyPrint", newJBool(prettyPrint))
  add(query_579521, "oauth_token", newJString(oauthToken))
  add(query_579521, "$.xgafv", newJString(Xgafv))
  add(query_579521, "alt", newJString(alt))
  add(query_579521, "uploadType", newJString(uploadType))
  add(path_579520, "appsId", newJString(appsId))
  add(query_579521, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579522 = body
  add(query_579521, "callback", newJString(callback))
  add(path_579520, "servicesId", newJString(servicesId))
  add(query_579521, "fields", newJString(fields))
  add(query_579521, "access_token", newJString(accessToken))
  add(query_579521, "upload_protocol", newJString(uploadProtocol))
  result = call_579519.call(path_579520, query_579521, nil, nil, body_579522)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_579501(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_579502, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_579503, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_579478 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsList_579480(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesVersionsList_579479(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the versions of a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Service resource. Example: apps/myapp/services/default.
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579481 = path.getOrDefault("appsId")
  valid_579481 = validateParameter(valid_579481, JString, required = true,
                                 default = nil)
  if valid_579481 != nil:
    section.add "appsId", valid_579481
  var valid_579482 = path.getOrDefault("servicesId")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = nil)
  if valid_579482 != nil:
    section.add "servicesId", valid_579482
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
  ##       : Controls the set of fields returned in the List response.
  section = newJObject()
  var valid_579483 = query.getOrDefault("key")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "key", valid_579483
  var valid_579484 = query.getOrDefault("prettyPrint")
  valid_579484 = validateParameter(valid_579484, JBool, required = false,
                                 default = newJBool(true))
  if valid_579484 != nil:
    section.add "prettyPrint", valid_579484
  var valid_579485 = query.getOrDefault("oauth_token")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "oauth_token", valid_579485
  var valid_579486 = query.getOrDefault("$.xgafv")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = newJString("1"))
  if valid_579486 != nil:
    section.add "$.xgafv", valid_579486
  var valid_579487 = query.getOrDefault("pageSize")
  valid_579487 = validateParameter(valid_579487, JInt, required = false, default = nil)
  if valid_579487 != nil:
    section.add "pageSize", valid_579487
  var valid_579488 = query.getOrDefault("alt")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = newJString("json"))
  if valid_579488 != nil:
    section.add "alt", valid_579488
  var valid_579489 = query.getOrDefault("uploadType")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "uploadType", valid_579489
  var valid_579490 = query.getOrDefault("quotaUser")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "quotaUser", valid_579490
  var valid_579491 = query.getOrDefault("pageToken")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "pageToken", valid_579491
  var valid_579492 = query.getOrDefault("callback")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "callback", valid_579492
  var valid_579493 = query.getOrDefault("fields")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "fields", valid_579493
  var valid_579494 = query.getOrDefault("access_token")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "access_token", valid_579494
  var valid_579495 = query.getOrDefault("upload_protocol")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "upload_protocol", valid_579495
  var valid_579496 = query.getOrDefault("view")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579496 != nil:
    section.add "view", valid_579496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579497: Call_AppengineAppsServicesVersionsList_579478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_579497.validator(path, query, header, formData, body)
  let scheme = call_579497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579497.url(scheme.get, call_579497.host, call_579497.base,
                         call_579497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579497, url, valid)

proc call*(call_579498: Call_AppengineAppsServicesVersionsList_579478;
          appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          view: string = "BASIC"): Recallable =
  ## appengineAppsServicesVersionsList
  ## Lists the versions of a service.
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
  ##         : Part of `parent`. Name of the parent Service resource. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Controls the set of fields returned in the List response.
  var path_579499 = newJObject()
  var query_579500 = newJObject()
  add(query_579500, "key", newJString(key))
  add(query_579500, "prettyPrint", newJBool(prettyPrint))
  add(query_579500, "oauth_token", newJString(oauthToken))
  add(query_579500, "$.xgafv", newJString(Xgafv))
  add(query_579500, "pageSize", newJInt(pageSize))
  add(query_579500, "alt", newJString(alt))
  add(query_579500, "uploadType", newJString(uploadType))
  add(path_579499, "appsId", newJString(appsId))
  add(query_579500, "quotaUser", newJString(quotaUser))
  add(query_579500, "pageToken", newJString(pageToken))
  add(query_579500, "callback", newJString(callback))
  add(path_579499, "servicesId", newJString(servicesId))
  add(query_579500, "fields", newJString(fields))
  add(query_579500, "access_token", newJString(accessToken))
  add(query_579500, "upload_protocol", newJString(uploadProtocol))
  add(query_579500, "view", newJString(view))
  result = call_579498.call(path_579499, query_579500, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_579478(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_579479, base: "/",
    url: url_AppengineAppsServicesVersionsList_579480, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_579523 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsGet_579525(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesVersionsGet_579524(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579526 = path.getOrDefault("versionsId")
  valid_579526 = validateParameter(valid_579526, JString, required = true,
                                 default = nil)
  if valid_579526 != nil:
    section.add "versionsId", valid_579526
  var valid_579527 = path.getOrDefault("appsId")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "appsId", valid_579527
  var valid_579528 = path.getOrDefault("servicesId")
  valid_579528 = validateParameter(valid_579528, JString, required = true,
                                 default = nil)
  if valid_579528 != nil:
    section.add "servicesId", valid_579528
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
  ##       : Controls the set of fields returned in the Get response.
  section = newJObject()
  var valid_579529 = query.getOrDefault("key")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "key", valid_579529
  var valid_579530 = query.getOrDefault("prettyPrint")
  valid_579530 = validateParameter(valid_579530, JBool, required = false,
                                 default = newJBool(true))
  if valid_579530 != nil:
    section.add "prettyPrint", valid_579530
  var valid_579531 = query.getOrDefault("oauth_token")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "oauth_token", valid_579531
  var valid_579532 = query.getOrDefault("$.xgafv")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = newJString("1"))
  if valid_579532 != nil:
    section.add "$.xgafv", valid_579532
  var valid_579533 = query.getOrDefault("alt")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = newJString("json"))
  if valid_579533 != nil:
    section.add "alt", valid_579533
  var valid_579534 = query.getOrDefault("uploadType")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "uploadType", valid_579534
  var valid_579535 = query.getOrDefault("quotaUser")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "quotaUser", valid_579535
  var valid_579536 = query.getOrDefault("callback")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "callback", valid_579536
  var valid_579537 = query.getOrDefault("fields")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = nil)
  if valid_579537 != nil:
    section.add "fields", valid_579537
  var valid_579538 = query.getOrDefault("access_token")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "access_token", valid_579538
  var valid_579539 = query.getOrDefault("upload_protocol")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "upload_protocol", valid_579539
  var valid_579540 = query.getOrDefault("view")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579540 != nil:
    section.add "view", valid_579540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579541: Call_AppengineAppsServicesVersionsGet_579523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_579541.validator(path, query, header, formData, body)
  let scheme = call_579541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579541.url(scheme.get, call_579541.host, call_579541.base,
                         call_579541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579541, url, valid)

proc call*(call_579542: Call_AppengineAppsServicesVersionsGet_579523;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## appengineAppsServicesVersionsGet
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Controls the set of fields returned in the Get response.
  var path_579543 = newJObject()
  var query_579544 = newJObject()
  add(query_579544, "key", newJString(key))
  add(query_579544, "prettyPrint", newJBool(prettyPrint))
  add(query_579544, "oauth_token", newJString(oauthToken))
  add(query_579544, "$.xgafv", newJString(Xgafv))
  add(path_579543, "versionsId", newJString(versionsId))
  add(query_579544, "alt", newJString(alt))
  add(query_579544, "uploadType", newJString(uploadType))
  add(path_579543, "appsId", newJString(appsId))
  add(query_579544, "quotaUser", newJString(quotaUser))
  add(query_579544, "callback", newJString(callback))
  add(path_579543, "servicesId", newJString(servicesId))
  add(query_579544, "fields", newJString(fields))
  add(query_579544, "access_token", newJString(accessToken))
  add(query_579544, "upload_protocol", newJString(uploadProtocol))
  add(query_579544, "view", newJString(view))
  result = call_579542.call(path_579543, query_579544, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_579523(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_579524, base: "/",
    url: url_AppengineAppsServicesVersionsGet_579525, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_579566 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsPatch_579568(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesVersionsPatch_579567(path: JsonNode;
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
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default/versions/1.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579569 = path.getOrDefault("versionsId")
  valid_579569 = validateParameter(valid_579569, JString, required = true,
                                 default = nil)
  if valid_579569 != nil:
    section.add "versionsId", valid_579569
  var valid_579570 = path.getOrDefault("appsId")
  valid_579570 = validateParameter(valid_579570, JString, required = true,
                                 default = nil)
  if valid_579570 != nil:
    section.add "appsId", valid_579570
  var valid_579571 = path.getOrDefault("servicesId")
  valid_579571 = validateParameter(valid_579571, JString, required = true,
                                 default = nil)
  if valid_579571 != nil:
    section.add "servicesId", valid_579571
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
  section = newJObject()
  var valid_579572 = query.getOrDefault("key")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "key", valid_579572
  var valid_579573 = query.getOrDefault("prettyPrint")
  valid_579573 = validateParameter(valid_579573, JBool, required = false,
                                 default = newJBool(true))
  if valid_579573 != nil:
    section.add "prettyPrint", valid_579573
  var valid_579574 = query.getOrDefault("oauth_token")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "oauth_token", valid_579574
  var valid_579575 = query.getOrDefault("$.xgafv")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = newJString("1"))
  if valid_579575 != nil:
    section.add "$.xgafv", valid_579575
  var valid_579576 = query.getOrDefault("alt")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = newJString("json"))
  if valid_579576 != nil:
    section.add "alt", valid_579576
  var valid_579577 = query.getOrDefault("uploadType")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "uploadType", valid_579577
  var valid_579578 = query.getOrDefault("quotaUser")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "quotaUser", valid_579578
  var valid_579579 = query.getOrDefault("updateMask")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "updateMask", valid_579579
  var valid_579580 = query.getOrDefault("callback")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "callback", valid_579580
  var valid_579581 = query.getOrDefault("fields")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "fields", valid_579581
  var valid_579582 = query.getOrDefault("access_token")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "access_token", valid_579582
  var valid_579583 = query.getOrDefault("upload_protocol")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "upload_protocol", valid_579583
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

proc call*(call_579585: Call_AppengineAppsServicesVersionsPatch_579566;
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
  let valid = call_579585.validator(path, query, header, formData, body)
  let scheme = call_579585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579585.url(scheme.get, call_579585.host, call_579585.base,
                         call_579585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579585, url, valid)

proc call*(call_579586: Call_AppengineAppsServicesVersionsPatch_579566;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default/versions/1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579587 = newJObject()
  var query_579588 = newJObject()
  var body_579589 = newJObject()
  add(query_579588, "key", newJString(key))
  add(query_579588, "prettyPrint", newJBool(prettyPrint))
  add(query_579588, "oauth_token", newJString(oauthToken))
  add(query_579588, "$.xgafv", newJString(Xgafv))
  add(path_579587, "versionsId", newJString(versionsId))
  add(query_579588, "alt", newJString(alt))
  add(query_579588, "uploadType", newJString(uploadType))
  add(path_579587, "appsId", newJString(appsId))
  add(query_579588, "quotaUser", newJString(quotaUser))
  add(query_579588, "updateMask", newJString(updateMask))
  if body != nil:
    body_579589 = body
  add(query_579588, "callback", newJString(callback))
  add(path_579587, "servicesId", newJString(servicesId))
  add(query_579588, "fields", newJString(fields))
  add(query_579588, "access_token", newJString(accessToken))
  add(query_579588, "upload_protocol", newJString(uploadProtocol))
  result = call_579586.call(path_579587, query_579588, nil, nil, body_579589)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_579566(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_579567, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_579568, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_579545 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsDelete_579547(protocol: Scheme; host: string;
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

proc validate_AppengineAppsServicesVersionsDelete_579546(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579548 = path.getOrDefault("versionsId")
  valid_579548 = validateParameter(valid_579548, JString, required = true,
                                 default = nil)
  if valid_579548 != nil:
    section.add "versionsId", valid_579548
  var valid_579549 = path.getOrDefault("appsId")
  valid_579549 = validateParameter(valid_579549, JString, required = true,
                                 default = nil)
  if valid_579549 != nil:
    section.add "appsId", valid_579549
  var valid_579550 = path.getOrDefault("servicesId")
  valid_579550 = validateParameter(valid_579550, JString, required = true,
                                 default = nil)
  if valid_579550 != nil:
    section.add "servicesId", valid_579550
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
  var valid_579551 = query.getOrDefault("key")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "key", valid_579551
  var valid_579552 = query.getOrDefault("prettyPrint")
  valid_579552 = validateParameter(valid_579552, JBool, required = false,
                                 default = newJBool(true))
  if valid_579552 != nil:
    section.add "prettyPrint", valid_579552
  var valid_579553 = query.getOrDefault("oauth_token")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "oauth_token", valid_579553
  var valid_579554 = query.getOrDefault("$.xgafv")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = newJString("1"))
  if valid_579554 != nil:
    section.add "$.xgafv", valid_579554
  var valid_579555 = query.getOrDefault("alt")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = newJString("json"))
  if valid_579555 != nil:
    section.add "alt", valid_579555
  var valid_579556 = query.getOrDefault("uploadType")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "uploadType", valid_579556
  var valid_579557 = query.getOrDefault("quotaUser")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "quotaUser", valid_579557
  var valid_579558 = query.getOrDefault("callback")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "callback", valid_579558
  var valid_579559 = query.getOrDefault("fields")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "fields", valid_579559
  var valid_579560 = query.getOrDefault("access_token")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "access_token", valid_579560
  var valid_579561 = query.getOrDefault("upload_protocol")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "upload_protocol", valid_579561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579562: Call_AppengineAppsServicesVersionsDelete_579545;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing Version resource.
  ## 
  let valid = call_579562.validator(path, query, header, formData, body)
  let scheme = call_579562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579562.url(scheme.get, call_579562.host, call_579562.base,
                         call_579562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579562, url, valid)

proc call*(call_579563: Call_AppengineAppsServicesVersionsDelete_579545;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsDelete
  ## Deletes an existing Version resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579564 = newJObject()
  var query_579565 = newJObject()
  add(query_579565, "key", newJString(key))
  add(query_579565, "prettyPrint", newJBool(prettyPrint))
  add(query_579565, "oauth_token", newJString(oauthToken))
  add(query_579565, "$.xgafv", newJString(Xgafv))
  add(path_579564, "versionsId", newJString(versionsId))
  add(query_579565, "alt", newJString(alt))
  add(query_579565, "uploadType", newJString(uploadType))
  add(path_579564, "appsId", newJString(appsId))
  add(query_579565, "quotaUser", newJString(quotaUser))
  add(query_579565, "callback", newJString(callback))
  add(path_579564, "servicesId", newJString(servicesId))
  add(query_579565, "fields", newJString(fields))
  add(query_579565, "access_token", newJString(accessToken))
  add(query_579565, "upload_protocol", newJString(uploadProtocol))
  result = call_579563.call(path_579564, query_579565, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_579545(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_579546, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_579547, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_579590 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesList_579592(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesList_579591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `parent`. Name of the parent Version resource. Example: apps/myapp/services/default/versions/v1.
  ##   servicesId: JString (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579593 = path.getOrDefault("versionsId")
  valid_579593 = validateParameter(valid_579593, JString, required = true,
                                 default = nil)
  if valid_579593 != nil:
    section.add "versionsId", valid_579593
  var valid_579594 = path.getOrDefault("appsId")
  valid_579594 = validateParameter(valid_579594, JString, required = true,
                                 default = nil)
  if valid_579594 != nil:
    section.add "appsId", valid_579594
  var valid_579595 = path.getOrDefault("servicesId")
  valid_579595 = validateParameter(valid_579595, JString, required = true,
                                 default = nil)
  if valid_579595 != nil:
    section.add "servicesId", valid_579595
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
  var valid_579596 = query.getOrDefault("key")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "key", valid_579596
  var valid_579597 = query.getOrDefault("prettyPrint")
  valid_579597 = validateParameter(valid_579597, JBool, required = false,
                                 default = newJBool(true))
  if valid_579597 != nil:
    section.add "prettyPrint", valid_579597
  var valid_579598 = query.getOrDefault("oauth_token")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "oauth_token", valid_579598
  var valid_579599 = query.getOrDefault("$.xgafv")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = newJString("1"))
  if valid_579599 != nil:
    section.add "$.xgafv", valid_579599
  var valid_579600 = query.getOrDefault("pageSize")
  valid_579600 = validateParameter(valid_579600, JInt, required = false, default = nil)
  if valid_579600 != nil:
    section.add "pageSize", valid_579600
  var valid_579601 = query.getOrDefault("alt")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = newJString("json"))
  if valid_579601 != nil:
    section.add "alt", valid_579601
  var valid_579602 = query.getOrDefault("uploadType")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "uploadType", valid_579602
  var valid_579603 = query.getOrDefault("quotaUser")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "quotaUser", valid_579603
  var valid_579604 = query.getOrDefault("pageToken")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "pageToken", valid_579604
  var valid_579605 = query.getOrDefault("callback")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "callback", valid_579605
  var valid_579606 = query.getOrDefault("fields")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "fields", valid_579606
  var valid_579607 = query.getOrDefault("access_token")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "access_token", valid_579607
  var valid_579608 = query.getOrDefault("upload_protocol")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "upload_protocol", valid_579608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579609: Call_AppengineAppsServicesVersionsInstancesList_579590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_579609.validator(path, query, header, formData, body)
  let scheme = call_579609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579609.url(scheme.get, call_579609.host, call_579609.base,
                         call_579609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579609, url, valid)

proc call*(call_579610: Call_AppengineAppsServicesVersionsInstancesList_579590;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsInstancesList
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `parent`. Name of the parent Version resource. Example: apps/myapp/services/default/versions/v1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `parent`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579611 = newJObject()
  var query_579612 = newJObject()
  add(query_579612, "key", newJString(key))
  add(query_579612, "prettyPrint", newJBool(prettyPrint))
  add(query_579612, "oauth_token", newJString(oauthToken))
  add(query_579612, "$.xgafv", newJString(Xgafv))
  add(path_579611, "versionsId", newJString(versionsId))
  add(query_579612, "pageSize", newJInt(pageSize))
  add(query_579612, "alt", newJString(alt))
  add(query_579612, "uploadType", newJString(uploadType))
  add(path_579611, "appsId", newJString(appsId))
  add(query_579612, "quotaUser", newJString(quotaUser))
  add(query_579612, "pageToken", newJString(pageToken))
  add(query_579612, "callback", newJString(callback))
  add(path_579611, "servicesId", newJString(servicesId))
  add(query_579612, "fields", newJString(fields))
  add(query_579612, "access_token", newJString(accessToken))
  add(query_579612, "upload_protocol", newJString(uploadProtocol))
  result = call_579610.call(path_579611, query_579612, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_579590(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_579591,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_579592,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_579613 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesGet_579615(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesGet_579614(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets instance information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579616 = path.getOrDefault("versionsId")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "versionsId", valid_579616
  var valid_579617 = path.getOrDefault("appsId")
  valid_579617 = validateParameter(valid_579617, JString, required = true,
                                 default = nil)
  if valid_579617 != nil:
    section.add "appsId", valid_579617
  var valid_579618 = path.getOrDefault("instancesId")
  valid_579618 = validateParameter(valid_579618, JString, required = true,
                                 default = nil)
  if valid_579618 != nil:
    section.add "instancesId", valid_579618
  var valid_579619 = path.getOrDefault("servicesId")
  valid_579619 = validateParameter(valid_579619, JString, required = true,
                                 default = nil)
  if valid_579619 != nil:
    section.add "servicesId", valid_579619
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
  var valid_579620 = query.getOrDefault("key")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "key", valid_579620
  var valid_579621 = query.getOrDefault("prettyPrint")
  valid_579621 = validateParameter(valid_579621, JBool, required = false,
                                 default = newJBool(true))
  if valid_579621 != nil:
    section.add "prettyPrint", valid_579621
  var valid_579622 = query.getOrDefault("oauth_token")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "oauth_token", valid_579622
  var valid_579623 = query.getOrDefault("$.xgafv")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = newJString("1"))
  if valid_579623 != nil:
    section.add "$.xgafv", valid_579623
  var valid_579624 = query.getOrDefault("alt")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = newJString("json"))
  if valid_579624 != nil:
    section.add "alt", valid_579624
  var valid_579625 = query.getOrDefault("uploadType")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "uploadType", valid_579625
  var valid_579626 = query.getOrDefault("quotaUser")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "quotaUser", valid_579626
  var valid_579627 = query.getOrDefault("callback")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "callback", valid_579627
  var valid_579628 = query.getOrDefault("fields")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "fields", valid_579628
  var valid_579629 = query.getOrDefault("access_token")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "access_token", valid_579629
  var valid_579630 = query.getOrDefault("upload_protocol")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "upload_protocol", valid_579630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579631: Call_AppengineAppsServicesVersionsInstancesGet_579613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_579631.validator(path, query, header, formData, body)
  let scheme = call_579631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579631.url(scheme.get, call_579631.host, call_579631.base,
                         call_579631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579631, url, valid)

proc call*(call_579632: Call_AppengineAppsServicesVersionsInstancesGet_579613;
          versionsId: string; appsId: string; instancesId: string; servicesId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsInstancesGet
  ## Gets instance information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579633 = newJObject()
  var query_579634 = newJObject()
  add(query_579634, "key", newJString(key))
  add(query_579634, "prettyPrint", newJBool(prettyPrint))
  add(query_579634, "oauth_token", newJString(oauthToken))
  add(query_579634, "$.xgafv", newJString(Xgafv))
  add(path_579633, "versionsId", newJString(versionsId))
  add(query_579634, "alt", newJString(alt))
  add(query_579634, "uploadType", newJString(uploadType))
  add(path_579633, "appsId", newJString(appsId))
  add(query_579634, "quotaUser", newJString(quotaUser))
  add(path_579633, "instancesId", newJString(instancesId))
  add(query_579634, "callback", newJString(callback))
  add(path_579633, "servicesId", newJString(servicesId))
  add(query_579634, "fields", newJString(fields))
  add(query_579634, "access_token", newJString(accessToken))
  add(query_579634, "upload_protocol", newJString(uploadProtocol))
  result = call_579632.call(path_579633, query_579634, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_579613(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_579614,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_579615,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_579635 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesDelete_579637(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesDelete_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a running instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579638 = path.getOrDefault("versionsId")
  valid_579638 = validateParameter(valid_579638, JString, required = true,
                                 default = nil)
  if valid_579638 != nil:
    section.add "versionsId", valid_579638
  var valid_579639 = path.getOrDefault("appsId")
  valid_579639 = validateParameter(valid_579639, JString, required = true,
                                 default = nil)
  if valid_579639 != nil:
    section.add "appsId", valid_579639
  var valid_579640 = path.getOrDefault("instancesId")
  valid_579640 = validateParameter(valid_579640, JString, required = true,
                                 default = nil)
  if valid_579640 != nil:
    section.add "instancesId", valid_579640
  var valid_579641 = path.getOrDefault("servicesId")
  valid_579641 = validateParameter(valid_579641, JString, required = true,
                                 default = nil)
  if valid_579641 != nil:
    section.add "servicesId", valid_579641
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
  var valid_579642 = query.getOrDefault("key")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "key", valid_579642
  var valid_579643 = query.getOrDefault("prettyPrint")
  valid_579643 = validateParameter(valid_579643, JBool, required = false,
                                 default = newJBool(true))
  if valid_579643 != nil:
    section.add "prettyPrint", valid_579643
  var valid_579644 = query.getOrDefault("oauth_token")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "oauth_token", valid_579644
  var valid_579645 = query.getOrDefault("$.xgafv")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = newJString("1"))
  if valid_579645 != nil:
    section.add "$.xgafv", valid_579645
  var valid_579646 = query.getOrDefault("alt")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = newJString("json"))
  if valid_579646 != nil:
    section.add "alt", valid_579646
  var valid_579647 = query.getOrDefault("uploadType")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "uploadType", valid_579647
  var valid_579648 = query.getOrDefault("quotaUser")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "quotaUser", valid_579648
  var valid_579649 = query.getOrDefault("callback")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "callback", valid_579649
  var valid_579650 = query.getOrDefault("fields")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "fields", valid_579650
  var valid_579651 = query.getOrDefault("access_token")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "access_token", valid_579651
  var valid_579652 = query.getOrDefault("upload_protocol")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "upload_protocol", valid_579652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579653: Call_AppengineAppsServicesVersionsInstancesDelete_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_579653.validator(path, query, header, formData, body)
  let scheme = call_579653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579653.url(scheme.get, call_579653.host, call_579653.base,
                         call_579653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579653, url, valid)

proc call*(call_579654: Call_AppengineAppsServicesVersionsInstancesDelete_579635;
          versionsId: string; appsId: string; instancesId: string; servicesId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsInstancesDelete
  ## Stops a running instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579655 = newJObject()
  var query_579656 = newJObject()
  add(query_579656, "key", newJString(key))
  add(query_579656, "prettyPrint", newJBool(prettyPrint))
  add(query_579656, "oauth_token", newJString(oauthToken))
  add(query_579656, "$.xgafv", newJString(Xgafv))
  add(path_579655, "versionsId", newJString(versionsId))
  add(query_579656, "alt", newJString(alt))
  add(query_579656, "uploadType", newJString(uploadType))
  add(path_579655, "appsId", newJString(appsId))
  add(query_579656, "quotaUser", newJString(quotaUser))
  add(path_579655, "instancesId", newJString(instancesId))
  add(query_579656, "callback", newJString(callback))
  add(path_579655, "servicesId", newJString(servicesId))
  add(query_579656, "fields", newJString(fields))
  add(query_579656, "access_token", newJString(accessToken))
  add(query_579656, "upload_protocol", newJString(uploadProtocol))
  result = call_579654.call(path_579655, query_579656, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_579635(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_579636,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_579637,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_579657 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesDebug_579659(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesDebug_579658(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579660 = path.getOrDefault("versionsId")
  valid_579660 = validateParameter(valid_579660, JString, required = true,
                                 default = nil)
  if valid_579660 != nil:
    section.add "versionsId", valid_579660
  var valid_579661 = path.getOrDefault("appsId")
  valid_579661 = validateParameter(valid_579661, JString, required = true,
                                 default = nil)
  if valid_579661 != nil:
    section.add "appsId", valid_579661
  var valid_579662 = path.getOrDefault("instancesId")
  valid_579662 = validateParameter(valid_579662, JString, required = true,
                                 default = nil)
  if valid_579662 != nil:
    section.add "instancesId", valid_579662
  var valid_579663 = path.getOrDefault("servicesId")
  valid_579663 = validateParameter(valid_579663, JString, required = true,
                                 default = nil)
  if valid_579663 != nil:
    section.add "servicesId", valid_579663
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
  var valid_579664 = query.getOrDefault("key")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "key", valid_579664
  var valid_579665 = query.getOrDefault("prettyPrint")
  valid_579665 = validateParameter(valid_579665, JBool, required = false,
                                 default = newJBool(true))
  if valid_579665 != nil:
    section.add "prettyPrint", valid_579665
  var valid_579666 = query.getOrDefault("oauth_token")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "oauth_token", valid_579666
  var valid_579667 = query.getOrDefault("$.xgafv")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = newJString("1"))
  if valid_579667 != nil:
    section.add "$.xgafv", valid_579667
  var valid_579668 = query.getOrDefault("alt")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = newJString("json"))
  if valid_579668 != nil:
    section.add "alt", valid_579668
  var valid_579669 = query.getOrDefault("uploadType")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "uploadType", valid_579669
  var valid_579670 = query.getOrDefault("quotaUser")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "quotaUser", valid_579670
  var valid_579671 = query.getOrDefault("callback")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "callback", valid_579671
  var valid_579672 = query.getOrDefault("fields")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "fields", valid_579672
  var valid_579673 = query.getOrDefault("access_token")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "access_token", valid_579673
  var valid_579674 = query.getOrDefault("upload_protocol")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "upload_protocol", valid_579674
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

proc call*(call_579676: Call_AppengineAppsServicesVersionsInstancesDebug_579657;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_579676.validator(path, query, header, formData, body)
  let scheme = call_579676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579676.url(scheme.get, call_579676.host, call_579676.base,
                         call_579676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579676, url, valid)

proc call*(call_579677: Call_AppengineAppsServicesVersionsInstancesDebug_579657;
          versionsId: string; appsId: string; instancesId: string; servicesId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsInstancesDebug
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionsId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1/instances/instance-1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instancesId: string (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   servicesId: string (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579678 = newJObject()
  var query_579679 = newJObject()
  var body_579680 = newJObject()
  add(query_579679, "key", newJString(key))
  add(query_579679, "prettyPrint", newJBool(prettyPrint))
  add(query_579679, "oauth_token", newJString(oauthToken))
  add(query_579679, "$.xgafv", newJString(Xgafv))
  add(path_579678, "versionsId", newJString(versionsId))
  add(query_579679, "alt", newJString(alt))
  add(query_579679, "uploadType", newJString(uploadType))
  add(path_579678, "appsId", newJString(appsId))
  add(query_579679, "quotaUser", newJString(quotaUser))
  add(path_579678, "instancesId", newJString(instancesId))
  if body != nil:
    body_579680 = body
  add(query_579679, "callback", newJString(callback))
  add(path_579678, "servicesId", newJString(servicesId))
  add(query_579679, "fields", newJString(fields))
  add(query_579679, "access_token", newJString(accessToken))
  add(query_579679, "upload_protocol", newJString(uploadProtocol))
  result = call_579677.call(path_579678, query_579679, nil, nil, body_579680)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_579657(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_579658,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_579659,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsRepair_579681 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsRepair_579683(protocol: Scheme; host: string; base: string;
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

proc validate_AppengineAppsRepair_579682(path: JsonNode; query: JsonNode;
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
  var valid_579684 = path.getOrDefault("appsId")
  valid_579684 = validateParameter(valid_579684, JString, required = true,
                                 default = nil)
  if valid_579684 != nil:
    section.add "appsId", valid_579684
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
  var valid_579685 = query.getOrDefault("key")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "key", valid_579685
  var valid_579686 = query.getOrDefault("prettyPrint")
  valid_579686 = validateParameter(valid_579686, JBool, required = false,
                                 default = newJBool(true))
  if valid_579686 != nil:
    section.add "prettyPrint", valid_579686
  var valid_579687 = query.getOrDefault("oauth_token")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "oauth_token", valid_579687
  var valid_579688 = query.getOrDefault("$.xgafv")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = newJString("1"))
  if valid_579688 != nil:
    section.add "$.xgafv", valid_579688
  var valid_579689 = query.getOrDefault("alt")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = newJString("json"))
  if valid_579689 != nil:
    section.add "alt", valid_579689
  var valid_579690 = query.getOrDefault("uploadType")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "uploadType", valid_579690
  var valid_579691 = query.getOrDefault("quotaUser")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "quotaUser", valid_579691
  var valid_579692 = query.getOrDefault("callback")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "callback", valid_579692
  var valid_579693 = query.getOrDefault("fields")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "fields", valid_579693
  var valid_579694 = query.getOrDefault("access_token")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "access_token", valid_579694
  var valid_579695 = query.getOrDefault("upload_protocol")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "upload_protocol", valid_579695
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

proc call*(call_579697: Call_AppengineAppsRepair_579681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
  ## 
  let valid = call_579697.validator(path, query, header, formData, body)
  let scheme = call_579697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579697.url(scheme.get, call_579697.host, call_579697.base,
                         call_579697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579697, url, valid)

proc call*(call_579698: Call_AppengineAppsRepair_579681; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsRepair
  ## Recreates the required App Engine features for the specified App Engine application, for example a Cloud Storage bucket or App Engine service account. Use this method if you receive an error message about a missing feature, for example, Error retrieving the App Engine service account. If you have deleted your App Engine service account, this will not be able to recreate it. Instead, you should attempt to use the IAM undelete API if possible at https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/undelete?apix_params=%7B"name"%3A"projects%2F-%2FserviceAccounts%2Funique_id"%2C"resource"%3A%7B%7D%7D . If the deletion was recent, the numeric ID can be found in the Cloud Console Activity Log.
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
  ##         : Part of `name`. Name of the application to repair. Example: apps/myapp
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
  var path_579699 = newJObject()
  var query_579700 = newJObject()
  var body_579701 = newJObject()
  add(query_579700, "key", newJString(key))
  add(query_579700, "prettyPrint", newJBool(prettyPrint))
  add(query_579700, "oauth_token", newJString(oauthToken))
  add(query_579700, "$.xgafv", newJString(Xgafv))
  add(query_579700, "alt", newJString(alt))
  add(query_579700, "uploadType", newJString(uploadType))
  add(path_579699, "appsId", newJString(appsId))
  add(query_579700, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579701 = body
  add(query_579700, "callback", newJString(callback))
  add(query_579700, "fields", newJString(fields))
  add(query_579700, "access_token", newJString(accessToken))
  add(query_579700, "upload_protocol", newJString(uploadProtocol))
  result = call_579698.call(path_579699, query_579700, nil, nil, body_579701)

var appengineAppsRepair* = Call_AppengineAppsRepair_579681(
    name: "appengineAppsRepair", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com", route: "/v1/apps/{appsId}:repair",
    validator: validate_AppengineAppsRepair_579682, base: "/",
    url: url_AppengineAppsRepair_579683, schemes: {Scheme.Https})
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
