
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "androidmanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidmanagementEnterprisesCreate_597690 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesCreate_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidmanagementEnterprisesCreate_597691(path: JsonNode;
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
  var valid_597825 = query.getOrDefault("enterpriseToken")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "enterpriseToken", valid_597825
  var valid_597826 = query.getOrDefault("key")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "key", valid_597826
  var valid_597827 = query.getOrDefault("$.xgafv")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = newJString("1"))
  if valid_597827 != nil:
    section.add "$.xgafv", valid_597827
  var valid_597828 = query.getOrDefault("projectId")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "projectId", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  var valid_597830 = query.getOrDefault("signupUrlName")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = nil)
  if valid_597830 != nil:
    section.add "signupUrlName", valid_597830
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

proc call*(call_597854: Call_AndroidmanagementEnterprisesCreate_597690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ## 
  let valid = call_597854.validator(path, query, header, formData, body)
  let scheme = call_597854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597854.url(scheme.get, call_597854.host, call_597854.base,
                         call_597854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597854, url, valid)

proc call*(call_597925: Call_AndroidmanagementEnterprisesCreate_597690;
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
  var query_597926 = newJObject()
  var body_597928 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "enterpriseToken", newJString(enterpriseToken))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "projectId", newJString(projectId))
  if body != nil:
    body_597928 = body
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  add(query_597926, "signupUrlName", newJString(signupUrlName))
  result = call_597925.call(nil, query_597926, nil, nil, body_597928)

var androidmanagementEnterprisesCreate* = Call_AndroidmanagementEnterprisesCreate_597690(
    name: "androidmanagementEnterprisesCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/enterprises",
    validator: validate_AndroidmanagementEnterprisesCreate_597691, base: "/",
    url: url_AndroidmanagementEnterprisesCreate_597692, schemes: {Scheme.Https})
type
  Call_AndroidmanagementSignupUrlsCreate_597967 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementSignupUrlsCreate_597969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidmanagementSignupUrlsCreate_597968(path: JsonNode;
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
  var valid_597970 = query.getOrDefault("upload_protocol")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "upload_protocol", valid_597970
  var valid_597971 = query.getOrDefault("fields")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "fields", valid_597971
  var valid_597972 = query.getOrDefault("quotaUser")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "quotaUser", valid_597972
  var valid_597973 = query.getOrDefault("callbackUrl")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "callbackUrl", valid_597973
  var valid_597974 = query.getOrDefault("alt")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = newJString("json"))
  if valid_597974 != nil:
    section.add "alt", valid_597974
  var valid_597975 = query.getOrDefault("oauth_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "oauth_token", valid_597975
  var valid_597976 = query.getOrDefault("callback")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "callback", valid_597976
  var valid_597977 = query.getOrDefault("access_token")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "access_token", valid_597977
  var valid_597978 = query.getOrDefault("uploadType")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "uploadType", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("$.xgafv")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = newJString("1"))
  if valid_597980 != nil:
    section.add "$.xgafv", valid_597980
  var valid_597981 = query.getOrDefault("projectId")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "projectId", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(true))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597983: Call_AndroidmanagementSignupUrlsCreate_597967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise signup URL.
  ## 
  let valid = call_597983.validator(path, query, header, formData, body)
  let scheme = call_597983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597983.url(scheme.get, call_597983.host, call_597983.base,
                         call_597983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597983, url, valid)

proc call*(call_597984: Call_AndroidmanagementSignupUrlsCreate_597967;
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
  var query_597985 = newJObject()
  add(query_597985, "upload_protocol", newJString(uploadProtocol))
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(query_597985, "callbackUrl", newJString(callbackUrl))
  add(query_597985, "alt", newJString(alt))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "callback", newJString(callback))
  add(query_597985, "access_token", newJString(accessToken))
  add(query_597985, "uploadType", newJString(uploadType))
  add(query_597985, "key", newJString(key))
  add(query_597985, "$.xgafv", newJString(Xgafv))
  add(query_597985, "projectId", newJString(projectId))
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  result = call_597984.call(nil, query_597985, nil, nil, nil)

