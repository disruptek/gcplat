
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
  ## location - The region (https://cloud.google.com/appengine/docs/locations) where you want the App Engine application located.For more information about App Engine applications, see Managing Projects, Applications, and Billing (https://cloud.google.com/appengine/docs/python/console/).
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
    host: "appengine.googleapis.com", route: "/v1beta5/apps",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
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
  ##   ensureResourcesExist: JBool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete. Note: This parameter will be deprecated in a future version of the API.
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
  var valid_578918 = query.getOrDefault("ensureResourcesExist")
  valid_578918 = validateParameter(valid_578918, JBool, required = false, default = nil)
  if valid_578918 != nil:
    section.add "ensureResourcesExist", valid_578918
  var valid_578919 = query.getOrDefault("callback")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "callback", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578923: Call_AppengineAppsGet_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an application.
  ## 
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_AppengineAppsGet_578893; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; ensureResourcesExist: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##         : Part of `name`. Name of the application to get. Example: apps/myapp.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   ensureResourcesExist: bool
  ##                       : Certain resources associated with an application are created on-demand. Controls whether these resources should be created when performing the GET operation. If specified and any resources could not be created, the request will fail with an error code. Additionally, this parameter can cause the request to take longer to complete. Note: This parameter will be deprecated in a future version of the API.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "$.xgafv", newJString(Xgafv))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "uploadType", newJString(uploadType))
  add(path_578925, "appsId", newJString(appsId))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(query_578926, "ensureResourcesExist", newJBool(ensureResourcesExist))
  add(query_578926, "callback", newJString(callback))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "access_token", newJString(accessToken))
  add(query_578926, "upload_protocol", newJString(uploadProtocol))
  result = call_578924.call(path_578925, query_578926, nil, nil, nil)

var appengineAppsGet* = Call_AppengineAppsGet_578893(name: "appengineAppsGet",
    meth: HttpMethod.HttpGet, host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}", validator: validate_AppengineAppsGet_578894,
    base: "/", url: url_AppengineAppsGet_578895, schemes: {Scheme.Https})
