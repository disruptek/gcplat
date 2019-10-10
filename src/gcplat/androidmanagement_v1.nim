
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Android Management
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Android Management API provides remote enterprise management of Android devices and apps.
## 
## https://developers.google.com/android/management
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
  gcpServiceName = "androidmanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidmanagementEnterprisesCreate_588719 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesCreate_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementEnterprisesCreate_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
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
  ##   enterpriseToken: JString
  ##                  : The enterprise token appended to the callback URL.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   signupUrlName: JString
  ##                : The name of the SignupUrl used to sign up for the enterprise.
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
  var valid_588854 = query.getOrDefault("enterpriseToken")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "enterpriseToken", valid_588854
  var valid_588855 = query.getOrDefault("key")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "key", valid_588855
  var valid_588856 = query.getOrDefault("$.xgafv")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("1"))
  if valid_588856 != nil:
    section.add "$.xgafv", valid_588856
  var valid_588857 = query.getOrDefault("projectId")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "projectId", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
  var valid_588859 = query.getOrDefault("signupUrlName")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "signupUrlName", valid_588859
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

proc call*(call_588883: Call_AndroidmanagementEnterprisesCreate_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_AndroidmanagementEnterprisesCreate_588719;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          enterpriseToken: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          signupUrlName: string = ""): Recallable =
  ## androidmanagementEnterprisesCreate
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
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
  ##   enterpriseToken: string
  ##                  : The enterprise token appended to the callback URL.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   signupUrlName: string
  ##                : The name of the SignupUrl used to sign up for the enterprise.
  var query_588955 = newJObject()
  var body_588957 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "enterpriseToken", newJString(enterpriseToken))
  add(query_588955, "key", newJString(key))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "projectId", newJString(projectId))
  if body != nil:
    body_588957 = body
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "signupUrlName", newJString(signupUrlName))
  result = call_588954.call(nil, query_588955, nil, nil, body_588957)

var androidmanagementEnterprisesCreate* = Call_AndroidmanagementEnterprisesCreate_588719(
    name: "androidmanagementEnterprisesCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/enterprises",
    validator: validate_AndroidmanagementEnterprisesCreate_588720, base: "/",
    url: url_AndroidmanagementEnterprisesCreate_588721, schemes: {Scheme.Https})
type
  Call_AndroidmanagementSignupUrlsCreate_588996 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementSignupUrlsCreate_588998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementSignupUrlsCreate_588997(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an enterprise signup URL.
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
  ##   callbackUrl: JString
  ##              : The callback URL that the admin will be redirected to after successfully creating an enterprise. Before redirecting there the system will add a query parameter to this URL named enterpriseToken which will contain an opaque token to be used for the create enterprise request. The URL will be parsed then reformatted in order to add the enterpriseToken parameter, so there may be some minor formatting changes.
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
  ##   projectId: JString
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588999 = query.getOrDefault("upload_protocol")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "upload_protocol", valid_588999
  var valid_589000 = query.getOrDefault("fields")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "fields", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("callbackUrl")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "callbackUrl", valid_589002
  var valid_589003 = query.getOrDefault("alt")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = newJString("json"))
  if valid_589003 != nil:
    section.add "alt", valid_589003
  var valid_589004 = query.getOrDefault("oauth_token")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "oauth_token", valid_589004
  var valid_589005 = query.getOrDefault("callback")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "callback", valid_589005
  var valid_589006 = query.getOrDefault("access_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "access_token", valid_589006
  var valid_589007 = query.getOrDefault("uploadType")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "uploadType", valid_589007
  var valid_589008 = query.getOrDefault("key")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "key", valid_589008
  var valid_589009 = query.getOrDefault("$.xgafv")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("1"))
  if valid_589009 != nil:
    section.add "$.xgafv", valid_589009
  var valid_589010 = query.getOrDefault("projectId")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "projectId", valid_589010
  var valid_589011 = query.getOrDefault("prettyPrint")
  valid_589011 = validateParameter(valid_589011, JBool, required = false,
                                 default = newJBool(true))
  if valid_589011 != nil:
    section.add "prettyPrint", valid_589011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589012: Call_AndroidmanagementSignupUrlsCreate_588996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise signup URL.
  ## 
  let valid = call_589012.validator(path, query, header, formData, body)
  let scheme = call_589012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589012.url(scheme.get, call_589012.host, call_589012.base,
                         call_589012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589012, url, valid)