var androidmanagementSignupUrlsCreate* = Call_AndroidmanagementSignupUrlsCreate_597967(
    name: "androidmanagementSignupUrlsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/signupUrls",
    validator: validate_AndroidmanagementSignupUrlsCreate_597968, base: "/",
    url: url_AndroidmanagementSignupUrlsCreate_597969, schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsGet_597986 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebAppsGet_597988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsGet_597987(path: JsonNode;
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
  var valid_598003 = path.getOrDefault("name")
  valid_598003 = validateParameter(valid_598003, JString, required = true,
                                 default = nil)
  if valid_598003 != nil:
    section.add "name", valid_598003
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
  var valid_598004 = query.getOrDefault("upload_protocol")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "upload_protocol", valid_598004
  var valid_598005 = query.getOrDefault("fields")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "fields", valid_598005
  var valid_598006 = query.getOrDefault("quotaUser")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "quotaUser", valid_598006
  var valid_598007 = query.getOrDefault("alt")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = newJString("json"))
  if valid_598007 != nil:
    section.add "alt", valid_598007
  var valid_598008 = query.getOrDefault("oauth_token")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "oauth_token", valid_598008
  var valid_598009 = query.getOrDefault("callback")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "callback", valid_598009
  var valid_598010 = query.getOrDefault("access_token")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "access_token", valid_598010
  var valid_598011 = query.getOrDefault("uploadType")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "uploadType", valid_598011
  var valid_598012 = query.getOrDefault("key")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "key", valid_598012
  var valid_598013 = query.getOrDefault("$.xgafv")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("1"))
  if valid_598013 != nil:
    section.add "$.xgafv", valid_598013
  var valid_598014 = query.getOrDefault("languageCode")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "languageCode", valid_598014
  var valid_598015 = query.getOrDefault("prettyPrint")
  valid_598015 = validateParameter(valid_598015, JBool, required = false,
                                 default = newJBool(true))
  if valid_598015 != nil:
    section.add "prettyPrint", valid_598015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598016: Call_AndroidmanagementEnterprisesWebAppsGet_597986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web app.
  ## 
  let valid = call_598016.validator(path, query, header, formData, body)
  let scheme = call_598016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598016.url(scheme.get, call_598016.host, call_598016.base,
                         call_598016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598016, url, valid)