type
  Call_AppengineAppsPatch_578927 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsPatch_578929(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "appsId" in path, "`appsId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta5/apps/"),
               (kind: VariableSegment, value: "appsId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppengineAppsPatch_578928(path: JsonNode; query: JsonNode;
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
  var valid_578930 = path.getOrDefault("appsId")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "appsId", valid_578930
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
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578931 = query.getOrDefault("key")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "key", valid_578931
  var valid_578932 = query.getOrDefault("prettyPrint")
  valid_578932 = validateParameter(valid_578932, JBool, required = false,
                                 default = newJBool(true))
  if valid_578932 != nil:
    section.add "prettyPrint", valid_578932
  var valid_578933 = query.getOrDefault("oauth_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "oauth_token", valid_578933
  var valid_578934 = query.getOrDefault("$.xgafv")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("1"))
  if valid_578934 != nil:
    section.add "$.xgafv", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("uploadType")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "uploadType", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("mask")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "mask", valid_578938
  var valid_578939 = query.getOrDefault("callback")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "callback", valid_578939
  var valid_578940 = query.getOrDefault("fields")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "fields", valid_578940
  var valid_578941 = query.getOrDefault("access_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "access_token", valid_578941
  var valid_578942 = query.getOrDefault("upload_protocol")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "upload_protocol", valid_578942
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

proc call*(call_578944: Call_AppengineAppsPatch_578927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.default_cookie_expiration)
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_AppengineAppsPatch_578927; appsId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; mask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsPatch
  ## Updates the specified Application resource. You can update the following fields:
  ## auth_domain (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.auth_domain)
  ## default_cookie_expiration (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps#Application.FIELDS.default_cookie_expiration)
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  var body_578948 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(path_578946, "appsId", newJString(appsId))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(query_578947, "mask", newJString(mask))
  if body != nil:
    body_578948 = body
  add(query_578947, "callback", newJString(callback))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  result = call_578945.call(path_578946, query_578947, nil, nil, body_578948)

var appengineAppsPatch* = Call_AppengineAppsPatch_578927(
    name: "appengineAppsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}",
    validator: validate_AppengineAppsPatch_578928, base: "/",
    url: url_AppengineAppsPatch_578929, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsList_578949 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsLocationsList_578951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsLocationsList_578950(path: JsonNode; query: JsonNode;
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
  var valid_578952 = path.getOrDefault("appsId")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "appsId", valid_578952
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
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("prettyPrint")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "prettyPrint", valid_578954
  var valid_578955 = query.getOrDefault("oauth_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "oauth_token", valid_578955
  var valid_578956 = query.getOrDefault("$.xgafv")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("1"))
  if valid_578956 != nil:
    section.add "$.xgafv", valid_578956
  var valid_578957 = query.getOrDefault("pageSize")
  valid_578957 = validateParameter(valid_578957, JInt, required = false, default = nil)
  if valid_578957 != nil:
    section.add "pageSize", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("filter")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "filter", valid_578961
  var valid_578962 = query.getOrDefault("pageToken")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "pageToken", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578967: Call_AppengineAppsLocationsList_578949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_AppengineAppsLocationsList_578949; appsId: string;
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
  var path_578969 = newJObject()
  var query_578970 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "pageSize", newJInt(pageSize))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(path_578969, "appsId", newJString(appsId))
  add(query_578970, "quotaUser", newJString(quotaUser))
  add(query_578970, "filter", newJString(filter))
  add(query_578970, "pageToken", newJString(pageToken))
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(path_578969, query_578970, nil, nil, nil)

var appengineAppsLocationsList* = Call_AppengineAppsLocationsList_578949(
    name: "appengineAppsLocationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/locations",
    validator: validate_AppengineAppsLocationsList_578950, base: "/",
    url: url_AppengineAppsLocationsList_578951, schemes: {Scheme.Https})
type
  Call_AppengineAppsLocationsGet_578971 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsLocationsGet_578973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsLocationsGet_578972(path: JsonNode; query: JsonNode;
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
  var valid_578974 = path.getOrDefault("locationsId")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "locationsId", valid_578974
  var valid_578975 = path.getOrDefault("appsId")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "appsId", valid_578975
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
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("alt")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("json"))
  if valid_578980 != nil:
    section.add "alt", valid_578980
  var valid_578981 = query.getOrDefault("uploadType")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "uploadType", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("callback")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "callback", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
  var valid_578985 = query.getOrDefault("access_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "access_token", valid_578985
  var valid_578986 = query.getOrDefault("upload_protocol")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "upload_protocol", valid_578986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578987: Call_AppengineAppsLocationsGet_578971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_AppengineAppsLocationsGet_578971; locationsId: string;
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
  var path_578989 = newJObject()
  var query_578990 = newJObject()
  add(query_578990, "key", newJString(key))
  add(query_578990, "prettyPrint", newJBool(prettyPrint))
  add(query_578990, "oauth_token", newJString(oauthToken))
  add(query_578990, "$.xgafv", newJString(Xgafv))
  add(path_578989, "locationsId", newJString(locationsId))
  add(query_578990, "alt", newJString(alt))
  add(query_578990, "uploadType", newJString(uploadType))
  add(path_578989, "appsId", newJString(appsId))
  add(query_578990, "quotaUser", newJString(quotaUser))
  add(query_578990, "callback", newJString(callback))
  add(query_578990, "fields", newJString(fields))
  add(query_578990, "access_token", newJString(accessToken))
  add(query_578990, "upload_protocol", newJString(uploadProtocol))
  result = call_578988.call(path_578989, query_578990, nil, nil, nil)

var appengineAppsLocationsGet* = Call_AppengineAppsLocationsGet_578971(
    name: "appengineAppsLocationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/locations/{locationsId}",
    validator: validate_AppengineAppsLocationsGet_578972, base: "/",
    url: url_AppengineAppsLocationsGet_578973, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsList_578991 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsOperationsList_578993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsOperationsList_578992(path: JsonNode; query: JsonNode;
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
  var valid_578994 = path.getOrDefault("appsId")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "appsId", valid_578994
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
  var valid_578995 = query.getOrDefault("key")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "key", valid_578995
  var valid_578996 = query.getOrDefault("prettyPrint")
  valid_578996 = validateParameter(valid_578996, JBool, required = false,
                                 default = newJBool(true))
  if valid_578996 != nil:
    section.add "prettyPrint", valid_578996
  var valid_578997 = query.getOrDefault("oauth_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "oauth_token", valid_578997
  var valid_578998 = query.getOrDefault("$.xgafv")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("1"))
  if valid_578998 != nil:
    section.add "$.xgafv", valid_578998
  var valid_578999 = query.getOrDefault("pageSize")
  valid_578999 = validateParameter(valid_578999, JInt, required = false, default = nil)
  if valid_578999 != nil:
    section.add "pageSize", valid_578999
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
  var valid_579003 = query.getOrDefault("filter")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "filter", valid_579003
  var valid_579004 = query.getOrDefault("pageToken")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "pageToken", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579009: Call_AppengineAppsOperationsList_578991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the server doesn't support this method, it returns UNIMPLEMENTED.NOTE: the name binding allows API services to override the binding to use different resource name schemes, such as users/*/operations. To override the binding, API services can add a binding such as "/v1/{name=users/*}/operations" to their service configuration. For backwards compatibility, the default name includes the operations collection id, however overriding users must ensure the name binding is the parent resource, without the operations collection id.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_AppengineAppsOperationsList_578991; appsId: string;
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
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "pageSize", newJInt(pageSize))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "uploadType", newJString(uploadType))
  add(path_579011, "appsId", newJString(appsId))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(query_579012, "filter", newJString(filter))
  add(query_579012, "pageToken", newJString(pageToken))
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  result = call_579010.call(path_579011, query_579012, nil, nil, nil)

var appengineAppsOperationsList* = Call_AppengineAppsOperationsList_578991(
    name: "appengineAppsOperationsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/operations",
    validator: validate_AppengineAppsOperationsList_578992, base: "/",
    url: url_AppengineAppsOperationsList_578993, schemes: {Scheme.Https})
type
  Call_AppengineAppsOperationsGet_579013 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsOperationsGet_579015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsOperationsGet_579014(path: JsonNode; query: JsonNode;
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
  var valid_579016 = path.getOrDefault("appsId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "appsId", valid_579016
  var valid_579017 = path.getOrDefault("operationsId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "operationsId", valid_579017
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
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("callback")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "callback", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("access_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "access_token", valid_579027
  var valid_579028 = query.getOrDefault("upload_protocol")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "upload_protocol", valid_579028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579029: Call_AppengineAppsOperationsGet_579013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation. Clients can use this method to poll the operation result at intervals as recommended by the API service.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_AppengineAppsOperationsGet_579013; appsId: string;
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
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "$.xgafv", newJString(Xgafv))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "uploadType", newJString(uploadType))
  add(path_579031, "appsId", newJString(appsId))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(path_579031, "operationsId", newJString(operationsId))
  add(query_579032, "callback", newJString(callback))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "access_token", newJString(accessToken))
  add(query_579032, "upload_protocol", newJString(uploadProtocol))
  result = call_579030.call(path_579031, query_579032, nil, nil, nil)

var appengineAppsOperationsGet* = Call_AppengineAppsOperationsGet_579013(
    name: "appengineAppsOperationsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/operations/{operationsId}",
    validator: validate_AppengineAppsOperationsGet_579014, base: "/",
    url: url_AppengineAppsOperationsGet_579015, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesList_579033 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesList_579035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesList_579034(path: JsonNode; query: JsonNode;
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
  var valid_579036 = path.getOrDefault("appsId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "appsId", valid_579036
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
  var valid_579041 = query.getOrDefault("pageSize")
  valid_579041 = validateParameter(valid_579041, JInt, required = false, default = nil)
  if valid_579041 != nil:
    section.add "pageSize", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("uploadType")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "uploadType", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("pageToken")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "pageToken", valid_579045
  var valid_579046 = query.getOrDefault("callback")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "callback", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("access_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "access_token", valid_579048
  var valid_579049 = query.getOrDefault("upload_protocol")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "upload_protocol", valid_579049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579050: Call_AppengineAppsServicesList_579033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the services in the application.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_AppengineAppsServicesList_579033; appsId: string;
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp.
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
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "$.xgafv", newJString(Xgafv))
  add(query_579053, "pageSize", newJInt(pageSize))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "uploadType", newJString(uploadType))
  add(path_579052, "appsId", newJString(appsId))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(query_579053, "pageToken", newJString(pageToken))
  add(query_579053, "callback", newJString(callback))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, nil)

var appengineAppsServicesList* = Call_AppengineAppsServicesList_579033(
    name: "appengineAppsServicesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services",
    validator: validate_AppengineAppsServicesList_579034, base: "/",
    url: url_AppengineAppsServicesList_579035, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesGet_579054 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesGet_579056(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesGet_579055(path: JsonNode; query: JsonNode;
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
  var valid_579057 = path.getOrDefault("appsId")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "appsId", valid_579057
  var valid_579058 = path.getOrDefault("servicesId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "servicesId", valid_579058
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
  var valid_579063 = query.getOrDefault("alt")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("json"))
  if valid_579063 != nil:
    section.add "alt", valid_579063
  var valid_579064 = query.getOrDefault("uploadType")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "uploadType", valid_579064
  var valid_579065 = query.getOrDefault("quotaUser")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "quotaUser", valid_579065
  var valid_579066 = query.getOrDefault("callback")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "callback", valid_579066
  var valid_579067 = query.getOrDefault("fields")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fields", valid_579067
  var valid_579068 = query.getOrDefault("access_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "access_token", valid_579068
  var valid_579069 = query.getOrDefault("upload_protocol")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "upload_protocol", valid_579069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579070: Call_AppengineAppsServicesGet_579054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current configuration of the specified service.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_AppengineAppsServicesGet_579054; appsId: string;
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
  var path_579072 = newJObject()
  var query_579073 = newJObject()
  add(query_579073, "key", newJString(key))
  add(query_579073, "prettyPrint", newJBool(prettyPrint))
  add(query_579073, "oauth_token", newJString(oauthToken))
  add(query_579073, "$.xgafv", newJString(Xgafv))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "uploadType", newJString(uploadType))
  add(path_579072, "appsId", newJString(appsId))
  add(query_579073, "quotaUser", newJString(quotaUser))
  add(query_579073, "callback", newJString(callback))
  add(path_579072, "servicesId", newJString(servicesId))
  add(query_579073, "fields", newJString(fields))
  add(query_579073, "access_token", newJString(accessToken))
  add(query_579073, "upload_protocol", newJString(uploadProtocol))
  result = call_579071.call(path_579072, query_579073, nil, nil, nil)

var appengineAppsServicesGet* = Call_AppengineAppsServicesGet_579054(
    name: "appengineAppsServicesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesGet_579055, base: "/",
    url: url_AppengineAppsServicesGet_579056, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesPatch_579094 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesPatch_579096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesPatch_579095(path: JsonNode; query: JsonNode;
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
  var valid_579097 = path.getOrDefault("appsId")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "appsId", valid_579097
  var valid_579098 = path.getOrDefault("servicesId")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "servicesId", valid_579098
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
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services#shardby) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
  ## (https://cloud.google.com/appengine/docs/admin-api/migrating-splitting-traffic).
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("migrateTraffic")
  valid_579102 = validateParameter(valid_579102, JBool, required = false, default = nil)
  if valid_579102 != nil:
    section.add "migrateTraffic", valid_579102
  var valid_579103 = query.getOrDefault("$.xgafv")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("1"))
  if valid_579103 != nil:
    section.add "$.xgafv", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("uploadType")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "uploadType", valid_579105
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("mask")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "mask", valid_579107
  var valid_579108 = query.getOrDefault("callback")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "callback", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  var valid_579110 = query.getOrDefault("access_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "access_token", valid_579110
  var valid_579111 = query.getOrDefault("upload_protocol")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "upload_protocol", valid_579111
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

proc call*(call_579113: Call_AppengineAppsServicesPatch_579094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the configuration of the specified service.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_AppengineAppsServicesPatch_579094; appsId: string;
          servicesId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; migrateTraffic: bool = false; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          mask: string = ""; body: JsonNode = nil; callback: string = "";
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
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#inboundservicetype) and automatic scaling 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#automaticscaling). You must specify the shardBy 
  ## (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services#shardby) field in the Service resource. Gradual traffic migration is not supported in the App Engine flexible environment. For examples, see Migrating and Splitting Traffic 
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
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
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  var body_579117 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(query_579116, "migrateTraffic", newJBool(migrateTraffic))
  add(query_579116, "$.xgafv", newJString(Xgafv))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "uploadType", newJString(uploadType))
  add(path_579115, "appsId", newJString(appsId))
  add(query_579116, "quotaUser", newJString(quotaUser))
  add(query_579116, "mask", newJString(mask))
  if body != nil:
    body_579117 = body
  add(query_579116, "callback", newJString(callback))
  add(path_579115, "servicesId", newJString(servicesId))
  add(query_579116, "fields", newJString(fields))
  add(query_579116, "access_token", newJString(accessToken))
  add(query_579116, "upload_protocol", newJString(uploadProtocol))
  result = call_579114.call(path_579115, query_579116, nil, nil, body_579117)

var appengineAppsServicesPatch* = Call_AppengineAppsServicesPatch_579094(
    name: "appengineAppsServicesPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesPatch_579095, base: "/",
    url: url_AppengineAppsServicesPatch_579096, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesDelete_579074 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesDelete_579076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesDelete_579075(path: JsonNode; query: JsonNode;
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
  var valid_579077 = path.getOrDefault("appsId")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "appsId", valid_579077
  var valid_579078 = path.getOrDefault("servicesId")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "servicesId", valid_579078
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
  var valid_579079 = query.getOrDefault("key")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "key", valid_579079
  var valid_579080 = query.getOrDefault("prettyPrint")
  valid_579080 = validateParameter(valid_579080, JBool, required = false,
                                 default = newJBool(true))
  if valid_579080 != nil:
    section.add "prettyPrint", valid_579080
  var valid_579081 = query.getOrDefault("oauth_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "oauth_token", valid_579081
  var valid_579082 = query.getOrDefault("$.xgafv")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("1"))
  if valid_579082 != nil:
    section.add "$.xgafv", valid_579082
  var valid_579083 = query.getOrDefault("alt")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("json"))
  if valid_579083 != nil:
    section.add "alt", valid_579083
  var valid_579084 = query.getOrDefault("uploadType")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "uploadType", valid_579084
  var valid_579085 = query.getOrDefault("quotaUser")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "quotaUser", valid_579085
  var valid_579086 = query.getOrDefault("callback")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "callback", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  var valid_579088 = query.getOrDefault("access_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "access_token", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579090: Call_AppengineAppsServicesDelete_579074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified service and all enclosed versions.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_AppengineAppsServicesDelete_579074; appsId: string;
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
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(path_579092, "appsId", newJString(appsId))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "servicesId", newJString(servicesId))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, nil)

var appengineAppsServicesDelete* = Call_AppengineAppsServicesDelete_579074(
    name: "appengineAppsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}",
    validator: validate_AppengineAppsServicesDelete_579075, base: "/",
    url: url_AppengineAppsServicesDelete_579076, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsCreate_579141 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsCreate_579143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsCreate_579142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deploys new code and resource files to a new version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. For example: "apps/myapp/services/default".
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appsId` field"
  var valid_579144 = path.getOrDefault("appsId")
  valid_579144 = validateParameter(valid_579144, JString, required = true,
                                 default = nil)
  if valid_579144 != nil:
    section.add "appsId", valid_579144
  var valid_579145 = path.getOrDefault("servicesId")
  valid_579145 = validateParameter(valid_579145, JString, required = true,
                                 default = nil)
  if valid_579145 != nil:
    section.add "servicesId", valid_579145
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
  var valid_579146 = query.getOrDefault("key")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "key", valid_579146
  var valid_579147 = query.getOrDefault("prettyPrint")
  valid_579147 = validateParameter(valid_579147, JBool, required = false,
                                 default = newJBool(true))
  if valid_579147 != nil:
    section.add "prettyPrint", valid_579147
  var valid_579148 = query.getOrDefault("oauth_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "oauth_token", valid_579148
  var valid_579149 = query.getOrDefault("$.xgafv")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("1"))
  if valid_579149 != nil:
    section.add "$.xgafv", valid_579149
  var valid_579150 = query.getOrDefault("alt")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("json"))
  if valid_579150 != nil:
    section.add "alt", valid_579150
  var valid_579151 = query.getOrDefault("uploadType")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "uploadType", valid_579151
  var valid_579152 = query.getOrDefault("quotaUser")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "quotaUser", valid_579152
  var valid_579153 = query.getOrDefault("callback")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "callback", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  var valid_579155 = query.getOrDefault("access_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "access_token", valid_579155
  var valid_579156 = query.getOrDefault("upload_protocol")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "upload_protocol", valid_579156
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

proc call*(call_579158: Call_AppengineAppsServicesVersionsCreate_579141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deploys new code and resource files to a new version.
  ## 
  let valid = call_579158.validator(path, query, header, formData, body)
  let scheme = call_579158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579158.url(scheme.get, call_579158.host, call_579158.base,
                         call_579158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579158, url, valid)

proc call*(call_579159: Call_AppengineAppsServicesVersionsCreate_579141;
          appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsCreate
  ## Deploys new code and resource files to a new version.
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
  ##         : Part of `name`. Name of the resource to update. For example: "apps/myapp/services/default".
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  var path_579160 = newJObject()
  var query_579161 = newJObject()
  var body_579162 = newJObject()
  add(query_579161, "key", newJString(key))
  add(query_579161, "prettyPrint", newJBool(prettyPrint))
  add(query_579161, "oauth_token", newJString(oauthToken))
  add(query_579161, "$.xgafv", newJString(Xgafv))
  add(query_579161, "alt", newJString(alt))
  add(query_579161, "uploadType", newJString(uploadType))
  add(path_579160, "appsId", newJString(appsId))
  add(query_579161, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579162 = body
  add(query_579161, "callback", newJString(callback))
  add(path_579160, "servicesId", newJString(servicesId))
  add(query_579161, "fields", newJString(fields))
  add(query_579161, "access_token", newJString(accessToken))
  add(query_579161, "upload_protocol", newJString(uploadProtocol))
  result = call_579159.call(path_579160, query_579161, nil, nil, body_579162)

var appengineAppsServicesVersionsCreate* = Call_AppengineAppsServicesVersionsCreate_579141(
    name: "appengineAppsServicesVersionsCreate", meth: HttpMethod.HttpPost,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsCreate_579142, base: "/",
    url: url_AppengineAppsServicesVersionsCreate_579143, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsList_579118 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsList_579120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsList_579119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the versions of a service.
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
  var valid_579121 = path.getOrDefault("appsId")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "appsId", valid_579121
  var valid_579122 = path.getOrDefault("servicesId")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "servicesId", valid_579122
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
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("$.xgafv")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("1"))
  if valid_579126 != nil:
    section.add "$.xgafv", valid_579126
  var valid_579127 = query.getOrDefault("pageSize")
  valid_579127 = validateParameter(valid_579127, JInt, required = false, default = nil)
  if valid_579127 != nil:
    section.add "pageSize", valid_579127
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
  var valid_579131 = query.getOrDefault("pageToken")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "pageToken", valid_579131
  var valid_579132 = query.getOrDefault("callback")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "callback", valid_579132
  var valid_579133 = query.getOrDefault("fields")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "fields", valid_579133
  var valid_579134 = query.getOrDefault("access_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "access_token", valid_579134
  var valid_579135 = query.getOrDefault("upload_protocol")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "upload_protocol", valid_579135
  var valid_579136 = query.getOrDefault("view")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579136 != nil:
    section.add "view", valid_579136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579137: Call_AppengineAppsServicesVersionsList_579118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the versions of a service.
  ## 
  let valid = call_579137.validator(path, query, header, formData, body)
  let scheme = call_579137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579137.url(scheme.get, call_579137.host, call_579137.base,
                         call_579137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579137, url, valid)

proc call*(call_579138: Call_AppengineAppsServicesVersionsList_579118;
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
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##       : Controls the set of fields returned in the List response.
  var path_579139 = newJObject()
  var query_579140 = newJObject()
  add(query_579140, "key", newJString(key))
  add(query_579140, "prettyPrint", newJBool(prettyPrint))
  add(query_579140, "oauth_token", newJString(oauthToken))
  add(query_579140, "$.xgafv", newJString(Xgafv))
  add(query_579140, "pageSize", newJInt(pageSize))
  add(query_579140, "alt", newJString(alt))
  add(query_579140, "uploadType", newJString(uploadType))
  add(path_579139, "appsId", newJString(appsId))
  add(query_579140, "quotaUser", newJString(quotaUser))
  add(query_579140, "pageToken", newJString(pageToken))
  add(query_579140, "callback", newJString(callback))
  add(path_579139, "servicesId", newJString(servicesId))
  add(query_579140, "fields", newJString(fields))
  add(query_579140, "access_token", newJString(accessToken))
  add(query_579140, "upload_protocol", newJString(uploadProtocol))
  add(query_579140, "view", newJString(view))
  result = call_579138.call(path_579139, query_579140, nil, nil, nil)

var appengineAppsServicesVersionsList* = Call_AppengineAppsServicesVersionsList_579118(
    name: "appengineAppsServicesVersionsList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com",
    route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions",
    validator: validate_AppengineAppsServicesVersionsList_579119, base: "/",
    url: url_AppengineAppsServicesVersionsList_579120, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsGet_579163 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsGet_579165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsGet_579164(path: JsonNode;
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
  var valid_579166 = path.getOrDefault("versionsId")
  valid_579166 = validateParameter(valid_579166, JString, required = true,
                                 default = nil)
  if valid_579166 != nil:
    section.add "versionsId", valid_579166
  var valid_579167 = path.getOrDefault("appsId")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "appsId", valid_579167
  var valid_579168 = path.getOrDefault("servicesId")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "servicesId", valid_579168
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
  var valid_579169 = query.getOrDefault("key")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "key", valid_579169
  var valid_579170 = query.getOrDefault("prettyPrint")
  valid_579170 = validateParameter(valid_579170, JBool, required = false,
                                 default = newJBool(true))
  if valid_579170 != nil:
    section.add "prettyPrint", valid_579170
  var valid_579171 = query.getOrDefault("oauth_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "oauth_token", valid_579171
  var valid_579172 = query.getOrDefault("$.xgafv")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("1"))
  if valid_579172 != nil:
    section.add "$.xgafv", valid_579172
  var valid_579173 = query.getOrDefault("alt")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("json"))
  if valid_579173 != nil:
    section.add "alt", valid_579173
  var valid_579174 = query.getOrDefault("uploadType")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "uploadType", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("callback")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "callback", valid_579176
  var valid_579177 = query.getOrDefault("fields")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "fields", valid_579177
  var valid_579178 = query.getOrDefault("access_token")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "access_token", valid_579178
  var valid_579179 = query.getOrDefault("upload_protocol")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "upload_protocol", valid_579179
  var valid_579180 = query.getOrDefault("view")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579180 != nil:
    section.add "view", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_AppengineAppsServicesVersionsGet_579163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified Version resource. By default, only a BASIC_VIEW will be returned. Specify the FULL_VIEW parameter to get the full resource.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_AppengineAppsServicesVersionsGet_579163;
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
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "$.xgafv", newJString(Xgafv))
  add(path_579183, "versionsId", newJString(versionsId))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "uploadType", newJString(uploadType))
  add(path_579183, "appsId", newJString(appsId))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(query_579184, "callback", newJString(callback))
  add(path_579183, "servicesId", newJString(servicesId))
  add(query_579184, "fields", newJString(fields))
  add(query_579184, "access_token", newJString(accessToken))
  add(query_579184, "upload_protocol", newJString(uploadProtocol))
  add(query_579184, "view", newJString(view))
  result = call_579182.call(path_579183, query_579184, nil, nil, nil)

var appengineAppsServicesVersionsGet* = Call_AppengineAppsServicesVersionsGet_579163(
    name: "appengineAppsServicesVersionsGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsGet_579164, base: "/",
    url: url_AppengineAppsServicesVersionsGet_579165, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsPatch_579206 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsPatch_579208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsPatch_579207(path: JsonNode;
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
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource to update. Example: apps/myapp/services/default/versions/1.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579209 = path.getOrDefault("versionsId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "versionsId", valid_579209
  var valid_579210 = path.getOrDefault("appsId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "appsId", valid_579210
  var valid_579211 = path.getOrDefault("servicesId")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "servicesId", valid_579211
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
  ##   mask: JString
  ##       : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579212 = query.getOrDefault("key")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "key", valid_579212
  var valid_579213 = query.getOrDefault("prettyPrint")
  valid_579213 = validateParameter(valid_579213, JBool, required = false,
                                 default = newJBool(true))
  if valid_579213 != nil:
    section.add "prettyPrint", valid_579213
  var valid_579214 = query.getOrDefault("oauth_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "oauth_token", valid_579214
  var valid_579215 = query.getOrDefault("$.xgafv")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = newJString("1"))
  if valid_579215 != nil:
    section.add "$.xgafv", valid_579215
  var valid_579216 = query.getOrDefault("alt")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = newJString("json"))
  if valid_579216 != nil:
    section.add "alt", valid_579216
  var valid_579217 = query.getOrDefault("uploadType")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "uploadType", valid_579217
  var valid_579218 = query.getOrDefault("quotaUser")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "quotaUser", valid_579218
  var valid_579219 = query.getOrDefault("mask")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "mask", valid_579219
  var valid_579220 = query.getOrDefault("callback")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "callback", valid_579220
  var valid_579221 = query.getOrDefault("fields")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "fields", valid_579221
  var valid_579222 = query.getOrDefault("access_token")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "access_token", valid_579222
  var valid_579223 = query.getOrDefault("upload_protocol")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "upload_protocol", valid_579223
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

proc call*(call_579225: Call_AppengineAppsServicesVersionsPatch_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## 
  let valid = call_579225.validator(path, query, header, formData, body)
  let scheme = call_579225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579225.url(scheme.get, call_579225.host, call_579225.base,
                         call_579225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579225, url, valid)

proc call*(call_579226: Call_AppengineAppsServicesVersionsPatch_579206;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          mask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsPatch
  ## Updates the specified Version resource. You can specify the following fields depending on the App Engine environment and type of scaling that the version resource uses:
  ## serving_status (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.serving_status):  For Version resources that use basic scaling, manual scaling, or run in  the App Engine flexible environment.
  ## instance_class (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.instance_class):  For Version resources that run in the App Engine standard environment.
  ## automatic_scaling.min_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
  ## automatic_scaling.max_idle_instances (https://cloud.google.com/appengine/docs/admin-api/reference/rest/v1beta5/apps.services.versions#Version.FIELDS.automatic_scaling):  For Version resources that use automatic scaling and run in the App  Engine standard environment.
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
  ##   mask: string
  ##       : Standard field mask for the set of fields to be updated.
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
  var path_579227 = newJObject()
  var query_579228 = newJObject()
  var body_579229 = newJObject()
  add(query_579228, "key", newJString(key))
  add(query_579228, "prettyPrint", newJBool(prettyPrint))
  add(query_579228, "oauth_token", newJString(oauthToken))
  add(query_579228, "$.xgafv", newJString(Xgafv))
  add(path_579227, "versionsId", newJString(versionsId))
  add(query_579228, "alt", newJString(alt))
  add(query_579228, "uploadType", newJString(uploadType))
  add(path_579227, "appsId", newJString(appsId))
  add(query_579228, "quotaUser", newJString(quotaUser))
  add(query_579228, "mask", newJString(mask))
  if body != nil:
    body_579229 = body
  add(query_579228, "callback", newJString(callback))
  add(path_579227, "servicesId", newJString(servicesId))
  add(query_579228, "fields", newJString(fields))
  add(query_579228, "access_token", newJString(accessToken))
  add(query_579228, "upload_protocol", newJString(uploadProtocol))
  result = call_579226.call(path_579227, query_579228, nil, nil, body_579229)

var appengineAppsServicesVersionsPatch* = Call_AppengineAppsServicesVersionsPatch_579206(
    name: "appengineAppsServicesVersionsPatch", meth: HttpMethod.HttpPatch,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsPatch_579207, base: "/",
    url: url_AppengineAppsServicesVersionsPatch_579208, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsDelete_579185 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsDelete_579187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsDelete_579186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing version.
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
  var valid_579188 = path.getOrDefault("versionsId")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "versionsId", valid_579188
  var valid_579189 = path.getOrDefault("appsId")
  valid_579189 = validateParameter(valid_579189, JString, required = true,
                                 default = nil)
  if valid_579189 != nil:
    section.add "appsId", valid_579189
  var valid_579190 = path.getOrDefault("servicesId")
  valid_579190 = validateParameter(valid_579190, JString, required = true,
                                 default = nil)
  if valid_579190 != nil:
    section.add "servicesId", valid_579190
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
  var valid_579191 = query.getOrDefault("key")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "key", valid_579191
  var valid_579192 = query.getOrDefault("prettyPrint")
  valid_579192 = validateParameter(valid_579192, JBool, required = false,
                                 default = newJBool(true))
  if valid_579192 != nil:
    section.add "prettyPrint", valid_579192
  var valid_579193 = query.getOrDefault("oauth_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "oauth_token", valid_579193
  var valid_579194 = query.getOrDefault("$.xgafv")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = newJString("1"))
  if valid_579194 != nil:
    section.add "$.xgafv", valid_579194
  var valid_579195 = query.getOrDefault("alt")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("json"))
  if valid_579195 != nil:
    section.add "alt", valid_579195
  var valid_579196 = query.getOrDefault("uploadType")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "uploadType", valid_579196
  var valid_579197 = query.getOrDefault("quotaUser")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "quotaUser", valid_579197
  var valid_579198 = query.getOrDefault("callback")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "callback", valid_579198
  var valid_579199 = query.getOrDefault("fields")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "fields", valid_579199
  var valid_579200 = query.getOrDefault("access_token")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "access_token", valid_579200
  var valid_579201 = query.getOrDefault("upload_protocol")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "upload_protocol", valid_579201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579202: Call_AppengineAppsServicesVersionsDelete_579185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing version.
  ## 
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_AppengineAppsServicesVersionsDelete_579185;
          versionsId: string; appsId: string; servicesId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## appengineAppsServicesVersionsDelete
  ## Deletes an existing version.
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
  var path_579204 = newJObject()
  var query_579205 = newJObject()
  add(query_579205, "key", newJString(key))
  add(query_579205, "prettyPrint", newJBool(prettyPrint))
  add(query_579205, "oauth_token", newJString(oauthToken))
  add(query_579205, "$.xgafv", newJString(Xgafv))
  add(path_579204, "versionsId", newJString(versionsId))
  add(query_579205, "alt", newJString(alt))
  add(query_579205, "uploadType", newJString(uploadType))
  add(path_579204, "appsId", newJString(appsId))
  add(query_579205, "quotaUser", newJString(quotaUser))
  add(query_579205, "callback", newJString(callback))
  add(path_579204, "servicesId", newJString(servicesId))
  add(query_579205, "fields", newJString(fields))
  add(query_579205, "access_token", newJString(accessToken))
  add(query_579205, "upload_protocol", newJString(uploadProtocol))
  result = call_579203.call(path_579204, query_579205, nil, nil, nil)

var appengineAppsServicesVersionsDelete* = Call_AppengineAppsServicesVersionsDelete_579185(
    name: "appengineAppsServicesVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}",
    validator: validate_AppengineAppsServicesVersionsDelete_579186, base: "/",
    url: url_AppengineAppsServicesVersionsDelete_579187, schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesList_579230 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesList_579232(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AppengineAppsServicesVersionsInstancesList_579231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
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
  var valid_579233 = path.getOrDefault("versionsId")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "versionsId", valid_579233
  var valid_579234 = path.getOrDefault("appsId")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = nil)
  if valid_579234 != nil:
    section.add "appsId", valid_579234
  var valid_579235 = path.getOrDefault("servicesId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "servicesId", valid_579235
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
  var valid_579236 = query.getOrDefault("key")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "key", valid_579236
  var valid_579237 = query.getOrDefault("prettyPrint")
  valid_579237 = validateParameter(valid_579237, JBool, required = false,
                                 default = newJBool(true))
  if valid_579237 != nil:
    section.add "prettyPrint", valid_579237
  var valid_579238 = query.getOrDefault("oauth_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "oauth_token", valid_579238
  var valid_579239 = query.getOrDefault("$.xgafv")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("1"))
  if valid_579239 != nil:
    section.add "$.xgafv", valid_579239
  var valid_579240 = query.getOrDefault("pageSize")
  valid_579240 = validateParameter(valid_579240, JInt, required = false, default = nil)
  if valid_579240 != nil:
    section.add "pageSize", valid_579240
  var valid_579241 = query.getOrDefault("alt")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("json"))
  if valid_579241 != nil:
    section.add "alt", valid_579241
  var valid_579242 = query.getOrDefault("uploadType")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "uploadType", valid_579242
  var valid_579243 = query.getOrDefault("quotaUser")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "quotaUser", valid_579243
  var valid_579244 = query.getOrDefault("pageToken")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "pageToken", valid_579244
  var valid_579245 = query.getOrDefault("callback")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "callback", valid_579245
  var valid_579246 = query.getOrDefault("fields")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "fields", valid_579246
  var valid_579247 = query.getOrDefault("access_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "access_token", valid_579247
  var valid_579248 = query.getOrDefault("upload_protocol")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "upload_protocol", valid_579248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579249: Call_AppengineAppsServicesVersionsInstancesList_579230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the instances of a version.Tip: To aggregate details about instances over time, see the Stackdriver Monitoring API (https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.timeSeries/list).
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_AppengineAppsServicesVersionsInstancesList_579230;
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
  ##             : Part of `name`. See documentation of `appsId`.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   appsId: string (required)
  ##         : Part of `name`. Name of the resource requested. Example: apps/myapp/services/default/versions/v1.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  var path_579251 = newJObject()
  var query_579252 = newJObject()
  add(query_579252, "key", newJString(key))
  add(query_579252, "prettyPrint", newJBool(prettyPrint))
  add(query_579252, "oauth_token", newJString(oauthToken))
  add(query_579252, "$.xgafv", newJString(Xgafv))
  add(path_579251, "versionsId", newJString(versionsId))
  add(query_579252, "pageSize", newJInt(pageSize))
  add(query_579252, "alt", newJString(alt))
  add(query_579252, "uploadType", newJString(uploadType))
  add(path_579251, "appsId", newJString(appsId))
  add(query_579252, "quotaUser", newJString(quotaUser))
  add(query_579252, "pageToken", newJString(pageToken))
  add(query_579252, "callback", newJString(callback))
  add(path_579251, "servicesId", newJString(servicesId))
  add(query_579252, "fields", newJString(fields))
  add(query_579252, "access_token", newJString(accessToken))
  add(query_579252, "upload_protocol", newJString(uploadProtocol))
  result = call_579250.call(path_579251, query_579252, nil, nil, nil)

var appengineAppsServicesVersionsInstancesList* = Call_AppengineAppsServicesVersionsInstancesList_579230(
    name: "appengineAppsServicesVersionsInstancesList", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances",
    validator: validate_AppengineAppsServicesVersionsInstancesList_579231,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesList_579232,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesGet_579253 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesGet_579255(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesGet_579254(path: JsonNode;
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
  var valid_579256 = path.getOrDefault("versionsId")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "versionsId", valid_579256
  var valid_579257 = path.getOrDefault("appsId")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "appsId", valid_579257
  var valid_579258 = path.getOrDefault("instancesId")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "instancesId", valid_579258
  var valid_579259 = path.getOrDefault("servicesId")
  valid_579259 = validateParameter(valid_579259, JString, required = true,
                                 default = nil)
  if valid_579259 != nil:
    section.add "servicesId", valid_579259
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
  var valid_579260 = query.getOrDefault("key")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "key", valid_579260
  var valid_579261 = query.getOrDefault("prettyPrint")
  valid_579261 = validateParameter(valid_579261, JBool, required = false,
                                 default = newJBool(true))
  if valid_579261 != nil:
    section.add "prettyPrint", valid_579261
  var valid_579262 = query.getOrDefault("oauth_token")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "oauth_token", valid_579262
  var valid_579263 = query.getOrDefault("$.xgafv")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("1"))
  if valid_579263 != nil:
    section.add "$.xgafv", valid_579263
  var valid_579264 = query.getOrDefault("alt")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("json"))
  if valid_579264 != nil:
    section.add "alt", valid_579264
  var valid_579265 = query.getOrDefault("uploadType")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "uploadType", valid_579265
  var valid_579266 = query.getOrDefault("quotaUser")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "quotaUser", valid_579266
  var valid_579267 = query.getOrDefault("callback")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "callback", valid_579267
  var valid_579268 = query.getOrDefault("fields")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "fields", valid_579268
  var valid_579269 = query.getOrDefault("access_token")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "access_token", valid_579269
  var valid_579270 = query.getOrDefault("upload_protocol")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "upload_protocol", valid_579270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579271: Call_AppengineAppsServicesVersionsInstancesGet_579253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets instance information.
  ## 
  let valid = call_579271.validator(path, query, header, formData, body)
  let scheme = call_579271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579271.url(scheme.get, call_579271.host, call_579271.base,
                         call_579271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579271, url, valid)

proc call*(call_579272: Call_AppengineAppsServicesVersionsInstancesGet_579253;
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
  var path_579273 = newJObject()
  var query_579274 = newJObject()
  add(query_579274, "key", newJString(key))
  add(query_579274, "prettyPrint", newJBool(prettyPrint))
  add(query_579274, "oauth_token", newJString(oauthToken))
  add(query_579274, "$.xgafv", newJString(Xgafv))
  add(path_579273, "versionsId", newJString(versionsId))
  add(query_579274, "alt", newJString(alt))
  add(query_579274, "uploadType", newJString(uploadType))
  add(path_579273, "appsId", newJString(appsId))
  add(query_579274, "quotaUser", newJString(quotaUser))
  add(path_579273, "instancesId", newJString(instancesId))
  add(query_579274, "callback", newJString(callback))
  add(path_579273, "servicesId", newJString(servicesId))
  add(query_579274, "fields", newJString(fields))
  add(query_579274, "access_token", newJString(accessToken))
  add(query_579274, "upload_protocol", newJString(uploadProtocol))
  result = call_579272.call(path_579273, query_579274, nil, nil, nil)

var appengineAppsServicesVersionsInstancesGet* = Call_AppengineAppsServicesVersionsInstancesGet_579253(
    name: "appengineAppsServicesVersionsInstancesGet", meth: HttpMethod.HttpGet,
    host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesGet_579254,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesGet_579255,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDelete_579275 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesDelete_579277(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesDelete_579276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a running instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionsId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  ##   appsId: JString (required)
  ##         : Part of `name`. Name of the resource requested. For example: "apps/myapp/services/default/versions/v1/instances/instance-1".
  ##   instancesId: JString (required)
  ##              : Part of `name`. See documentation of `appsId`.
  ##   servicesId: JString (required)
  ##             : Part of `name`. See documentation of `appsId`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionsId` field"
  var valid_579278 = path.getOrDefault("versionsId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "versionsId", valid_579278
  var valid_579279 = path.getOrDefault("appsId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "appsId", valid_579279
  var valid_579280 = path.getOrDefault("instancesId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "instancesId", valid_579280
  var valid_579281 = path.getOrDefault("servicesId")
  valid_579281 = validateParameter(valid_579281, JString, required = true,
                                 default = nil)
  if valid_579281 != nil:
    section.add "servicesId", valid_579281
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
  var valid_579282 = query.getOrDefault("key")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "key", valid_579282
  var valid_579283 = query.getOrDefault("prettyPrint")
  valid_579283 = validateParameter(valid_579283, JBool, required = false,
                                 default = newJBool(true))
  if valid_579283 != nil:
    section.add "prettyPrint", valid_579283
  var valid_579284 = query.getOrDefault("oauth_token")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "oauth_token", valid_579284
  var valid_579285 = query.getOrDefault("$.xgafv")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = newJString("1"))
  if valid_579285 != nil:
    section.add "$.xgafv", valid_579285
  var valid_579286 = query.getOrDefault("alt")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("json"))
  if valid_579286 != nil:
    section.add "alt", valid_579286
  var valid_579287 = query.getOrDefault("uploadType")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "uploadType", valid_579287
  var valid_579288 = query.getOrDefault("quotaUser")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "quotaUser", valid_579288
  var valid_579289 = query.getOrDefault("callback")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "callback", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  var valid_579291 = query.getOrDefault("access_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "access_token", valid_579291
  var valid_579292 = query.getOrDefault("upload_protocol")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "upload_protocol", valid_579292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579293: Call_AppengineAppsServicesVersionsInstancesDelete_579275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a running instance.
  ## 
  let valid = call_579293.validator(path, query, header, formData, body)
  let scheme = call_579293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579293.url(scheme.get, call_579293.host, call_579293.base,
                         call_579293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579293, url, valid)

proc call*(call_579294: Call_AppengineAppsServicesVersionsInstancesDelete_579275;
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
  ##         : Part of `name`. Name of the resource requested. For example: "apps/myapp/services/default/versions/v1/instances/instance-1".
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
  var path_579295 = newJObject()
  var query_579296 = newJObject()
  add(query_579296, "key", newJString(key))
  add(query_579296, "prettyPrint", newJBool(prettyPrint))
  add(query_579296, "oauth_token", newJString(oauthToken))
  add(query_579296, "$.xgafv", newJString(Xgafv))
  add(path_579295, "versionsId", newJString(versionsId))
  add(query_579296, "alt", newJString(alt))
  add(query_579296, "uploadType", newJString(uploadType))
  add(path_579295, "appsId", newJString(appsId))
  add(query_579296, "quotaUser", newJString(quotaUser))
  add(path_579295, "instancesId", newJString(instancesId))
  add(query_579296, "callback", newJString(callback))
  add(path_579295, "servicesId", newJString(servicesId))
  add(query_579296, "fields", newJString(fields))
  add(query_579296, "access_token", newJString(accessToken))
  add(query_579296, "upload_protocol", newJString(uploadProtocol))
  result = call_579294.call(path_579295, query_579296, nil, nil, nil)

var appengineAppsServicesVersionsInstancesDelete* = Call_AppengineAppsServicesVersionsInstancesDelete_579275(
    name: "appengineAppsServicesVersionsInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}",
    validator: validate_AppengineAppsServicesVersionsInstancesDelete_579276,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDelete_579277,
    schemes: {Scheme.Https})
type
  Call_AppengineAppsServicesVersionsInstancesDebug_579297 = ref object of OpenApiRestCall_578348
proc url_AppengineAppsServicesVersionsInstancesDebug_579299(protocol: Scheme;
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

proc validate_AppengineAppsServicesVersionsInstancesDebug_579298(path: JsonNode;
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
  var valid_579300 = path.getOrDefault("versionsId")
  valid_579300 = validateParameter(valid_579300, JString, required = true,
                                 default = nil)
  if valid_579300 != nil:
    section.add "versionsId", valid_579300
  var valid_579301 = path.getOrDefault("appsId")
  valid_579301 = validateParameter(valid_579301, JString, required = true,
                                 default = nil)
  if valid_579301 != nil:
    section.add "appsId", valid_579301
  var valid_579302 = path.getOrDefault("instancesId")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = nil)
  if valid_579302 != nil:
    section.add "instancesId", valid_579302
  var valid_579303 = path.getOrDefault("servicesId")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "servicesId", valid_579303
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
  var valid_579304 = query.getOrDefault("key")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "key", valid_579304
  var valid_579305 = query.getOrDefault("prettyPrint")
  valid_579305 = validateParameter(valid_579305, JBool, required = false,
                                 default = newJBool(true))
  if valid_579305 != nil:
    section.add "prettyPrint", valid_579305
  var valid_579306 = query.getOrDefault("oauth_token")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "oauth_token", valid_579306
  var valid_579307 = query.getOrDefault("$.xgafv")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = newJString("1"))
  if valid_579307 != nil:
    section.add "$.xgafv", valid_579307
  var valid_579308 = query.getOrDefault("alt")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = newJString("json"))
  if valid_579308 != nil:
    section.add "alt", valid_579308
  var valid_579309 = query.getOrDefault("uploadType")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "uploadType", valid_579309
  var valid_579310 = query.getOrDefault("quotaUser")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "quotaUser", valid_579310
  var valid_579311 = query.getOrDefault("callback")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "callback", valid_579311
  var valid_579312 = query.getOrDefault("fields")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "fields", valid_579312
  var valid_579313 = query.getOrDefault("access_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "access_token", valid_579313
  var valid_579314 = query.getOrDefault("upload_protocol")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "upload_protocol", valid_579314
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

proc call*(call_579316: Call_AppengineAppsServicesVersionsInstancesDebug_579297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables debugging on a VM instance. This allows you to use the SSH command to connect to the virtual machine where the instance lives. While in "debug mode", the instance continues to serve live traffic. You should delete the instance when you are done debugging and then allow the system to take over and determine if another instance should be started.Only applicable for instances in App Engine flexible environment.
  ## 
  let valid = call_579316.validator(path, query, header, formData, body)
  let scheme = call_579316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579316.url(scheme.get, call_579316.host, call_579316.base,
                         call_579316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579316, url, valid)

proc call*(call_579317: Call_AppengineAppsServicesVersionsInstancesDebug_579297;
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
  var path_579318 = newJObject()
  var query_579319 = newJObject()
  var body_579320 = newJObject()
  add(query_579319, "key", newJString(key))
  add(query_579319, "prettyPrint", newJBool(prettyPrint))
  add(query_579319, "oauth_token", newJString(oauthToken))
  add(query_579319, "$.xgafv", newJString(Xgafv))
  add(path_579318, "versionsId", newJString(versionsId))
  add(query_579319, "alt", newJString(alt))
  add(query_579319, "uploadType", newJString(uploadType))
  add(path_579318, "appsId", newJString(appsId))
  add(query_579319, "quotaUser", newJString(quotaUser))
  add(path_579318, "instancesId", newJString(instancesId))
  if body != nil:
    body_579320 = body
  add(query_579319, "callback", newJString(callback))
  add(path_579318, "servicesId", newJString(servicesId))
  add(query_579319, "fields", newJString(fields))
  add(query_579319, "access_token", newJString(accessToken))
  add(query_579319, "upload_protocol", newJString(uploadProtocol))
  result = call_579317.call(path_579318, query_579319, nil, nil, body_579320)

var appengineAppsServicesVersionsInstancesDebug* = Call_AppengineAppsServicesVersionsInstancesDebug_579297(
    name: "appengineAppsServicesVersionsInstancesDebug",
    meth: HttpMethod.HttpPost, host: "appengine.googleapis.com", route: "/v1beta5/apps/{appsId}/services/{servicesId}/versions/{versionsId}/instances/{instancesId}:debug",
    validator: validate_AppengineAppsServicesVersionsInstancesDebug_579298,
    base: "/", url: url_AppengineAppsServicesVersionsInstancesDebug_579299,
    schemes: {Scheme.Https})
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
