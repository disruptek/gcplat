
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
  gcpServiceName = "androidmanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidmanagementEnterprisesCreate_579690 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesCreate_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementEnterprisesCreate_579691(path: JsonNode;
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
  var valid_579825 = query.getOrDefault("enterpriseToken")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "enterpriseToken", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("$.xgafv")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("1"))
  if valid_579827 != nil:
    section.add "$.xgafv", valid_579827
  var valid_579828 = query.getOrDefault("projectId")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "projectId", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  var valid_579830 = query.getOrDefault("signupUrlName")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "signupUrlName", valid_579830
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

proc call*(call_579854: Call_AndroidmanagementEnterprisesCreate_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_AndroidmanagementEnterprisesCreate_579690;
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
  var query_579926 = newJObject()
  var body_579928 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "enterpriseToken", newJString(enterpriseToken))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "projectId", newJString(projectId))
  if body != nil:
    body_579928 = body
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  add(query_579926, "signupUrlName", newJString(signupUrlName))
  result = call_579925.call(nil, query_579926, nil, nil, body_579928)

var androidmanagementEnterprisesCreate* = Call_AndroidmanagementEnterprisesCreate_579690(
    name: "androidmanagementEnterprisesCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/enterprises",
    validator: validate_AndroidmanagementEnterprisesCreate_579691, base: "/",
    url: url_AndroidmanagementEnterprisesCreate_579692, schemes: {Scheme.Https})