proc call*(call_598017: Call_AndroidmanagementEnterprisesWebAppsGet_597986;
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
  var path_598018 = newJObject()
  var query_598019 = newJObject()
  add(query_598019, "upload_protocol", newJString(uploadProtocol))
  add(query_598019, "fields", newJString(fields))
  add(query_598019, "quotaUser", newJString(quotaUser))
  add(path_598018, "name", newJString(name))
  add(query_598019, "alt", newJString(alt))
  add(query_598019, "oauth_token", newJString(oauthToken))
  add(query_598019, "callback", newJString(callback))
  add(query_598019, "access_token", newJString(accessToken))
  add(query_598019, "uploadType", newJString(uploadType))
  add(query_598019, "key", newJString(key))
  add(query_598019, "$.xgafv", newJString(Xgafv))
  add(query_598019, "languageCode", newJString(languageCode))
  add(query_598019, "prettyPrint", newJBool(prettyPrint))
  result = call_598017.call(path_598018, query_598019, nil, nil, nil)

var androidmanagementEnterprisesWebAppsGet* = Call_AndroidmanagementEnterprisesWebAppsGet_597986(
    name: "androidmanagementEnterprisesWebAppsGet", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsGet_597987, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsGet_597988,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsPatch_598040 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebAppsPatch_598042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsPatch_598041(path: JsonNode;
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
  var valid_598043 = path.getOrDefault("name")
  valid_598043 = validateParameter(valid_598043, JString, required = true,
                                 default = nil)
  if valid_598043 != nil:
    section.add "name", valid_598043
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
  var valid_598044 = query.getOrDefault("upload_protocol")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "upload_protocol", valid_598044
  var valid_598045 = query.getOrDefault("fields")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "fields", valid_598045
  var valid_598046 = query.getOrDefault("quotaUser")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "quotaUser", valid_598046
  var valid_598047 = query.getOrDefault("alt")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = newJString("json"))
  if valid_598047 != nil:
    section.add "alt", valid_598047
  var valid_598048 = query.getOrDefault("oauth_token")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "oauth_token", valid_598048
  var valid_598049 = query.getOrDefault("callback")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "callback", valid_598049
  var valid_598050 = query.getOrDefault("access_token")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "access_token", valid_598050
  var valid_598051 = query.getOrDefault("uploadType")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "uploadType", valid_598051
  var valid_598052 = query.getOrDefault("key")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "key", valid_598052
  var valid_598053 = query.getOrDefault("$.xgafv")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("1"))
  if valid_598053 != nil:
    section.add "$.xgafv", valid_598053
  var valid_598054 = query.getOrDefault("prettyPrint")
  valid_598054 = validateParameter(valid_598054, JBool, required = false,
                                 default = newJBool(true))
  if valid_598054 != nil:
    section.add "prettyPrint", valid_598054
  var valid_598055 = query.getOrDefault("updateMask")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "updateMask", valid_598055
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

proc call*(call_598057: Call_AndroidmanagementEnterprisesWebAppsPatch_598040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a web app.
  ## 
  let valid = call_598057.validator(path, query, header, formData, body)
  let scheme = call_598057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598057.url(scheme.get, call_598057.host, call_598057.base,
                         call_598057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598057, url, valid)

proc call*(call_598058: Call_AndroidmanagementEnterprisesWebAppsPatch_598040;
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
  var path_598059 = newJObject()
  var query_598060 = newJObject()
  var body_598061 = newJObject()
  add(query_598060, "upload_protocol", newJString(uploadProtocol))
  add(query_598060, "fields", newJString(fields))
  add(query_598060, "quotaUser", newJString(quotaUser))
  add(path_598059, "name", newJString(name))
  add(query_598060, "alt", newJString(alt))
  add(query_598060, "oauth_token", newJString(oauthToken))
  add(query_598060, "callback", newJString(callback))
  add(query_598060, "access_token", newJString(accessToken))
  add(query_598060, "uploadType", newJString(uploadType))
  add(query_598060, "key", newJString(key))
  add(query_598060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598061 = body
  add(query_598060, "prettyPrint", newJBool(prettyPrint))
  add(query_598060, "updateMask", newJString(updateMask))
  result = call_598058.call(path_598059, query_598060, nil, nil, body_598061)

var androidmanagementEnterprisesWebAppsPatch* = Call_AndroidmanagementEnterprisesWebAppsPatch_598040(
    name: "androidmanagementEnterprisesWebAppsPatch", meth: HttpMethod.HttpPatch,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsPatch_598041,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsPatch_598042,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsDelete_598020 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebAppsDelete_598022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidmanagementEnterprisesWebAppsDelete_598021(path: JsonNode;
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
  var valid_598023 = path.getOrDefault("name")
  valid_598023 = validateParameter(valid_598023, JString, required = true,
                                 default = nil)
  if valid_598023 != nil:
    section.add "name", valid_598023
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
  var valid_598026 = query.getOrDefault("quotaUser")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "quotaUser", valid_598026
  var valid_598027 = query.getOrDefault("alt")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = newJString("json"))
  if valid_598027 != nil:
    section.add "alt", valid_598027
  var valid_598028 = query.getOrDefault("wipeDataFlags")
  valid_598028 = validateParameter(valid_598028, JArray, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "wipeDataFlags", valid_598028
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
  var valid_598035 = query.getOrDefault("prettyPrint")
  valid_598035 = validateParameter(valid_598035, JBool, required = false,
                                 default = newJBool(true))
  if valid_598035 != nil:
    section.add "prettyPrint", valid_598035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598036: Call_AndroidmanagementEnterprisesWebAppsDelete_598020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web app.
  ## 
  let valid = call_598036.validator(path, query, header, formData, body)
  let scheme = call_598036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598036.url(scheme.get, call_598036.host, call_598036.base,
                         call_598036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598036, url, valid)

proc call*(call_598037: Call_AndroidmanagementEnterprisesWebAppsDelete_598020;
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
  var path_598038 = newJObject()
  var query_598039 = newJObject()
  add(query_598039, "upload_protocol", newJString(uploadProtocol))
  add(query_598039, "fields", newJString(fields))
  add(query_598039, "quotaUser", newJString(quotaUser))
  add(path_598038, "name", newJString(name))
  add(query_598039, "alt", newJString(alt))
  if wipeDataFlags != nil:
    query_598039.add "wipeDataFlags", wipeDataFlags
  add(query_598039, "oauth_token", newJString(oauthToken))
  add(query_598039, "callback", newJString(callback))
  add(query_598039, "access_token", newJString(accessToken))
  add(query_598039, "uploadType", newJString(uploadType))
  add(query_598039, "key", newJString(key))
  add(query_598039, "$.xgafv", newJString(Xgafv))
  add(query_598039, "prettyPrint", newJBool(prettyPrint))
  result = call_598037.call(path_598038, query_598039, nil, nil, nil)

var androidmanagementEnterprisesWebAppsDelete* = Call_AndroidmanagementEnterprisesWebAppsDelete_598020(
    name: "androidmanagementEnterprisesWebAppsDelete",
    meth: HttpMethod.HttpDelete, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsDelete_598021,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsDelete_598022,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesOperationsCancel_598062 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesDevicesOperationsCancel_598064(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesDevicesOperationsCancel_598063(
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
  var valid_598065 = path.getOrDefault("name")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "name", valid_598065
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
  var valid_598068 = query.getOrDefault("quotaUser")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "quotaUser", valid_598068
  var valid_598069 = query.getOrDefault("alt")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("json"))
  if valid_598069 != nil:
    section.add "alt", valid_598069
  var valid_598070 = query.getOrDefault("oauth_token")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "oauth_token", valid_598070
  var valid_598071 = query.getOrDefault("callback")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "callback", valid_598071
  var valid_598072 = query.getOrDefault("access_token")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "access_token", valid_598072
  var valid_598073 = query.getOrDefault("uploadType")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "uploadType", valid_598073
  var valid_598074 = query.getOrDefault("key")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "key", valid_598074
  var valid_598075 = query.getOrDefault("$.xgafv")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("1"))
  if valid_598075 != nil:
    section.add "$.xgafv", valid_598075
  var valid_598076 = query.getOrDefault("prettyPrint")
  valid_598076 = validateParameter(valid_598076, JBool, required = false,
                                 default = newJBool(true))
  if valid_598076 != nil:
    section.add "prettyPrint", valid_598076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598077: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_598062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_598077.validator(path, query, header, formData, body)
  let scheme = call_598077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598077.url(scheme.get, call_598077.host, call_598077.base,
                         call_598077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598077, url, valid)

proc call*(call_598078: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_598062;
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
  var path_598079 = newJObject()
  var query_598080 = newJObject()
  add(query_598080, "upload_protocol", newJString(uploadProtocol))
  add(query_598080, "fields", newJString(fields))
  add(query_598080, "quotaUser", newJString(quotaUser))
  add(path_598079, "name", newJString(name))
  add(query_598080, "alt", newJString(alt))
  add(query_598080, "oauth_token", newJString(oauthToken))
  add(query_598080, "callback", newJString(callback))
  add(query_598080, "access_token", newJString(accessToken))
  add(query_598080, "uploadType", newJString(uploadType))
  add(query_598080, "key", newJString(key))
  add(query_598080, "$.xgafv", newJString(Xgafv))
  add(query_598080, "prettyPrint", newJBool(prettyPrint))
  result = call_598078.call(path_598079, query_598080, nil, nil, nil)

var androidmanagementEnterprisesDevicesOperationsCancel* = Call_AndroidmanagementEnterprisesDevicesOperationsCancel_598062(
    name: "androidmanagementEnterprisesDevicesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_AndroidmanagementEnterprisesDevicesOperationsCancel_598063,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesOperationsCancel_598064,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesIssueCommand_598081 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesDevicesIssueCommand_598083(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesDevicesIssueCommand_598082(
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
  var valid_598084 = path.getOrDefault("name")
  valid_598084 = validateParameter(valid_598084, JString, required = true,
                                 default = nil)
  if valid_598084 != nil:
    section.add "name", valid_598084
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
  var valid_598085 = query.getOrDefault("upload_protocol")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "upload_protocol", valid_598085
  var valid_598086 = query.getOrDefault("fields")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "fields", valid_598086
  var valid_598087 = query.getOrDefault("quotaUser")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "quotaUser", valid_598087
  var valid_598088 = query.getOrDefault("alt")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = newJString("json"))
  if valid_598088 != nil:
    section.add "alt", valid_598088
  var valid_598089 = query.getOrDefault("oauth_token")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "oauth_token", valid_598089
  var valid_598090 = query.getOrDefault("callback")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "callback", valid_598090
  var valid_598091 = query.getOrDefault("access_token")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "access_token", valid_598091
  var valid_598092 = query.getOrDefault("uploadType")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "uploadType", valid_598092
  var valid_598093 = query.getOrDefault("key")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "key", valid_598093
  var valid_598094 = query.getOrDefault("$.xgafv")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = newJString("1"))
  if valid_598094 != nil:
    section.add "$.xgafv", valid_598094
  var valid_598095 = query.getOrDefault("prettyPrint")
  valid_598095 = validateParameter(valid_598095, JBool, required = false,
                                 default = newJBool(true))
  if valid_598095 != nil:
    section.add "prettyPrint", valid_598095
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

proc call*(call_598097: Call_AndroidmanagementEnterprisesDevicesIssueCommand_598081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ## 
  let valid = call_598097.validator(path, query, header, formData, body)
  let scheme = call_598097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598097.url(scheme.get, call_598097.host, call_598097.base,
                         call_598097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598097, url, valid)

proc call*(call_598098: Call_AndroidmanagementEnterprisesDevicesIssueCommand_598081;
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
  var path_598099 = newJObject()
  var query_598100 = newJObject()
  var body_598101 = newJObject()
  add(query_598100, "upload_protocol", newJString(uploadProtocol))
  add(query_598100, "fields", newJString(fields))
  add(query_598100, "quotaUser", newJString(quotaUser))
  add(path_598099, "name", newJString(name))
  add(query_598100, "alt", newJString(alt))
  add(query_598100, "oauth_token", newJString(oauthToken))
  add(query_598100, "callback", newJString(callback))
  add(query_598100, "access_token", newJString(accessToken))
  add(query_598100, "uploadType", newJString(uploadType))
  add(query_598100, "key", newJString(key))
  add(query_598100, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598101 = body
  add(query_598100, "prettyPrint", newJBool(prettyPrint))
  result = call_598098.call(path_598099, query_598100, nil, nil, body_598101)

var androidmanagementEnterprisesDevicesIssueCommand* = Call_AndroidmanagementEnterprisesDevicesIssueCommand_598081(
    name: "androidmanagementEnterprisesDevicesIssueCommand",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:issueCommand",
    validator: validate_AndroidmanagementEnterprisesDevicesIssueCommand_598082,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesIssueCommand_598083,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesList_598102 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesDevicesList_598104(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesDevicesList_598103(path: JsonNode;
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
  var valid_598105 = path.getOrDefault("parent")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "parent", valid_598105
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
  var valid_598106 = query.getOrDefault("upload_protocol")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "upload_protocol", valid_598106
  var valid_598107 = query.getOrDefault("fields")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "fields", valid_598107
  var valid_598108 = query.getOrDefault("pageToken")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "pageToken", valid_598108
  var valid_598109 = query.getOrDefault("quotaUser")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "quotaUser", valid_598109
  var valid_598110 = query.getOrDefault("alt")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = newJString("json"))
  if valid_598110 != nil:
    section.add "alt", valid_598110
  var valid_598111 = query.getOrDefault("oauth_token")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "oauth_token", valid_598111
  var valid_598112 = query.getOrDefault("callback")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "callback", valid_598112
  var valid_598113 = query.getOrDefault("access_token")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "access_token", valid_598113
  var valid_598114 = query.getOrDefault("uploadType")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "uploadType", valid_598114
  var valid_598115 = query.getOrDefault("key")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "key", valid_598115
  var valid_598116 = query.getOrDefault("$.xgafv")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = newJString("1"))
  if valid_598116 != nil:
    section.add "$.xgafv", valid_598116
  var valid_598117 = query.getOrDefault("pageSize")
  valid_598117 = validateParameter(valid_598117, JInt, required = false, default = nil)
  if valid_598117 != nil:
    section.add "pageSize", valid_598117
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

proc call*(call_598119: Call_AndroidmanagementEnterprisesDevicesList_598102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists devices for a given enterprise.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AndroidmanagementEnterprisesDevicesList_598102;
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
  var path_598121 = newJObject()
  var query_598122 = newJObject()
  add(query_598122, "upload_protocol", newJString(uploadProtocol))
  add(query_598122, "fields", newJString(fields))
  add(query_598122, "pageToken", newJString(pageToken))
  add(query_598122, "quotaUser", newJString(quotaUser))
  add(query_598122, "alt", newJString(alt))
  add(query_598122, "oauth_token", newJString(oauthToken))
  add(query_598122, "callback", newJString(callback))
  add(query_598122, "access_token", newJString(accessToken))
  add(query_598122, "uploadType", newJString(uploadType))
  add(path_598121, "parent", newJString(parent))
  add(query_598122, "key", newJString(key))
  add(query_598122, "$.xgafv", newJString(Xgafv))
  add(query_598122, "pageSize", newJInt(pageSize))
  add(query_598122, "prettyPrint", newJBool(prettyPrint))
  result = call_598120.call(path_598121, query_598122, nil, nil, nil)

var androidmanagementEnterprisesDevicesList* = Call_AndroidmanagementEnterprisesDevicesList_598102(
    name: "androidmanagementEnterprisesDevicesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/devices",
    validator: validate_AndroidmanagementEnterprisesDevicesList_598103, base: "/",
    url: url_AndroidmanagementEnterprisesDevicesList_598104,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_598123 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesEnrollmentTokensCreate_598125(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_598124(
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
  var valid_598126 = path.getOrDefault("parent")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "parent", valid_598126
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
  var valid_598127 = query.getOrDefault("upload_protocol")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "upload_protocol", valid_598127
  var valid_598128 = query.getOrDefault("fields")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "fields", valid_598128
  var valid_598129 = query.getOrDefault("quotaUser")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "quotaUser", valid_598129
  var valid_598130 = query.getOrDefault("alt")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = newJString("json"))
  if valid_598130 != nil:
    section.add "alt", valid_598130
  var valid_598131 = query.getOrDefault("oauth_token")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "oauth_token", valid_598131
  var valid_598132 = query.getOrDefault("callback")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "callback", valid_598132
  var valid_598133 = query.getOrDefault("access_token")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "access_token", valid_598133
  var valid_598134 = query.getOrDefault("uploadType")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "uploadType", valid_598134
  var valid_598135 = query.getOrDefault("key")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "key", valid_598135
  var valid_598136 = query.getOrDefault("$.xgafv")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = newJString("1"))
  if valid_598136 != nil:
    section.add "$.xgafv", valid_598136
  var valid_598137 = query.getOrDefault("prettyPrint")
  valid_598137 = validateParameter(valid_598137, JBool, required = false,
                                 default = newJBool(true))
  if valid_598137 != nil:
    section.add "prettyPrint", valid_598137
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

proc call*(call_598139: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_598123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enrollment token for a given enterprise.
  ## 
  let valid = call_598139.validator(path, query, header, formData, body)
  let scheme = call_598139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598139.url(scheme.get, call_598139.host, call_598139.base,
                         call_598139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598139, url, valid)

proc call*(call_598140: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_598123;
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
  var path_598141 = newJObject()
  var query_598142 = newJObject()
  var body_598143 = newJObject()
  add(query_598142, "upload_protocol", newJString(uploadProtocol))
  add(query_598142, "fields", newJString(fields))
  add(query_598142, "quotaUser", newJString(quotaUser))
  add(query_598142, "alt", newJString(alt))
  add(query_598142, "oauth_token", newJString(oauthToken))
  add(query_598142, "callback", newJString(callback))
  add(query_598142, "access_token", newJString(accessToken))
  add(query_598142, "uploadType", newJString(uploadType))
  add(path_598141, "parent", newJString(parent))
  add(query_598142, "key", newJString(key))
  add(query_598142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598143 = body
  add(query_598142, "prettyPrint", newJBool(prettyPrint))
  result = call_598140.call(path_598141, query_598142, nil, nil, body_598143)

var androidmanagementEnterprisesEnrollmentTokensCreate* = Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_598123(
    name: "androidmanagementEnterprisesEnrollmentTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/enrollmentTokens",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_598124,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensCreate_598125,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesPoliciesList_598144 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesPoliciesList_598146(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesPoliciesList_598145(path: JsonNode;
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
  var valid_598147 = path.getOrDefault("parent")
  valid_598147 = validateParameter(valid_598147, JString, required = true,
                                 default = nil)
  if valid_598147 != nil:
    section.add "parent", valid_598147
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
  var valid_598148 = query.getOrDefault("upload_protocol")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "upload_protocol", valid_598148
  var valid_598149 = query.getOrDefault("fields")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "fields", valid_598149
  var valid_598150 = query.getOrDefault("pageToken")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "pageToken", valid_598150
  var valid_598151 = query.getOrDefault("quotaUser")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "quotaUser", valid_598151
  var valid_598152 = query.getOrDefault("alt")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = newJString("json"))
  if valid_598152 != nil:
    section.add "alt", valid_598152
  var valid_598153 = query.getOrDefault("oauth_token")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "oauth_token", valid_598153
  var valid_598154 = query.getOrDefault("callback")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "callback", valid_598154
  var valid_598155 = query.getOrDefault("access_token")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "access_token", valid_598155
  var valid_598156 = query.getOrDefault("uploadType")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "uploadType", valid_598156
  var valid_598157 = query.getOrDefault("key")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "key", valid_598157
  var valid_598158 = query.getOrDefault("$.xgafv")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = newJString("1"))
  if valid_598158 != nil:
    section.add "$.xgafv", valid_598158
  var valid_598159 = query.getOrDefault("pageSize")
  valid_598159 = validateParameter(valid_598159, JInt, required = false, default = nil)
  if valid_598159 != nil:
    section.add "pageSize", valid_598159
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

proc call*(call_598161: Call_AndroidmanagementEnterprisesPoliciesList_598144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists policies for a given enterprise.
  ## 
  let valid = call_598161.validator(path, query, header, formData, body)
  let scheme = call_598161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598161.url(scheme.get, call_598161.host, call_598161.base,
                         call_598161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598161, url, valid)

proc call*(call_598162: Call_AndroidmanagementEnterprisesPoliciesList_598144;
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
  var path_598163 = newJObject()
  var query_598164 = newJObject()
  add(query_598164, "upload_protocol", newJString(uploadProtocol))
  add(query_598164, "fields", newJString(fields))
  add(query_598164, "pageToken", newJString(pageToken))
  add(query_598164, "quotaUser", newJString(quotaUser))
  add(query_598164, "alt", newJString(alt))
  add(query_598164, "oauth_token", newJString(oauthToken))
  add(query_598164, "callback", newJString(callback))
  add(query_598164, "access_token", newJString(accessToken))
  add(query_598164, "uploadType", newJString(uploadType))
  add(path_598163, "parent", newJString(parent))
  add(query_598164, "key", newJString(key))
  add(query_598164, "$.xgafv", newJString(Xgafv))
  add(query_598164, "pageSize", newJInt(pageSize))
  add(query_598164, "prettyPrint", newJBool(prettyPrint))
  result = call_598162.call(path_598163, query_598164, nil, nil, nil)

var androidmanagementEnterprisesPoliciesList* = Call_AndroidmanagementEnterprisesPoliciesList_598144(
    name: "androidmanagementEnterprisesPoliciesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/policies",
    validator: validate_AndroidmanagementEnterprisesPoliciesList_598145,
    base: "/", url: url_AndroidmanagementEnterprisesPoliciesList_598146,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsCreate_598186 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebAppsCreate_598188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesWebAppsCreate_598187(path: JsonNode;
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
  var valid_598189 = path.getOrDefault("parent")
  valid_598189 = validateParameter(valid_598189, JString, required = true,
                                 default = nil)
  if valid_598189 != nil:
    section.add "parent", valid_598189
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
  var valid_598190 = query.getOrDefault("upload_protocol")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "upload_protocol", valid_598190
  var valid_598191 = query.getOrDefault("fields")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "fields", valid_598191
  var valid_598192 = query.getOrDefault("quotaUser")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "quotaUser", valid_598192
  var valid_598193 = query.getOrDefault("alt")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = newJString("json"))
  if valid_598193 != nil:
    section.add "alt", valid_598193
  var valid_598194 = query.getOrDefault("oauth_token")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "oauth_token", valid_598194
  var valid_598195 = query.getOrDefault("callback")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "callback", valid_598195
  var valid_598196 = query.getOrDefault("access_token")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "access_token", valid_598196
  var valid_598197 = query.getOrDefault("uploadType")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "uploadType", valid_598197
  var valid_598198 = query.getOrDefault("key")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "key", valid_598198
  var valid_598199 = query.getOrDefault("$.xgafv")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = newJString("1"))
  if valid_598199 != nil:
    section.add "$.xgafv", valid_598199
  var valid_598200 = query.getOrDefault("prettyPrint")
  valid_598200 = validateParameter(valid_598200, JBool, required = false,
                                 default = newJBool(true))
  if valid_598200 != nil:
    section.add "prettyPrint", valid_598200
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

proc call*(call_598202: Call_AndroidmanagementEnterprisesWebAppsCreate_598186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web app.
  ## 
  let valid = call_598202.validator(path, query, header, formData, body)
  let scheme = call_598202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598202.url(scheme.get, call_598202.host, call_598202.base,
                         call_598202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598202, url, valid)

proc call*(call_598203: Call_AndroidmanagementEnterprisesWebAppsCreate_598186;
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
  var path_598204 = newJObject()
  var query_598205 = newJObject()
  var body_598206 = newJObject()
  add(query_598205, "upload_protocol", newJString(uploadProtocol))
  add(query_598205, "fields", newJString(fields))
  add(query_598205, "quotaUser", newJString(quotaUser))
  add(query_598205, "alt", newJString(alt))
  add(query_598205, "oauth_token", newJString(oauthToken))
  add(query_598205, "callback", newJString(callback))
  add(query_598205, "access_token", newJString(accessToken))
  add(query_598205, "uploadType", newJString(uploadType))
  add(path_598204, "parent", newJString(parent))
  add(query_598205, "key", newJString(key))
  add(query_598205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598206 = body
  add(query_598205, "prettyPrint", newJBool(prettyPrint))
  result = call_598203.call(path_598204, query_598205, nil, nil, body_598206)

var androidmanagementEnterprisesWebAppsCreate* = Call_AndroidmanagementEnterprisesWebAppsCreate_598186(
    name: "androidmanagementEnterprisesWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsCreate_598187,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsCreate_598188,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsList_598165 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebAppsList_598167(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesWebAppsList_598166(path: JsonNode;
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
  var valid_598168 = path.getOrDefault("parent")
  valid_598168 = validateParameter(valid_598168, JString, required = true,
                                 default = nil)
  if valid_598168 != nil:
    section.add "parent", valid_598168
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
  var valid_598169 = query.getOrDefault("upload_protocol")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "upload_protocol", valid_598169
  var valid_598170 = query.getOrDefault("fields")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "fields", valid_598170
  var valid_598171 = query.getOrDefault("pageToken")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "pageToken", valid_598171
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
  var valid_598178 = query.getOrDefault("key")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "key", valid_598178
  var valid_598179 = query.getOrDefault("$.xgafv")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = newJString("1"))
  if valid_598179 != nil:
    section.add "$.xgafv", valid_598179
  var valid_598180 = query.getOrDefault("pageSize")
  valid_598180 = validateParameter(valid_598180, JInt, required = false, default = nil)
  if valid_598180 != nil:
    section.add "pageSize", valid_598180
  var valid_598181 = query.getOrDefault("prettyPrint")
  valid_598181 = validateParameter(valid_598181, JBool, required = false,
                                 default = newJBool(true))
  if valid_598181 != nil:
    section.add "prettyPrint", valid_598181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598182: Call_AndroidmanagementEnterprisesWebAppsList_598165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web apps for a given enterprise.
  ## 
  let valid = call_598182.validator(path, query, header, formData, body)
  let scheme = call_598182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598182.url(scheme.get, call_598182.host, call_598182.base,
                         call_598182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598182, url, valid)

proc call*(call_598183: Call_AndroidmanagementEnterprisesWebAppsList_598165;
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
  var path_598184 = newJObject()
  var query_598185 = newJObject()
  add(query_598185, "upload_protocol", newJString(uploadProtocol))
  add(query_598185, "fields", newJString(fields))
  add(query_598185, "pageToken", newJString(pageToken))
  add(query_598185, "quotaUser", newJString(quotaUser))
  add(query_598185, "alt", newJString(alt))
  add(query_598185, "oauth_token", newJString(oauthToken))
  add(query_598185, "callback", newJString(callback))
  add(query_598185, "access_token", newJString(accessToken))
  add(query_598185, "uploadType", newJString(uploadType))
  add(path_598184, "parent", newJString(parent))
  add(query_598185, "key", newJString(key))
  add(query_598185, "$.xgafv", newJString(Xgafv))
  add(query_598185, "pageSize", newJInt(pageSize))
  add(query_598185, "prettyPrint", newJBool(prettyPrint))
  result = call_598183.call(path_598184, query_598185, nil, nil, nil)

var androidmanagementEnterprisesWebAppsList* = Call_AndroidmanagementEnterprisesWebAppsList_598165(
    name: "androidmanagementEnterprisesWebAppsList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsList_598166, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsList_598167,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebTokensCreate_598207 = ref object of OpenApiRestCall_597421
proc url_AndroidmanagementEnterprisesWebTokensCreate_598209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroidmanagementEnterprisesWebTokensCreate_598208(path: JsonNode;
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
  var valid_598210 = path.getOrDefault("parent")
  valid_598210 = validateParameter(valid_598210, JString, required = true,
                                 default = nil)
  if valid_598210 != nil:
    section.add "parent", valid_598210
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
  var valid_598211 = query.getOrDefault("upload_protocol")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "upload_protocol", valid_598211
  var valid_598212 = query.getOrDefault("fields")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "fields", valid_598212
  var valid_598213 = query.getOrDefault("quotaUser")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "quotaUser", valid_598213
  var valid_598214 = query.getOrDefault("alt")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = newJString("json"))
  if valid_598214 != nil:
    section.add "alt", valid_598214
  var valid_598215 = query.getOrDefault("oauth_token")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "oauth_token", valid_598215
  var valid_598216 = query.getOrDefault("callback")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "callback", valid_598216
  var valid_598217 = query.getOrDefault("access_token")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "access_token", valid_598217
  var valid_598218 = query.getOrDefault("uploadType")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "uploadType", valid_598218
  var valid_598219 = query.getOrDefault("key")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "key", valid_598219
  var valid_598220 = query.getOrDefault("$.xgafv")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = newJString("1"))
  if valid_598220 != nil:
    section.add "$.xgafv", valid_598220
  var valid_598221 = query.getOrDefault("prettyPrint")
  valid_598221 = validateParameter(valid_598221, JBool, required = false,
                                 default = newJBool(true))
  if valid_598221 != nil:
    section.add "prettyPrint", valid_598221
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

proc call*(call_598223: Call_AndroidmanagementEnterprisesWebTokensCreate_598207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
  ## 
  let valid = call_598223.validator(path, query, header, formData, body)
  let scheme = call_598223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598223.url(scheme.get, call_598223.host, call_598223.base,
                         call_598223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598223, url, valid)

proc call*(call_598224: Call_AndroidmanagementEnterprisesWebTokensCreate_598207;
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
  var path_598225 = newJObject()
  var query_598226 = newJObject()
  var body_598227 = newJObject()
  add(query_598226, "upload_protocol", newJString(uploadProtocol))
  add(query_598226, "fields", newJString(fields))
  add(query_598226, "quotaUser", newJString(quotaUser))
  add(query_598226, "alt", newJString(alt))
  add(query_598226, "oauth_token", newJString(oauthToken))
  add(query_598226, "callback", newJString(callback))
  add(query_598226, "access_token", newJString(accessToken))
  add(query_598226, "uploadType", newJString(uploadType))
  add(path_598225, "parent", newJString(parent))
  add(query_598226, "key", newJString(key))
  add(query_598226, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598227 = body
  add(query_598226, "prettyPrint", newJBool(prettyPrint))
  result = call_598224.call(path_598225, query_598226, nil, nil, body_598227)

var androidmanagementEnterprisesWebTokensCreate* = Call_AndroidmanagementEnterprisesWebTokensCreate_598207(
    name: "androidmanagementEnterprisesWebTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/webTokens",
    validator: validate_AndroidmanagementEnterprisesWebTokensCreate_598208,
    base: "/", url: url_AndroidmanagementEnterprisesWebTokensCreate_598209,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