proc call*(call_589013: Call_AndroidmanagementSignupUrlsCreate_588996;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          callbackUrl: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidmanagementSignupUrlsCreate
  ## Creates an enterprise signup URL.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callbackUrl: string
  ##              : The callback URL that the admin will be redirected to after successfully creating an enterprise. Before redirecting there the system will add a query parameter to this URL named enterpriseToken which will contain an opaque token to be used for the create enterprise request. The URL will be parsed then reformatted in order to add the enterpriseToken parameter, so there may be some minor formatting changes.
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
  ##   projectId: string
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589014 = newJObject()
  add(query_589014, "upload_protocol", newJString(uploadProtocol))
  add(query_589014, "fields", newJString(fields))
  add(query_589014, "quotaUser", newJString(quotaUser))
  add(query_589014, "callbackUrl", newJString(callbackUrl))
  add(query_589014, "alt", newJString(alt))
  add(query_589014, "oauth_token", newJString(oauthToken))
  add(query_589014, "callback", newJString(callback))
  add(query_589014, "access_token", newJString(accessToken))
  add(query_589014, "uploadType", newJString(uploadType))
  add(query_589014, "key", newJString(key))
  add(query_589014, "$.xgafv", newJString(Xgafv))
  add(query_589014, "projectId", newJString(projectId))
  add(query_589014, "prettyPrint", newJBool(prettyPrint))
  result = call_589013.call(nil, query_589014, nil, nil, nil)

var androidmanagementSignupUrlsCreate* = Call_AndroidmanagementSignupUrlsCreate_588996(
    name: "androidmanagementSignupUrlsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/signupUrls",
    validator: validate_AndroidmanagementSignupUrlsCreate_588997, base: "/",
    url: url_AndroidmanagementSignupUrlsCreate_588998, schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsGet_589015 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesWebAppsGet_589017(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsGet_589016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApp/{packageName}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589032 = path.getOrDefault("name")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "name", valid_589032
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
  ##   languageCode: JString
  ##               : The preferred language for localized application info, as a BCP47 tag (e.g. "en-US", "de"). If not specified the default language of the application will be used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("languageCode")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "languageCode", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589045: Call_AndroidmanagementEnterprisesWebAppsGet_589015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web app.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_AndroidmanagementEnterprisesWebAppsGet_589015;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesWebAppsGet
  ## Gets a web app.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApp/{packageName}.
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
  ##   languageCode: string
  ##               : The preferred language for localized application info, as a BCP47 tag (e.g. "en-US", "de"). If not specified the default language of the application will be used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589047 = newJObject()
  var query_589048 = newJObject()
  add(query_589048, "upload_protocol", newJString(uploadProtocol))
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(path_589047, "name", newJString(name))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "callback", newJString(callback))
  add(query_589048, "access_token", newJString(accessToken))
  add(query_589048, "uploadType", newJString(uploadType))
  add(query_589048, "key", newJString(key))
  add(query_589048, "$.xgafv", newJString(Xgafv))
  add(query_589048, "languageCode", newJString(languageCode))
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589046.call(path_589047, query_589048, nil, nil, nil)

var androidmanagementEnterprisesWebAppsGet* = Call_AndroidmanagementEnterprisesWebAppsGet_589015(
    name: "androidmanagementEnterprisesWebAppsGet", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsGet_589016, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsGet_589017,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsPatch_589069 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesWebAppsPatch_589071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsPatch_589070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApps/{packageName}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589072 = path.getOrDefault("name")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "name", valid_589072
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
  ##             : The field mask indicating the fields to update. If not set, all modifiable fields will be modified.
  section = newJObject()
  var valid_589073 = query.getOrDefault("upload_protocol")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "upload_protocol", valid_589073
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("$.xgafv")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("1"))
  if valid_589082 != nil:
    section.add "$.xgafv", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
  var valid_589084 = query.getOrDefault("updateMask")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "updateMask", valid_589084
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

proc call*(call_589086: Call_AndroidmanagementEnterprisesWebAppsPatch_589069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a web app.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_AndroidmanagementEnterprisesWebAppsPatch_589069;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## androidmanagementEnterprisesWebAppsPatch
  ## Updates a web app.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApps/{packageName}.
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
  ##   updateMask: string
  ##             : The field mask indicating the fields to update. If not set, all modifiable fields will be modified.
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  var body_589090 = newJObject()
  add(query_589089, "upload_protocol", newJString(uploadProtocol))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(path_589088, "name", newJString(name))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "callback", newJString(callback))
  add(query_589089, "access_token", newJString(accessToken))
  add(query_589089, "uploadType", newJString(uploadType))
  add(query_589089, "key", newJString(key))
  add(query_589089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589090 = body
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  add(query_589089, "updateMask", newJString(updateMask))
  result = call_589087.call(path_589088, query_589089, nil, nil, body_589090)

var androidmanagementEnterprisesWebAppsPatch* = Call_AndroidmanagementEnterprisesWebAppsPatch_589069(
    name: "androidmanagementEnterprisesWebAppsPatch", meth: HttpMethod.HttpPatch,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsPatch_589070,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsPatch_589071,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_589049 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesEnrollmentTokensDelete_589051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesEnrollmentTokensDelete_589050(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes an enrollment token. This operation invalidates the token, preventing its future use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the enrollment token in the form enterprises/{enterpriseId}/enrollmentTokens/{enrollmentTokenId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589052 = path.getOrDefault("name")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "name", valid_589052
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
  ##   wipeDataFlags: JArray
  ##                : Optional flags that control the device wiping behavior.
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
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("wipeDataFlags")
  valid_589057 = validateParameter(valid_589057, JArray, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "wipeDataFlags", valid_589057
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
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589065: Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_589049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an enrollment token. This operation invalidates the token, preventing its future use.
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_589049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; wipeDataFlags: JsonNode = nil;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesEnrollmentTokensDelete
  ## Deletes an enrollment token. This operation invalidates the token, preventing its future use.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the enrollment token in the form enterprises/{enterpriseId}/enrollmentTokens/{enrollmentTokenId}.
  ##   alt: string
  ##      : Data format for response.
  ##   wipeDataFlags: JArray
  ##                : Optional flags that control the device wiping behavior.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  add(query_589068, "upload_protocol", newJString(uploadProtocol))
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(path_589067, "name", newJString(name))
  add(query_589068, "alt", newJString(alt))
  if wipeDataFlags != nil:
    query_589068.add "wipeDataFlags", wipeDataFlags
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "callback", newJString(callback))
  add(query_589068, "access_token", newJString(accessToken))
  add(query_589068, "uploadType", newJString(uploadType))
  add(query_589068, "key", newJString(key))
  add(query_589068, "$.xgafv", newJString(Xgafv))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  result = call_589066.call(path_589067, query_589068, nil, nil, nil)

var androidmanagementEnterprisesEnrollmentTokensDelete* = Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_589049(
    name: "androidmanagementEnterprisesEnrollmentTokensDelete",
    meth: HttpMethod.HttpDelete, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensDelete_589050,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensDelete_589051,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesOperationsCancel_589091 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesDevicesOperationsCancel_589093(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesDevicesOperationsCancel_589092(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589094 = path.getOrDefault("name")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "name", valid_589094
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
  var valid_589097 = query.getOrDefault("quotaUser")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "quotaUser", valid_589097
  var valid_589098 = query.getOrDefault("alt")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("json"))
  if valid_589098 != nil:
    section.add "alt", valid_589098
  var valid_589099 = query.getOrDefault("oauth_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "oauth_token", valid_589099
  var valid_589100 = query.getOrDefault("callback")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "callback", valid_589100
  var valid_589101 = query.getOrDefault("access_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "access_token", valid_589101
  var valid_589102 = query.getOrDefault("uploadType")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "uploadType", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("$.xgafv")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("1"))
  if valid_589104 != nil:
    section.add "$.xgafv", valid_589104
  var valid_589105 = query.getOrDefault("prettyPrint")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "prettyPrint", valid_589105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589106: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_589091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_589091;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesDevicesOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589108 = newJObject()
  var query_589109 = newJObject()
  add(query_589109, "upload_protocol", newJString(uploadProtocol))
  add(query_589109, "fields", newJString(fields))
  add(query_589109, "quotaUser", newJString(quotaUser))
  add(path_589108, "name", newJString(name))
  add(query_589109, "alt", newJString(alt))
  add(query_589109, "oauth_token", newJString(oauthToken))
  add(query_589109, "callback", newJString(callback))
  add(query_589109, "access_token", newJString(accessToken))
  add(query_589109, "uploadType", newJString(uploadType))
  add(query_589109, "key", newJString(key))
  add(query_589109, "$.xgafv", newJString(Xgafv))
  add(query_589109, "prettyPrint", newJBool(prettyPrint))
  result = call_589107.call(path_589108, query_589109, nil, nil, nil)

var androidmanagementEnterprisesDevicesOperationsCancel* = Call_AndroidmanagementEnterprisesDevicesOperationsCancel_589091(
    name: "androidmanagementEnterprisesDevicesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_AndroidmanagementEnterprisesDevicesOperationsCancel_589092,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesOperationsCancel_589093,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesIssueCommand_589110 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesDevicesIssueCommand_589112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":issueCommand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesDevicesIssueCommand_589111(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the device in the form enterprises/{enterpriseId}/devices/{deviceId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589113 = path.getOrDefault("name")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "name", valid_589113
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
  var valid_589114 = query.getOrDefault("upload_protocol")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "upload_protocol", valid_589114
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("quotaUser")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "quotaUser", valid_589116
  var valid_589117 = query.getOrDefault("alt")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("json"))
  if valid_589117 != nil:
    section.add "alt", valid_589117
  var valid_589118 = query.getOrDefault("oauth_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "oauth_token", valid_589118
  var valid_589119 = query.getOrDefault("callback")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "callback", valid_589119
  var valid_589120 = query.getOrDefault("access_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "access_token", valid_589120
  var valid_589121 = query.getOrDefault("uploadType")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "uploadType", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("$.xgafv")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("1"))
  if valid_589123 != nil:
    section.add "$.xgafv", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
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

proc call*(call_589126: Call_AndroidmanagementEnterprisesDevicesIssueCommand_589110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_AndroidmanagementEnterprisesDevicesIssueCommand_589110;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesDevicesIssueCommand
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the device in the form enterprises/{enterpriseId}/devices/{deviceId}.
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
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  var body_589130 = newJObject()
  add(query_589129, "upload_protocol", newJString(uploadProtocol))
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(path_589128, "name", newJString(name))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "callback", newJString(callback))
  add(query_589129, "access_token", newJString(accessToken))
  add(query_589129, "uploadType", newJString(uploadType))
  add(query_589129, "key", newJString(key))
  add(query_589129, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589130 = body
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, body_589130)

var androidmanagementEnterprisesDevicesIssueCommand* = Call_AndroidmanagementEnterprisesDevicesIssueCommand_589110(
    name: "androidmanagementEnterprisesDevicesIssueCommand",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:issueCommand",
    validator: validate_AndroidmanagementEnterprisesDevicesIssueCommand_589111,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesIssueCommand_589112,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesList_589131 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesDevicesList_589133(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesDevicesList_589132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists devices for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589134 = path.getOrDefault("parent")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "parent", valid_589134
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589135 = query.getOrDefault("upload_protocol")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "upload_protocol", valid_589135
  var valid_589136 = query.getOrDefault("fields")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "fields", valid_589136
  var valid_589137 = query.getOrDefault("pageToken")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "pageToken", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("callback")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "callback", valid_589141
  var valid_589142 = query.getOrDefault("access_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "access_token", valid_589142
  var valid_589143 = query.getOrDefault("uploadType")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "uploadType", valid_589143
  var valid_589144 = query.getOrDefault("key")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "key", valid_589144
  var valid_589145 = query.getOrDefault("$.xgafv")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("1"))
  if valid_589145 != nil:
    section.add "$.xgafv", valid_589145
  var valid_589146 = query.getOrDefault("pageSize")
  valid_589146 = validateParameter(valid_589146, JInt, required = false, default = nil)
  if valid_589146 != nil:
    section.add "pageSize", valid_589146
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

proc call*(call_589148: Call_AndroidmanagementEnterprisesDevicesList_589131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists devices for a given enterprise.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_AndroidmanagementEnterprisesDevicesList_589131;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesDevicesList
  ## Lists devices for a given enterprise.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  add(query_589151, "upload_protocol", newJString(uploadProtocol))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "pageToken", newJString(pageToken))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "callback", newJString(callback))
  add(query_589151, "access_token", newJString(accessToken))
  add(query_589151, "uploadType", newJString(uploadType))
  add(path_589150, "parent", newJString(parent))
  add(query_589151, "key", newJString(key))
  add(query_589151, "$.xgafv", newJString(Xgafv))
  add(query_589151, "pageSize", newJInt(pageSize))
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, nil)

var androidmanagementEnterprisesDevicesList* = Call_AndroidmanagementEnterprisesDevicesList_589131(
    name: "androidmanagementEnterprisesDevicesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/devices",
    validator: validate_AndroidmanagementEnterprisesDevicesList_589132, base: "/",
    url: url_AndroidmanagementEnterprisesDevicesList_589133,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_589152 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesEnrollmentTokensCreate_589154(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/enrollmentTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_589153(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an enrollment token for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589155 = path.getOrDefault("parent")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "parent", valid_589155
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
  var valid_589156 = query.getOrDefault("upload_protocol")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "upload_protocol", valid_589156
  var valid_589157 = query.getOrDefault("fields")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "fields", valid_589157
  var valid_589158 = query.getOrDefault("quotaUser")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "quotaUser", valid_589158
  var valid_589159 = query.getOrDefault("alt")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("json"))
  if valid_589159 != nil:
    section.add "alt", valid_589159
  var valid_589160 = query.getOrDefault("oauth_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "oauth_token", valid_589160
  var valid_589161 = query.getOrDefault("callback")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "callback", valid_589161
  var valid_589162 = query.getOrDefault("access_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "access_token", valid_589162
  var valid_589163 = query.getOrDefault("uploadType")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "uploadType", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
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

proc call*(call_589168: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_589152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enrollment token for a given enterprise.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_589152;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesEnrollmentTokensCreate
  ## Creates an enrollment token for a given enterprise.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589170 = newJObject()
  var query_589171 = newJObject()
  var body_589172 = newJObject()
  add(query_589171, "upload_protocol", newJString(uploadProtocol))
  add(query_589171, "fields", newJString(fields))
  add(query_589171, "quotaUser", newJString(quotaUser))
  add(query_589171, "alt", newJString(alt))
  add(query_589171, "oauth_token", newJString(oauthToken))
  add(query_589171, "callback", newJString(callback))
  add(query_589171, "access_token", newJString(accessToken))
  add(query_589171, "uploadType", newJString(uploadType))
  add(path_589170, "parent", newJString(parent))
  add(query_589171, "key", newJString(key))
  add(query_589171, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589172 = body
  add(query_589171, "prettyPrint", newJBool(prettyPrint))
  result = call_589169.call(path_589170, query_589171, nil, nil, body_589172)

var androidmanagementEnterprisesEnrollmentTokensCreate* = Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_589152(
    name: "androidmanagementEnterprisesEnrollmentTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/enrollmentTokens",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_589153,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensCreate_589154,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesPoliciesList_589173 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesPoliciesList_589175(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesPoliciesList_589174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists policies for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589176 = path.getOrDefault("parent")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "parent", valid_589176
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589177 = query.getOrDefault("upload_protocol")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "upload_protocol", valid_589177
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("pageToken")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "pageToken", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("callback")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "callback", valid_589183
  var valid_589184 = query.getOrDefault("access_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "access_token", valid_589184
  var valid_589185 = query.getOrDefault("uploadType")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "uploadType", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("$.xgafv")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("1"))
  if valid_589187 != nil:
    section.add "$.xgafv", valid_589187
  var valid_589188 = query.getOrDefault("pageSize")
  valid_589188 = validateParameter(valid_589188, JInt, required = false, default = nil)
  if valid_589188 != nil:
    section.add "pageSize", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589190: Call_AndroidmanagementEnterprisesPoliciesList_589173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists policies for a given enterprise.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_AndroidmanagementEnterprisesPoliciesList_589173;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesPoliciesList
  ## Lists policies for a given enterprise.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "pageToken", newJString(pageToken))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(path_589192, "parent", newJString(parent))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  add(query_589193, "pageSize", newJInt(pageSize))
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, nil)

var androidmanagementEnterprisesPoliciesList* = Call_AndroidmanagementEnterprisesPoliciesList_589173(
    name: "androidmanagementEnterprisesPoliciesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/policies",
    validator: validate_AndroidmanagementEnterprisesPoliciesList_589174,
    base: "/", url: url_AndroidmanagementEnterprisesPoliciesList_589175,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsCreate_589215 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesWebAppsCreate_589217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsCreate_589216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589218 = path.getOrDefault("parent")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "parent", valid_589218
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
  var valid_589219 = query.getOrDefault("upload_protocol")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "upload_protocol", valid_589219
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("callback")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "callback", valid_589224
  var valid_589225 = query.getOrDefault("access_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "access_token", valid_589225
  var valid_589226 = query.getOrDefault("uploadType")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "uploadType", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
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

proc call*(call_589231: Call_AndroidmanagementEnterprisesWebAppsCreate_589215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web app.
  ## 
  let valid = call_589231.validator(path, query, header, formData, body)
  let scheme = call_589231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589231.url(scheme.get, call_589231.host, call_589231.base,
                         call_589231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589231, url, valid)

proc call*(call_589232: Call_AndroidmanagementEnterprisesWebAppsCreate_589215;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesWebAppsCreate
  ## Creates a web app.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589233 = newJObject()
  var query_589234 = newJObject()
  var body_589235 = newJObject()
  add(query_589234, "upload_protocol", newJString(uploadProtocol))
  add(query_589234, "fields", newJString(fields))
  add(query_589234, "quotaUser", newJString(quotaUser))
  add(query_589234, "alt", newJString(alt))
  add(query_589234, "oauth_token", newJString(oauthToken))
  add(query_589234, "callback", newJString(callback))
  add(query_589234, "access_token", newJString(accessToken))
  add(query_589234, "uploadType", newJString(uploadType))
  add(path_589233, "parent", newJString(parent))
  add(query_589234, "key", newJString(key))
  add(query_589234, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589235 = body
  add(query_589234, "prettyPrint", newJBool(prettyPrint))
  result = call_589232.call(path_589233, query_589234, nil, nil, body_589235)

var androidmanagementEnterprisesWebAppsCreate* = Call_AndroidmanagementEnterprisesWebAppsCreate_589215(
    name: "androidmanagementEnterprisesWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsCreate_589216,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsCreate_589217,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsList_589194 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesWebAppsList_589196(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsList_589195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists web apps for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589197 = path.getOrDefault("parent")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "parent", valid_589197
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589198 = query.getOrDefault("upload_protocol")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "upload_protocol", valid_589198
  var valid_589199 = query.getOrDefault("fields")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "fields", valid_589199
  var valid_589200 = query.getOrDefault("pageToken")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "pageToken", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("pageSize")
  valid_589209 = validateParameter(valid_589209, JInt, required = false, default = nil)
  if valid_589209 != nil:
    section.add "pageSize", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_AndroidmanagementEnterprisesWebAppsList_589194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web apps for a given enterprise.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_AndroidmanagementEnterprisesWebAppsList_589194;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesWebAppsList
  ## Lists web apps for a given enterprise.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "pageToken", newJString(pageToken))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(path_589213, "parent", newJString(parent))
  add(query_589214, "key", newJString(key))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  add(query_589214, "pageSize", newJInt(pageSize))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var androidmanagementEnterprisesWebAppsList* = Call_AndroidmanagementEnterprisesWebAppsList_589194(
    name: "androidmanagementEnterprisesWebAppsList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsList_589195, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsList_589196,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebTokensCreate_589236 = ref object of OpenApiRestCall_588450
proc url_AndroidmanagementEnterprisesWebTokensCreate_589238(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webTokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebTokensCreate_589237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589239 = path.getOrDefault("parent")
  valid_589239 = validateParameter(valid_589239, JString, required = true,
                                 default = nil)
  if valid_589239 != nil:
    section.add "parent", valid_589239
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
  var valid_589240 = query.getOrDefault("upload_protocol")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "upload_protocol", valid_589240
  var valid_589241 = query.getOrDefault("fields")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "fields", valid_589241
  var valid_589242 = query.getOrDefault("quotaUser")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "quotaUser", valid_589242
  var valid_589243 = query.getOrDefault("alt")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = newJString("json"))
  if valid_589243 != nil:
    section.add "alt", valid_589243
  var valid_589244 = query.getOrDefault("oauth_token")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "oauth_token", valid_589244
  var valid_589245 = query.getOrDefault("callback")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "callback", valid_589245
  var valid_589246 = query.getOrDefault("access_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "access_token", valid_589246
  var valid_589247 = query.getOrDefault("uploadType")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "uploadType", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
  var valid_589249 = query.getOrDefault("$.xgafv")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("1"))
  if valid_589249 != nil:
    section.add "$.xgafv", valid_589249
  var valid_589250 = query.getOrDefault("prettyPrint")
  valid_589250 = validateParameter(valid_589250, JBool, required = false,
                                 default = newJBool(true))
  if valid_589250 != nil:
    section.add "prettyPrint", valid_589250
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

proc call*(call_589252: Call_AndroidmanagementEnterprisesWebTokensCreate_589236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
  ## 
  let valid = call_589252.validator(path, query, header, formData, body)
  let scheme = call_589252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589252.url(scheme.get, call_589252.host, call_589252.base,
                         call_589252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589252, url, valid)

proc call*(call_589253: Call_AndroidmanagementEnterprisesWebTokensCreate_589236;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesWebTokensCreate
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589254 = newJObject()
  var query_589255 = newJObject()
  var body_589256 = newJObject()
  add(query_589255, "upload_protocol", newJString(uploadProtocol))
  add(query_589255, "fields", newJString(fields))
  add(query_589255, "quotaUser", newJString(quotaUser))
  add(query_589255, "alt", newJString(alt))
  add(query_589255, "oauth_token", newJString(oauthToken))
  add(query_589255, "callback", newJString(callback))
  add(query_589255, "access_token", newJString(accessToken))
  add(query_589255, "uploadType", newJString(uploadType))
  add(path_589254, "parent", newJString(parent))
  add(query_589255, "key", newJString(key))
  add(query_589255, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589256 = body
  add(query_589255, "prettyPrint", newJBool(prettyPrint))
  result = call_589253.call(path_589254, query_589255, nil, nil, body_589256)

var androidmanagementEnterprisesWebTokensCreate* = Call_AndroidmanagementEnterprisesWebTokensCreate_589236(
    name: "androidmanagementEnterprisesWebTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/webTokens",
    validator: validate_AndroidmanagementEnterprisesWebTokensCreate_589237,
    base: "/", url: url_AndroidmanagementEnterprisesWebTokensCreate_589238,
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
