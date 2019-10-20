
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
  gcpServiceName = "androidmanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidmanagementEnterprisesCreate_578619 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesCreate_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementEnterprisesCreate_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   signupUrlName: JString
  ##                : The name of the SignupUrl used to sign up for the enterprise.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   enterpriseToken: JString
  ##                  : The enterprise token appended to the callback URL.
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
  ##   projectId: JString
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578734 = query.getOrDefault("signupUrlName")
  valid_578734 = validateParameter(valid_578734, JString, required = false,
                                 default = nil)
  if valid_578734 != nil:
    section.add "signupUrlName", valid_578734
  var valid_578748 = query.getOrDefault("prettyPrint")
  valid_578748 = validateParameter(valid_578748, JBool, required = false,
                                 default = newJBool(true))
  if valid_578748 != nil:
    section.add "prettyPrint", valid_578748
  var valid_578749 = query.getOrDefault("oauth_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "oauth_token", valid_578749
  var valid_578750 = query.getOrDefault("$.xgafv")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("1"))
  if valid_578750 != nil:
    section.add "$.xgafv", valid_578750
  var valid_578751 = query.getOrDefault("enterpriseToken")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "enterpriseToken", valid_578751
  var valid_578752 = query.getOrDefault("alt")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = newJString("json"))
  if valid_578752 != nil:
    section.add "alt", valid_578752
  var valid_578753 = query.getOrDefault("uploadType")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "uploadType", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("callback")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "callback", valid_578755
  var valid_578756 = query.getOrDefault("fields")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "fields", valid_578756
  var valid_578757 = query.getOrDefault("access_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "access_token", valid_578757
  var valid_578758 = query.getOrDefault("upload_protocol")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "upload_protocol", valid_578758
  var valid_578759 = query.getOrDefault("projectId")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "projectId", valid_578759
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

proc call*(call_578783: Call_AndroidmanagementEnterprisesCreate_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_AndroidmanagementEnterprisesCreate_578619;
          key: string = ""; signupUrlName: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; enterpriseToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## androidmanagementEnterprisesCreate
  ## Creates an enterprise. This is the last step in the enterprise signup flow.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   signupUrlName: string
  ##                : The name of the SignupUrl used to sign up for the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   enterpriseToken: string
  ##                  : The enterprise token appended to the callback URL.
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
  ##   projectId: string
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  var query_578855 = newJObject()
  var body_578857 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "signupUrlName", newJString(signupUrlName))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "$.xgafv", newJString(Xgafv))
  add(query_578855, "enterpriseToken", newJString(enterpriseToken))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "uploadType", newJString(uploadType))
  add(query_578855, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578857 = body
  add(query_578855, "callback", newJString(callback))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "access_token", newJString(accessToken))
  add(query_578855, "upload_protocol", newJString(uploadProtocol))
  add(query_578855, "projectId", newJString(projectId))
  result = call_578854.call(nil, query_578855, nil, nil, body_578857)

var androidmanagementEnterprisesCreate* = Call_AndroidmanagementEnterprisesCreate_578619(
    name: "androidmanagementEnterprisesCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/enterprises",
    validator: validate_AndroidmanagementEnterprisesCreate_578620, base: "/",
    url: url_AndroidmanagementEnterprisesCreate_578621, schemes: {Scheme.Https})