type
  Call_AndroidmanagementSignupUrlsCreate_579967 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementSignupUrlsCreate_579969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementSignupUrlsCreate_579968(path: JsonNode;
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
  var valid_579970 = query.getOrDefault("upload_protocol")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "upload_protocol", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("callbackUrl")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "callbackUrl", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("oauth_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "oauth_token", valid_579975
  var valid_579976 = query.getOrDefault("callback")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "callback", valid_579976
  var valid_579977 = query.getOrDefault("access_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "access_token", valid_579977
  var valid_579978 = query.getOrDefault("uploadType")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "uploadType", valid_579978
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("projectId")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "projectId", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_AndroidmanagementSignupUrlsCreate_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise signup URL.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_AndroidmanagementSignupUrlsCreate_579967;
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
  var query_579985 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "callbackUrl", newJString(callbackUrl))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "projectId", newJString(projectId))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var androidmanagementSignupUrlsCreate* = Call_AndroidmanagementSignupUrlsCreate_579967(
    name: "androidmanagementSignupUrlsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/signupUrls",
    validator: validate_AndroidmanagementSignupUrlsCreate_579968, base: "/",
    url: url_AndroidmanagementSignupUrlsCreate_579969, schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsGet_579986 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebAppsGet_579988(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsGet_579987(path: JsonNode;
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
  var valid_580003 = path.getOrDefault("name")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "name", valid_580003
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
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("callback")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "callback", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("languageCode")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "languageCode", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580016: Call_AndroidmanagementEnterprisesWebAppsGet_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web app.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_AndroidmanagementEnterprisesWebAppsGet_579986;
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
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  add(query_580019, "upload_protocol", newJString(uploadProtocol))
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(path_580018, "name", newJString(name))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "callback", newJString(callback))
  add(query_580019, "access_token", newJString(accessToken))
  add(query_580019, "uploadType", newJString(uploadType))
  add(query_580019, "key", newJString(key))
  add(query_580019, "$.xgafv", newJString(Xgafv))
  add(query_580019, "languageCode", newJString(languageCode))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, nil)

var androidmanagementEnterprisesWebAppsGet* = Call_AndroidmanagementEnterprisesWebAppsGet_579986(
    name: "androidmanagementEnterprisesWebAppsGet", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsGet_579987, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsGet_579988,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsPatch_580040 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebAppsPatch_580042(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsPatch_580041(path: JsonNode;
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
  var valid_580043 = path.getOrDefault("name")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "name", valid_580043
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
  var valid_580044 = query.getOrDefault("upload_protocol")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "upload_protocol", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("updateMask")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "updateMask", valid_580055
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

proc call*(call_580057: Call_AndroidmanagementEnterprisesWebAppsPatch_580040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a web app.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_AndroidmanagementEnterprisesWebAppsPatch_580040;
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
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(path_580059, "name", newJString(name))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  add(query_580060, "updateMask", newJString(updateMask))
  result = call_580058.call(path_580059, query_580060, nil, nil, body_580061)

var androidmanagementEnterprisesWebAppsPatch* = Call_AndroidmanagementEnterprisesWebAppsPatch_580040(
    name: "androidmanagementEnterprisesWebAppsPatch", meth: HttpMethod.HttpPatch,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsPatch_580041,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsPatch_580042,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsDelete_580020 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebAppsDelete_580022(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsDelete_580021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApps/{packageName}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580023 = path.getOrDefault("name")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "name", valid_580023
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
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("wipeDataFlags")
  valid_580028 = validateParameter(valid_580028, JArray, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "wipeDataFlags", valid_580028
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
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_AndroidmanagementEnterprisesWebAppsDelete_580020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web app.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_AndroidmanagementEnterprisesWebAppsDelete_580020;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; wipeDataFlags: JsonNode = nil;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## androidmanagementEnterprisesWebAppsDelete
  ## Deletes a web app.
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(path_580038, "name", newJString(name))
  add(query_580039, "alt", newJString(alt))
  if wipeDataFlags != nil:
    query_580039.add "wipeDataFlags", wipeDataFlags
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "key", newJString(key))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  result = call_580037.call(path_580038, query_580039, nil, nil, nil)

var androidmanagementEnterprisesWebAppsDelete* = Call_AndroidmanagementEnterprisesWebAppsDelete_580020(
    name: "androidmanagementEnterprisesWebAppsDelete",
    meth: HttpMethod.HttpDelete, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsDelete_580021,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsDelete_580022,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesOperationsCancel_580062 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesDevicesOperationsCancel_580064(
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

proc validate_AndroidmanagementEnterprisesDevicesOperationsCancel_580063(
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
  var valid_580065 = path.getOrDefault("name")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "name", valid_580065
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
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("callback")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "callback", valid_580071
  var valid_580072 = query.getOrDefault("access_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "access_token", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("$.xgafv")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("1"))
  if valid_580075 != nil:
    section.add "$.xgafv", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_580062;
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
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  add(query_580080, "upload_protocol", newJString(uploadProtocol))
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(path_580079, "name", newJString(name))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "callback", newJString(callback))
  add(query_580080, "access_token", newJString(accessToken))
  add(query_580080, "uploadType", newJString(uploadType))
  add(query_580080, "key", newJString(key))
  add(query_580080, "$.xgafv", newJString(Xgafv))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(path_580079, query_580080, nil, nil, nil)

var androidmanagementEnterprisesDevicesOperationsCancel* = Call_AndroidmanagementEnterprisesDevicesOperationsCancel_580062(
    name: "androidmanagementEnterprisesDevicesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_AndroidmanagementEnterprisesDevicesOperationsCancel_580063,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesOperationsCancel_580064,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesIssueCommand_580081 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesDevicesIssueCommand_580083(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesDevicesIssueCommand_580082(
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
  var valid_580084 = path.getOrDefault("name")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "name", valid_580084
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
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
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

proc call*(call_580097: Call_AndroidmanagementEnterprisesDevicesIssueCommand_580081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_AndroidmanagementEnterprisesDevicesIssueCommand_580081;
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
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  var body_580101 = newJObject()
  add(query_580100, "upload_protocol", newJString(uploadProtocol))
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(path_580099, "name", newJString(name))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "callback", newJString(callback))
  add(query_580100, "access_token", newJString(accessToken))
  add(query_580100, "uploadType", newJString(uploadType))
  add(query_580100, "key", newJString(key))
  add(query_580100, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580101 = body
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, body_580101)

var androidmanagementEnterprisesDevicesIssueCommand* = Call_AndroidmanagementEnterprisesDevicesIssueCommand_580081(
    name: "androidmanagementEnterprisesDevicesIssueCommand",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:issueCommand",
    validator: validate_AndroidmanagementEnterprisesDevicesIssueCommand_580082,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesIssueCommand_580083,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesList_580102 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesDevicesList_580104(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesDevicesList_580103(path: JsonNode;
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
  var valid_580105 = path.getOrDefault("parent")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "parent", valid_580105
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
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("pageToken")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "pageToken", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("callback")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "callback", valid_580112
  var valid_580113 = query.getOrDefault("access_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "access_token", valid_580113
  var valid_580114 = query.getOrDefault("uploadType")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "uploadType", valid_580114
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("$.xgafv")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("1"))
  if valid_580116 != nil:
    section.add "$.xgafv", valid_580116
  var valid_580117 = query.getOrDefault("pageSize")
  valid_580117 = validateParameter(valid_580117, JInt, required = false, default = nil)
  if valid_580117 != nil:
    section.add "pageSize", valid_580117
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

proc call*(call_580119: Call_AndroidmanagementEnterprisesDevicesList_580102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists devices for a given enterprise.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_AndroidmanagementEnterprisesDevicesList_580102;
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
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "upload_protocol", newJString(uploadProtocol))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "pageToken", newJString(pageToken))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "callback", newJString(callback))
  add(query_580122, "access_token", newJString(accessToken))
  add(query_580122, "uploadType", newJString(uploadType))
  add(path_580121, "parent", newJString(parent))
  add(query_580122, "key", newJString(key))
  add(query_580122, "$.xgafv", newJString(Xgafv))
  add(query_580122, "pageSize", newJInt(pageSize))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var androidmanagementEnterprisesDevicesList* = Call_AndroidmanagementEnterprisesDevicesList_580102(
    name: "androidmanagementEnterprisesDevicesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/devices",
    validator: validate_AndroidmanagementEnterprisesDevicesList_580103, base: "/",
    url: url_AndroidmanagementEnterprisesDevicesList_580104,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_580123 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesEnrollmentTokensCreate_580125(
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

proc validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_580124(
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
  var valid_580126 = path.getOrDefault("parent")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "parent", valid_580126
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
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("oauth_token")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "oauth_token", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("uploadType")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "uploadType", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
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

proc call*(call_580139: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_580123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enrollment token for a given enterprise.
  ## 
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_580123;
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
  var path_580141 = newJObject()
  var query_580142 = newJObject()
  var body_580143 = newJObject()
  add(query_580142, "upload_protocol", newJString(uploadProtocol))
  add(query_580142, "fields", newJString(fields))
  add(query_580142, "quotaUser", newJString(quotaUser))
  add(query_580142, "alt", newJString(alt))
  add(query_580142, "oauth_token", newJString(oauthToken))
  add(query_580142, "callback", newJString(callback))
  add(query_580142, "access_token", newJString(accessToken))
  add(query_580142, "uploadType", newJString(uploadType))
  add(path_580141, "parent", newJString(parent))
  add(query_580142, "key", newJString(key))
  add(query_580142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580143 = body
  add(query_580142, "prettyPrint", newJBool(prettyPrint))
  result = call_580140.call(path_580141, query_580142, nil, nil, body_580143)

var androidmanagementEnterprisesEnrollmentTokensCreate* = Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_580123(
    name: "androidmanagementEnterprisesEnrollmentTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/enrollmentTokens",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_580124,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensCreate_580125,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesPoliciesList_580144 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesPoliciesList_580146(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesPoliciesList_580145(path: JsonNode;
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
  var valid_580147 = path.getOrDefault("parent")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "parent", valid_580147
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
  var valid_580148 = query.getOrDefault("upload_protocol")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "upload_protocol", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("pageToken")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "pageToken", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("callback")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "callback", valid_580154
  var valid_580155 = query.getOrDefault("access_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "access_token", valid_580155
  var valid_580156 = query.getOrDefault("uploadType")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "uploadType", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("$.xgafv")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("1"))
  if valid_580158 != nil:
    section.add "$.xgafv", valid_580158
  var valid_580159 = query.getOrDefault("pageSize")
  valid_580159 = validateParameter(valid_580159, JInt, required = false, default = nil)
  if valid_580159 != nil:
    section.add "pageSize", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580161: Call_AndroidmanagementEnterprisesPoliciesList_580144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists policies for a given enterprise.
  ## 
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_AndroidmanagementEnterprisesPoliciesList_580144;
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
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "pageToken", newJString(pageToken))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(path_580163, "parent", newJString(parent))
  add(query_580164, "key", newJString(key))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  add(query_580164, "pageSize", newJInt(pageSize))
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580162.call(path_580163, query_580164, nil, nil, nil)

var androidmanagementEnterprisesPoliciesList* = Call_AndroidmanagementEnterprisesPoliciesList_580144(
    name: "androidmanagementEnterprisesPoliciesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/policies",
    validator: validate_AndroidmanagementEnterprisesPoliciesList_580145,
    base: "/", url: url_AndroidmanagementEnterprisesPoliciesList_580146,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsCreate_580186 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebAppsCreate_580188(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsCreate_580187(path: JsonNode;
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
  var valid_580189 = path.getOrDefault("parent")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "parent", valid_580189
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
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
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

proc call*(call_580202: Call_AndroidmanagementEnterprisesWebAppsCreate_580186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web app.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_AndroidmanagementEnterprisesWebAppsCreate_580186;
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
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  var body_580206 = newJObject()
  add(query_580205, "upload_protocol", newJString(uploadProtocol))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "callback", newJString(callback))
  add(query_580205, "access_token", newJString(accessToken))
  add(query_580205, "uploadType", newJString(uploadType))
  add(path_580204, "parent", newJString(parent))
  add(query_580205, "key", newJString(key))
  add(query_580205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580206 = body
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  result = call_580203.call(path_580204, query_580205, nil, nil, body_580206)

var androidmanagementEnterprisesWebAppsCreate* = Call_AndroidmanagementEnterprisesWebAppsCreate_580186(
    name: "androidmanagementEnterprisesWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsCreate_580187,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsCreate_580188,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsList_580165 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebAppsList_580167(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsList_580166(path: JsonNode;
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
  var valid_580168 = path.getOrDefault("parent")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "parent", valid_580168
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
  var valid_580169 = query.getOrDefault("upload_protocol")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "upload_protocol", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("pageToken")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "pageToken", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("uploadType")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "uploadType", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("pageSize")
  valid_580180 = validateParameter(valid_580180, JInt, required = false, default = nil)
  if valid_580180 != nil:
    section.add "pageSize", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580182: Call_AndroidmanagementEnterprisesWebAppsList_580165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web apps for a given enterprise.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_AndroidmanagementEnterprisesWebAppsList_580165;
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
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  add(query_580185, "upload_protocol", newJString(uploadProtocol))
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "pageToken", newJString(pageToken))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "alt", newJString(alt))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(query_580185, "callback", newJString(callback))
  add(query_580185, "access_token", newJString(accessToken))
  add(query_580185, "uploadType", newJString(uploadType))
  add(path_580184, "parent", newJString(parent))
  add(query_580185, "key", newJString(key))
  add(query_580185, "$.xgafv", newJString(Xgafv))
  add(query_580185, "pageSize", newJInt(pageSize))
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  result = call_580183.call(path_580184, query_580185, nil, nil, nil)

var androidmanagementEnterprisesWebAppsList* = Call_AndroidmanagementEnterprisesWebAppsList_580165(
    name: "androidmanagementEnterprisesWebAppsList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsList_580166, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsList_580167,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebTokensCreate_580207 = ref object of OpenApiRestCall_579421
proc url_AndroidmanagementEnterprisesWebTokensCreate_580209(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebTokensCreate_580208(path: JsonNode;
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
  var valid_580210 = path.getOrDefault("parent")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "parent", valid_580210
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
  var valid_580211 = query.getOrDefault("upload_protocol")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "upload_protocol", valid_580211
  var valid_580212 = query.getOrDefault("fields")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "fields", valid_580212
  var valid_580213 = query.getOrDefault("quotaUser")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "quotaUser", valid_580213
  var valid_580214 = query.getOrDefault("alt")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = newJString("json"))
  if valid_580214 != nil:
    section.add "alt", valid_580214
  var valid_580215 = query.getOrDefault("oauth_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "oauth_token", valid_580215
  var valid_580216 = query.getOrDefault("callback")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "callback", valid_580216
  var valid_580217 = query.getOrDefault("access_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "access_token", valid_580217
  var valid_580218 = query.getOrDefault("uploadType")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "uploadType", valid_580218
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("$.xgafv")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("1"))
  if valid_580220 != nil:
    section.add "$.xgafv", valid_580220
  var valid_580221 = query.getOrDefault("prettyPrint")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "prettyPrint", valid_580221
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

proc call*(call_580223: Call_AndroidmanagementEnterprisesWebTokensCreate_580207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
  ## 
  let valid = call_580223.validator(path, query, header, formData, body)
  let scheme = call_580223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580223.url(scheme.get, call_580223.host, call_580223.base,
                         call_580223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580223, url, valid)

proc call*(call_580224: Call_AndroidmanagementEnterprisesWebTokensCreate_580207;
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
  var path_580225 = newJObject()
  var query_580226 = newJObject()
  var body_580227 = newJObject()
  add(query_580226, "upload_protocol", newJString(uploadProtocol))
  add(query_580226, "fields", newJString(fields))
  add(query_580226, "quotaUser", newJString(quotaUser))
  add(query_580226, "alt", newJString(alt))
  add(query_580226, "oauth_token", newJString(oauthToken))
  add(query_580226, "callback", newJString(callback))
  add(query_580226, "access_token", newJString(accessToken))
  add(query_580226, "uploadType", newJString(uploadType))
  add(path_580225, "parent", newJString(parent))
  add(query_580226, "key", newJString(key))
  add(query_580226, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580227 = body
  add(query_580226, "prettyPrint", newJBool(prettyPrint))
  result = call_580224.call(path_580225, query_580226, nil, nil, body_580227)

var androidmanagementEnterprisesWebTokensCreate* = Call_AndroidmanagementEnterprisesWebTokensCreate_580207(
    name: "androidmanagementEnterprisesWebTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/webTokens",
    validator: validate_AndroidmanagementEnterprisesWebTokensCreate_580208,
    base: "/", url: url_AndroidmanagementEnterprisesWebTokensCreate_580209,
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