type
  Call_AndroidmanagementSignupUrlsCreate_578896 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementSignupUrlsCreate_578898(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidmanagementSignupUrlsCreate_578897(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an enterprise signup URL.
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
  ##   callbackUrl: JString
  ##              : The callback URL that the admin will be redirected to after successfully creating an enterprise. Before redirecting there the system will add a query parameter to this URL named enterpriseToken which will contain an opaque token to be used for the create enterprise request. The URL will be parsed then reformatted in order to add the enterpriseToken parameter, so there may be some minor formatting changes.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  section = newJObject()
  var valid_578899 = query.getOrDefault("key")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "key", valid_578899
  var valid_578900 = query.getOrDefault("prettyPrint")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(true))
  if valid_578900 != nil:
    section.add "prettyPrint", valid_578900
  var valid_578901 = query.getOrDefault("oauth_token")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "oauth_token", valid_578901
  var valid_578902 = query.getOrDefault("$.xgafv")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("1"))
  if valid_578902 != nil:
    section.add "$.xgafv", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("uploadType")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "uploadType", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("callbackUrl")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "callbackUrl", valid_578906
  var valid_578907 = query.getOrDefault("callback")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "callback", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
  var valid_578909 = query.getOrDefault("access_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "access_token", valid_578909
  var valid_578910 = query.getOrDefault("upload_protocol")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "upload_protocol", valid_578910
  var valid_578911 = query.getOrDefault("projectId")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "projectId", valid_578911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578912: Call_AndroidmanagementSignupUrlsCreate_578896;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enterprise signup URL.
  ## 
  let valid = call_578912.validator(path, query, header, formData, body)
  let scheme = call_578912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578912.url(scheme.get, call_578912.host, call_578912.base,
                         call_578912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578912, url, valid)

proc call*(call_578913: Call_AndroidmanagementSignupUrlsCreate_578896;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callbackUrl: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## androidmanagementSignupUrlsCreate
  ## Creates an enterprise signup URL.
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
  ##   callbackUrl: string
  ##              : The callback URL that the admin will be redirected to after successfully creating an enterprise. Before redirecting there the system will add a query parameter to this URL named enterpriseToken which will contain an opaque token to be used for the create enterprise request. The URL will be parsed then reformatted in order to add the enterpriseToken parameter, so there may be some minor formatting changes.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The ID of the Google Cloud Platform project which will own the enterprise.
  var query_578914 = newJObject()
  add(query_578914, "key", newJString(key))
  add(query_578914, "prettyPrint", newJBool(prettyPrint))
  add(query_578914, "oauth_token", newJString(oauthToken))
  add(query_578914, "$.xgafv", newJString(Xgafv))
  add(query_578914, "alt", newJString(alt))
  add(query_578914, "uploadType", newJString(uploadType))
  add(query_578914, "quotaUser", newJString(quotaUser))
  add(query_578914, "callbackUrl", newJString(callbackUrl))
  add(query_578914, "callback", newJString(callback))
  add(query_578914, "fields", newJString(fields))
  add(query_578914, "access_token", newJString(accessToken))
  add(query_578914, "upload_protocol", newJString(uploadProtocol))
  add(query_578914, "projectId", newJString(projectId))
  result = call_578913.call(nil, query_578914, nil, nil, nil)

var androidmanagementSignupUrlsCreate* = Call_AndroidmanagementSignupUrlsCreate_578896(
    name: "androidmanagementSignupUrlsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/signupUrls",
    validator: validate_AndroidmanagementSignupUrlsCreate_578897, base: "/",
    url: url_AndroidmanagementSignupUrlsCreate_578898, schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsGet_578915 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesWebAppsGet_578917(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsGet_578916(path: JsonNode;
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
  var valid_578932 = path.getOrDefault("name")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "name", valid_578932
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
  ##   languageCode: JString
  ##               : The preferred language for localized application info, as a BCP47 tag (e.g. "en-US", "de"). If not specified the default language of the application will be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("languageCode")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "languageCode", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  var valid_578943 = query.getOrDefault("access_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "access_token", valid_578943
  var valid_578944 = query.getOrDefault("upload_protocol")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "upload_protocol", valid_578944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578945: Call_AndroidmanagementEnterprisesWebAppsGet_578915;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web app.
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_AndroidmanagementEnterprisesWebAppsGet_578915;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesWebAppsGet
  ## Gets a web app.
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
  ##   name: string (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApp/{packageName}.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : The preferred language for localized application info, as a BCP47 tag (e.g. "en-US", "de"). If not specified the default language of the application will be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578947 = newJObject()
  var query_578948 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(query_578948, "$.xgafv", newJString(Xgafv))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "uploadType", newJString(uploadType))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(path_578947, "name", newJString(name))
  add(query_578948, "callback", newJString(callback))
  add(query_578948, "languageCode", newJString(languageCode))
  add(query_578948, "fields", newJString(fields))
  add(query_578948, "access_token", newJString(accessToken))
  add(query_578948, "upload_protocol", newJString(uploadProtocol))
  result = call_578946.call(path_578947, query_578948, nil, nil, nil)

var androidmanagementEnterprisesWebAppsGet* = Call_AndroidmanagementEnterprisesWebAppsGet_578915(
    name: "androidmanagementEnterprisesWebAppsGet", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsGet_578916, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsGet_578917,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsPatch_578969 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesWebAppsPatch_578971(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsPatch_578970(path: JsonNode;
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
  var valid_578972 = path.getOrDefault("name")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "name", valid_578972
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
  ##             : The field mask indicating the fields to update. If not set, all modifiable fields will be modified.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("$.xgafv")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("1"))
  if valid_578976 != nil:
    section.add "$.xgafv", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("updateMask")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "updateMask", valid_578980
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

proc call*(call_578986: Call_AndroidmanagementEnterprisesWebAppsPatch_578969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a web app.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_AndroidmanagementEnterprisesWebAppsPatch_578969;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesWebAppsPatch
  ## Updates a web app.
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
  ##   name: string (required)
  ##       : The name of the web app in the form enterprises/{enterpriseId}/webApps/{packageName}.
  ##   updateMask: string
  ##             : The field mask indicating the fields to update. If not set, all modifiable fields will be modified.
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
  add(query_578989, "quotaUser", newJString(quotaUser))
  add(path_578988, "name", newJString(name))
  add(query_578989, "updateMask", newJString(updateMask))
  if body != nil:
    body_578990 = body
  add(query_578989, "callback", newJString(callback))
  add(query_578989, "fields", newJString(fields))
  add(query_578989, "access_token", newJString(accessToken))
  add(query_578989, "upload_protocol", newJString(uploadProtocol))
  result = call_578987.call(path_578988, query_578989, nil, nil, body_578990)

var androidmanagementEnterprisesWebAppsPatch* = Call_AndroidmanagementEnterprisesWebAppsPatch_578969(
    name: "androidmanagementEnterprisesWebAppsPatch", meth: HttpMethod.HttpPatch,
    host: "androidmanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesWebAppsPatch_578970,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsPatch_578971,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_578949 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesEnrollmentTokensDelete_578951(
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

proc validate_AndroidmanagementEnterprisesEnrollmentTokensDelete_578950(
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
  var valid_578952 = path.getOrDefault("name")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "name", valid_578952
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
  ##   wipeDataFlags: JArray
  ##                : Optional flags that control the device wiping behavior.
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
  var valid_578960 = query.getOrDefault("callback")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "callback", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  var valid_578962 = query.getOrDefault("access_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "access_token", valid_578962
  var valid_578963 = query.getOrDefault("upload_protocol")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "upload_protocol", valid_578963
  var valid_578964 = query.getOrDefault("wipeDataFlags")
  valid_578964 = validateParameter(valid_578964, JArray, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "wipeDataFlags", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an enrollment token. This operation invalidates the token, preventing its future use.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_578949;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          wipeDataFlags: JsonNode = nil): Recallable =
  ## androidmanagementEnterprisesEnrollmentTokensDelete
  ## Deletes an enrollment token. This operation invalidates the token, preventing its future use.
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
  ##   name: string (required)
  ##       : The name of the enrollment token in the form enterprises/{enterpriseId}/enrollmentTokens/{enrollmentTokenId}.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   wipeDataFlags: JArray
  ##                : Optional flags that control the device wiping behavior.
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "name", newJString(name))
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  if wipeDataFlags != nil:
    query_578968.add "wipeDataFlags", wipeDataFlags
  result = call_578966.call(path_578967, query_578968, nil, nil, nil)

var androidmanagementEnterprisesEnrollmentTokensDelete* = Call_AndroidmanagementEnterprisesEnrollmentTokensDelete_578949(
    name: "androidmanagementEnterprisesEnrollmentTokensDelete",
    meth: HttpMethod.HttpDelete, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensDelete_578950,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensDelete_578951,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesOperationsCancel_578991 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesDevicesOperationsCancel_578993(
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

proc validate_AndroidmanagementEnterprisesDevicesOperationsCancel_578992(
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
  var valid_578994 = path.getOrDefault("name")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "name", valid_578994
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
  var valid_578999 = query.getOrDefault("alt")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("json"))
  if valid_578999 != nil:
    section.add "alt", valid_578999
  var valid_579000 = query.getOrDefault("uploadType")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "uploadType", valid_579000
  var valid_579001 = query.getOrDefault("quotaUser")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "quotaUser", valid_579001
  var valid_579002 = query.getOrDefault("callback")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "callback", valid_579002
  var valid_579003 = query.getOrDefault("fields")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "fields", valid_579003
  var valid_579004 = query.getOrDefault("access_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "access_token", valid_579004
  var valid_579005 = query.getOrDefault("upload_protocol")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "upload_protocol", valid_579005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579006: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_578991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_AndroidmanagementEnterprisesDevicesOperationsCancel_578991;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesDevicesOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation. The server makes a best effort to cancel the operation, but success is not guaranteed. If the server doesn't support this method, it returns google.rpc.Code.UNIMPLEMENTED. Clients can use Operations.GetOperation or other methods to check whether the cancellation succeeded or whether the operation completed despite cancellation. On successful cancellation, the operation is not deleted; instead, it becomes an operation with an Operation.error value with a google.rpc.Status.code of 1, corresponding to Code.CANCELLED.
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
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "$.xgafv", newJString(Xgafv))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "uploadType", newJString(uploadType))
  add(query_579009, "quotaUser", newJString(quotaUser))
  add(path_579008, "name", newJString(name))
  add(query_579009, "callback", newJString(callback))
  add(query_579009, "fields", newJString(fields))
  add(query_579009, "access_token", newJString(accessToken))
  add(query_579009, "upload_protocol", newJString(uploadProtocol))
  result = call_579007.call(path_579008, query_579009, nil, nil, nil)

var androidmanagementEnterprisesDevicesOperationsCancel* = Call_AndroidmanagementEnterprisesDevicesOperationsCancel_578991(
    name: "androidmanagementEnterprisesDevicesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_AndroidmanagementEnterprisesDevicesOperationsCancel_578992,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesOperationsCancel_578993,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesIssueCommand_579010 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesDevicesIssueCommand_579012(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesDevicesIssueCommand_579011(
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
  var valid_579013 = path.getOrDefault("name")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "name", valid_579013
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
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("prettyPrint")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "prettyPrint", valid_579015
  var valid_579016 = query.getOrDefault("oauth_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "oauth_token", valid_579016
  var valid_579017 = query.getOrDefault("$.xgafv")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("1"))
  if valid_579017 != nil:
    section.add "$.xgafv", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("uploadType")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "uploadType", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("callback")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "callback", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  var valid_579023 = query.getOrDefault("access_token")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "access_token", valid_579023
  var valid_579024 = query.getOrDefault("upload_protocol")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "upload_protocol", valid_579024
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

proc call*(call_579026: Call_AndroidmanagementEnterprisesDevicesIssueCommand_579010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_AndroidmanagementEnterprisesDevicesIssueCommand_579010;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesDevicesIssueCommand
  ## Issues a command to a device. The Operation resource returned contains a Command in its metadata field. Use the get operation method to get the status of the command.
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
  ##   name: string (required)
  ##       : The name of the device in the form enterprises/{enterpriseId}/devices/{deviceId}.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  var body_579030 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "$.xgafv", newJString(Xgafv))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "uploadType", newJString(uploadType))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "name", newJString(name))
  if body != nil:
    body_579030 = body
  add(query_579029, "callback", newJString(callback))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "access_token", newJString(accessToken))
  add(query_579029, "upload_protocol", newJString(uploadProtocol))
  result = call_579027.call(path_579028, query_579029, nil, nil, body_579030)

var androidmanagementEnterprisesDevicesIssueCommand* = Call_AndroidmanagementEnterprisesDevicesIssueCommand_579010(
    name: "androidmanagementEnterprisesDevicesIssueCommand",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{name}:issueCommand",
    validator: validate_AndroidmanagementEnterprisesDevicesIssueCommand_579011,
    base: "/", url: url_AndroidmanagementEnterprisesDevicesIssueCommand_579012,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesDevicesList_579031 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesDevicesList_579033(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesDevicesList_579032(path: JsonNode;
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
  var valid_579034 = path.getOrDefault("parent")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "parent", valid_579034
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("$.xgafv")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("1"))
  if valid_579038 != nil:
    section.add "$.xgafv", valid_579038
  var valid_579039 = query.getOrDefault("pageSize")
  valid_579039 = validateParameter(valid_579039, JInt, required = false, default = nil)
  if valid_579039 != nil:
    section.add "pageSize", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("uploadType")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "uploadType", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("pageToken")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "pageToken", valid_579043
  var valid_579044 = query.getOrDefault("callback")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "callback", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  var valid_579046 = query.getOrDefault("access_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "access_token", valid_579046
  var valid_579047 = query.getOrDefault("upload_protocol")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "upload_protocol", valid_579047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579048: Call_AndroidmanagementEnterprisesDevicesList_579031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists devices for a given enterprise.
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_AndroidmanagementEnterprisesDevicesList_579031;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesDevicesList
  ## Lists devices for a given enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "$.xgafv", newJString(Xgafv))
  add(query_579051, "pageSize", newJInt(pageSize))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "uploadType", newJString(uploadType))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(query_579051, "pageToken", newJString(pageToken))
  add(query_579051, "callback", newJString(callback))
  add(path_579050, "parent", newJString(parent))
  add(query_579051, "fields", newJString(fields))
  add(query_579051, "access_token", newJString(accessToken))
  add(query_579051, "upload_protocol", newJString(uploadProtocol))
  result = call_579049.call(path_579050, query_579051, nil, nil, nil)

var androidmanagementEnterprisesDevicesList* = Call_AndroidmanagementEnterprisesDevicesList_579031(
    name: "androidmanagementEnterprisesDevicesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/devices",
    validator: validate_AndroidmanagementEnterprisesDevicesList_579032, base: "/",
    url: url_AndroidmanagementEnterprisesDevicesList_579033,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_579052 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesEnrollmentTokensCreate_579054(
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

proc validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_579053(
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
  var valid_579055 = path.getOrDefault("parent")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "parent", valid_579055
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
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("$.xgafv")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("1"))
  if valid_579059 != nil:
    section.add "$.xgafv", valid_579059
  var valid_579060 = query.getOrDefault("alt")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("json"))
  if valid_579060 != nil:
    section.add "alt", valid_579060
  var valid_579061 = query.getOrDefault("uploadType")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "uploadType", valid_579061
  var valid_579062 = query.getOrDefault("quotaUser")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "quotaUser", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
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

proc call*(call_579068: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_579052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an enrollment token for a given enterprise.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_579052;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesEnrollmentTokensCreate
  ## Creates an enrollment token for a given enterprise.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579070 = newJObject()
  var query_579071 = newJObject()
  var body_579072 = newJObject()
  add(query_579071, "key", newJString(key))
  add(query_579071, "prettyPrint", newJBool(prettyPrint))
  add(query_579071, "oauth_token", newJString(oauthToken))
  add(query_579071, "$.xgafv", newJString(Xgafv))
  add(query_579071, "alt", newJString(alt))
  add(query_579071, "uploadType", newJString(uploadType))
  add(query_579071, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579072 = body
  add(query_579071, "callback", newJString(callback))
  add(path_579070, "parent", newJString(parent))
  add(query_579071, "fields", newJString(fields))
  add(query_579071, "access_token", newJString(accessToken))
  add(query_579071, "upload_protocol", newJString(uploadProtocol))
  result = call_579069.call(path_579070, query_579071, nil, nil, body_579072)

var androidmanagementEnterprisesEnrollmentTokensCreate* = Call_AndroidmanagementEnterprisesEnrollmentTokensCreate_579052(
    name: "androidmanagementEnterprisesEnrollmentTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/enrollmentTokens",
    validator: validate_AndroidmanagementEnterprisesEnrollmentTokensCreate_579053,
    base: "/", url: url_AndroidmanagementEnterprisesEnrollmentTokensCreate_579054,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesPoliciesList_579073 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesPoliciesList_579075(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesPoliciesList_579074(path: JsonNode;
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
  var valid_579076 = path.getOrDefault("parent")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "parent", valid_579076
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579077 = query.getOrDefault("key")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "key", valid_579077
  var valid_579078 = query.getOrDefault("prettyPrint")
  valid_579078 = validateParameter(valid_579078, JBool, required = false,
                                 default = newJBool(true))
  if valid_579078 != nil:
    section.add "prettyPrint", valid_579078
  var valid_579079 = query.getOrDefault("oauth_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "oauth_token", valid_579079
  var valid_579080 = query.getOrDefault("$.xgafv")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("1"))
  if valid_579080 != nil:
    section.add "$.xgafv", valid_579080
  var valid_579081 = query.getOrDefault("pageSize")
  valid_579081 = validateParameter(valid_579081, JInt, required = false, default = nil)
  if valid_579081 != nil:
    section.add "pageSize", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("uploadType")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "uploadType", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("pageToken")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "pageToken", valid_579085
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

proc call*(call_579090: Call_AndroidmanagementEnterprisesPoliciesList_579073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists policies for a given enterprise.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_AndroidmanagementEnterprisesPoliciesList_579073;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesPoliciesList
  ## Lists policies for a given enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
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
  add(query_579093, "pageSize", newJInt(pageSize))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(query_579093, "pageToken", newJString(pageToken))
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "parent", newJString(parent))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, nil)

var androidmanagementEnterprisesPoliciesList* = Call_AndroidmanagementEnterprisesPoliciesList_579073(
    name: "androidmanagementEnterprisesPoliciesList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/policies",
    validator: validate_AndroidmanagementEnterprisesPoliciesList_579074,
    base: "/", url: url_AndroidmanagementEnterprisesPoliciesList_579075,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsCreate_579115 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesWebAppsCreate_579117(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsCreate_579116(path: JsonNode;
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
  var valid_579118 = path.getOrDefault("parent")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "parent", valid_579118
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
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("$.xgafv")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("1"))
  if valid_579122 != nil:
    section.add "$.xgafv", valid_579122
  var valid_579123 = query.getOrDefault("alt")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("json"))
  if valid_579123 != nil:
    section.add "alt", valid_579123
  var valid_579124 = query.getOrDefault("uploadType")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "uploadType", valid_579124
  var valid_579125 = query.getOrDefault("quotaUser")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "quotaUser", valid_579125
  var valid_579126 = query.getOrDefault("callback")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "callback", valid_579126
  var valid_579127 = query.getOrDefault("fields")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "fields", valid_579127
  var valid_579128 = query.getOrDefault("access_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "access_token", valid_579128
  var valid_579129 = query.getOrDefault("upload_protocol")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "upload_protocol", valid_579129
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

proc call*(call_579131: Call_AndroidmanagementEnterprisesWebAppsCreate_579115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web app.
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_AndroidmanagementEnterprisesWebAppsCreate_579115;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesWebAppsCreate
  ## Creates a web app.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  var body_579135 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(query_579134, "$.xgafv", newJString(Xgafv))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "uploadType", newJString(uploadType))
  add(query_579134, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579135 = body
  add(query_579134, "callback", newJString(callback))
  add(path_579133, "parent", newJString(parent))
  add(query_579134, "fields", newJString(fields))
  add(query_579134, "access_token", newJString(accessToken))
  add(query_579134, "upload_protocol", newJString(uploadProtocol))
  result = call_579132.call(path_579133, query_579134, nil, nil, body_579135)

var androidmanagementEnterprisesWebAppsCreate* = Call_AndroidmanagementEnterprisesWebAppsCreate_579115(
    name: "androidmanagementEnterprisesWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsCreate_579116,
    base: "/", url: url_AndroidmanagementEnterprisesWebAppsCreate_579117,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebAppsList_579094 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesWebAppsList_579096(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebAppsList_579095(path: JsonNode;
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
  var valid_579097 = path.getOrDefault("parent")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "parent", valid_579097
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
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579098 = query.getOrDefault("key")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "key", valid_579098
  var valid_579099 = query.getOrDefault("prettyPrint")
  valid_579099 = validateParameter(valid_579099, JBool, required = false,
                                 default = newJBool(true))
  if valid_579099 != nil:
    section.add "prettyPrint", valid_579099
  var valid_579100 = query.getOrDefault("oauth_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "oauth_token", valid_579100
  var valid_579101 = query.getOrDefault("$.xgafv")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = newJString("1"))
  if valid_579101 != nil:
    section.add "$.xgafv", valid_579101
  var valid_579102 = query.getOrDefault("pageSize")
  valid_579102 = validateParameter(valid_579102, JInt, required = false, default = nil)
  if valid_579102 != nil:
    section.add "pageSize", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("uploadType")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "uploadType", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("pageToken")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "pageToken", valid_579106
  var valid_579107 = query.getOrDefault("callback")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "callback", valid_579107
  var valid_579108 = query.getOrDefault("fields")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "fields", valid_579108
  var valid_579109 = query.getOrDefault("access_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "access_token", valid_579109
  var valid_579110 = query.getOrDefault("upload_protocol")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "upload_protocol", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_AndroidmanagementEnterprisesWebAppsList_579094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web apps for a given enterprise.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_AndroidmanagementEnterprisesWebAppsList_579094;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesWebAppsList
  ## Lists web apps for a given enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The requested page size. The actual page size may be fixed to a min or max value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "pageSize", newJInt(pageSize))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(query_579114, "pageToken", newJString(pageToken))
  add(query_579114, "callback", newJString(callback))
  add(path_579113, "parent", newJString(parent))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var androidmanagementEnterprisesWebAppsList* = Call_AndroidmanagementEnterprisesWebAppsList_579094(
    name: "androidmanagementEnterprisesWebAppsList", meth: HttpMethod.HttpGet,
    host: "androidmanagement.googleapis.com", route: "/v1/{parent}/webApps",
    validator: validate_AndroidmanagementEnterprisesWebAppsList_579095, base: "/",
    url: url_AndroidmanagementEnterprisesWebAppsList_579096,
    schemes: {Scheme.Https})
type
  Call_AndroidmanagementEnterprisesWebTokensCreate_579136 = ref object of OpenApiRestCall_578348
proc url_AndroidmanagementEnterprisesWebTokensCreate_579138(protocol: Scheme;
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

proc validate_AndroidmanagementEnterprisesWebTokensCreate_579137(path: JsonNode;
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
  var valid_579139 = path.getOrDefault("parent")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "parent", valid_579139
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
  var valid_579140 = query.getOrDefault("key")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "key", valid_579140
  var valid_579141 = query.getOrDefault("prettyPrint")
  valid_579141 = validateParameter(valid_579141, JBool, required = false,
                                 default = newJBool(true))
  if valid_579141 != nil:
    section.add "prettyPrint", valid_579141
  var valid_579142 = query.getOrDefault("oauth_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "oauth_token", valid_579142
  var valid_579143 = query.getOrDefault("$.xgafv")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("1"))
  if valid_579143 != nil:
    section.add "$.xgafv", valid_579143
  var valid_579144 = query.getOrDefault("alt")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("json"))
  if valid_579144 != nil:
    section.add "alt", valid_579144
  var valid_579145 = query.getOrDefault("uploadType")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "uploadType", valid_579145
  var valid_579146 = query.getOrDefault("quotaUser")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "quotaUser", valid_579146
  var valid_579147 = query.getOrDefault("callback")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "callback", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  var valid_579149 = query.getOrDefault("access_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "access_token", valid_579149
  var valid_579150 = query.getOrDefault("upload_protocol")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "upload_protocol", valid_579150
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

proc call*(call_579152: Call_AndroidmanagementEnterprisesWebTokensCreate_579136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
  ## 
  let valid = call_579152.validator(path, query, header, formData, body)
  let scheme = call_579152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579152.url(scheme.get, call_579152.host, call_579152.base,
                         call_579152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579152, url, valid)

proc call*(call_579153: Call_AndroidmanagementEnterprisesWebTokensCreate_579136;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androidmanagementEnterprisesWebTokensCreate
  ## Creates a web token to access an embeddable managed Google Play web UI for a given enterprise.
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
  ##   parent: string (required)
  ##         : The name of the enterprise in the form enterprises/{enterpriseId}.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579154 = newJObject()
  var query_579155 = newJObject()
  var body_579156 = newJObject()
  add(query_579155, "key", newJString(key))
  add(query_579155, "prettyPrint", newJBool(prettyPrint))
  add(query_579155, "oauth_token", newJString(oauthToken))
  add(query_579155, "$.xgafv", newJString(Xgafv))
  add(query_579155, "alt", newJString(alt))
  add(query_579155, "uploadType", newJString(uploadType))
  add(query_579155, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579156 = body
  add(query_579155, "callback", newJString(callback))
  add(path_579154, "parent", newJString(parent))
  add(query_579155, "fields", newJString(fields))
  add(query_579155, "access_token", newJString(accessToken))
  add(query_579155, "upload_protocol", newJString(uploadProtocol))
  result = call_579153.call(path_579154, query_579155, nil, nil, body_579156)

var androidmanagementEnterprisesWebTokensCreate* = Call_AndroidmanagementEnterprisesWebTokensCreate_579136(
    name: "androidmanagementEnterprisesWebTokensCreate",
    meth: HttpMethod.HttpPost, host: "androidmanagement.googleapis.com",
    route: "/v1/{parent}/webTokens",
    validator: validate_AndroidmanagementEnterprisesWebTokensCreate_579137,
    base: "/", url: url_AndroidmanagementEnterprisesWebTokensCreate_579138,
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
