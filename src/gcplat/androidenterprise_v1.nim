
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play EMM
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages the deployment of apps to Android for Work users.
## 
## https://developers.google.com/android/work/play/emm-api
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
  gcpServiceName = "androidenterprise"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidenterpriseEnterprisesList_578618 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesList_578620(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesList_578619(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
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
  ##   domain: JString (required)
  ##         : The exact primary domain name of the enterprise to look up.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578732 = query.getOrDefault("key")
  valid_578732 = validateParameter(valid_578732, JString, required = false,
                                 default = nil)
  if valid_578732 != nil:
    section.add "key", valid_578732
  var valid_578746 = query.getOrDefault("prettyPrint")
  valid_578746 = validateParameter(valid_578746, JBool, required = false,
                                 default = newJBool(true))
  if valid_578746 != nil:
    section.add "prettyPrint", valid_578746
  var valid_578747 = query.getOrDefault("oauth_token")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "oauth_token", valid_578747
  assert query != nil, "query argument is necessary due to required `domain` field"
  var valid_578748 = query.getOrDefault("domain")
  valid_578748 = validateParameter(valid_578748, JString, required = true,
                                 default = nil)
  if valid_578748 != nil:
    section.add "domain", valid_578748
  var valid_578749 = query.getOrDefault("alt")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("json"))
  if valid_578749 != nil:
    section.add "alt", valid_578749
  var valid_578750 = query.getOrDefault("userIp")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "userIp", valid_578750
  var valid_578751 = query.getOrDefault("quotaUser")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "quotaUser", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578775: Call_AndroidenterpriseEnterprisesList_578618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
  ## 
  let valid = call_578775.validator(path, query, header, formData, body)
  let scheme = call_578775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578775.url(scheme.get, call_578775.host, call_578775.base,
                         call_578775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578775, url, valid)

proc call*(call_578846: Call_AndroidenterpriseEnterprisesList_578618;
          domain: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesList
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   domain: string (required)
  ##         : The exact primary domain name of the enterprise to look up.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578847 = newJObject()
  add(query_578847, "key", newJString(key))
  add(query_578847, "prettyPrint", newJBool(prettyPrint))
  add(query_578847, "oauth_token", newJString(oauthToken))
  add(query_578847, "domain", newJString(domain))
  add(query_578847, "alt", newJString(alt))
  add(query_578847, "userIp", newJString(userIp))
  add(query_578847, "quotaUser", newJString(quotaUser))
  add(query_578847, "fields", newJString(fields))
  result = call_578846.call(nil, query_578847, nil, nil, nil)

var androidenterpriseEnterprisesList* = Call_AndroidenterpriseEnterprisesList_578618(
    name: "androidenterpriseEnterprisesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises",
    validator: validate_AndroidenterpriseEnterprisesList_578619,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesList_578620,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578887 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578889(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578888(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   notificationSetId: JString
  ##                    : The notification set ID as returned by Enterprises.PullNotificationSet. This must be provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578890 = query.getOrDefault("key")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "key", valid_578890
  var valid_578891 = query.getOrDefault("prettyPrint")
  valid_578891 = validateParameter(valid_578891, JBool, required = false,
                                 default = newJBool(true))
  if valid_578891 != nil:
    section.add "prettyPrint", valid_578891
  var valid_578892 = query.getOrDefault("oauth_token")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "oauth_token", valid_578892
  var valid_578893 = query.getOrDefault("alt")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = newJString("json"))
  if valid_578893 != nil:
    section.add "alt", valid_578893
  var valid_578894 = query.getOrDefault("userIp")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "userIp", valid_578894
  var valid_578895 = query.getOrDefault("quotaUser")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "quotaUser", valid_578895
  var valid_578896 = query.getOrDefault("notificationSetId")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "notificationSetId", valid_578896
  var valid_578897 = query.getOrDefault("fields")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "fields", valid_578897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578898: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578887;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
  ## 
  let valid = call_578898.validator(path, query, header, formData, body)
  let scheme = call_578898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578898.url(scheme.get, call_578898.host, call_578898.base,
                         call_578898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578898, url, valid)

proc call*(call_578899: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578887;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          notificationSetId: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesAcknowledgeNotificationSet
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   notificationSetId: string
  ##                    : The notification set ID as returned by Enterprises.PullNotificationSet. This must be provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578900 = newJObject()
  add(query_578900, "key", newJString(key))
  add(query_578900, "prettyPrint", newJBool(prettyPrint))
  add(query_578900, "oauth_token", newJString(oauthToken))
  add(query_578900, "alt", newJString(alt))
  add(query_578900, "userIp", newJString(userIp))
  add(query_578900, "quotaUser", newJString(quotaUser))
  add(query_578900, "notificationSetId", newJString(notificationSetId))
  add(query_578900, "fields", newJString(fields))
  result = call_578899.call(nil, query_578900, nil, nil, nil)

var androidenterpriseEnterprisesAcknowledgeNotificationSet* = Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578887(
    name: "androidenterpriseEnterprisesAcknowledgeNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/acknowledgeNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578888,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_578889,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCompleteSignup_578901 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesCompleteSignup_578903(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesCompleteSignup_578902(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
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
  ##   completionToken: JString
  ##                  : The Completion token initially returned by GenerateSignupUrl.
  ##   enterpriseToken: JString
  ##                  : The Enterprise token appended to the Callback URL.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("prettyPrint")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "prettyPrint", valid_578905
  var valid_578906 = query.getOrDefault("oauth_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "oauth_token", valid_578906
  var valid_578907 = query.getOrDefault("completionToken")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "completionToken", valid_578907
  var valid_578908 = query.getOrDefault("enterpriseToken")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "enterpriseToken", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("userIp")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "userIp", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_AndroidenterpriseEnterprisesCompleteSignup_578901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_AndroidenterpriseEnterprisesCompleteSignup_578901;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          completionToken: string = ""; enterpriseToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesCompleteSignup
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   completionToken: string
  ##                  : The Completion token initially returned by GenerateSignupUrl.
  ##   enterpriseToken: string
  ##                  : The Enterprise token appended to the Callback URL.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578915 = newJObject()
  add(query_578915, "key", newJString(key))
  add(query_578915, "prettyPrint", newJBool(prettyPrint))
  add(query_578915, "oauth_token", newJString(oauthToken))
  add(query_578915, "completionToken", newJString(completionToken))
  add(query_578915, "enterpriseToken", newJString(enterpriseToken))
  add(query_578915, "alt", newJString(alt))
  add(query_578915, "userIp", newJString(userIp))
  add(query_578915, "quotaUser", newJString(quotaUser))
  add(query_578915, "fields", newJString(fields))
  result = call_578914.call(nil, query_578915, nil, nil, nil)

var androidenterpriseEnterprisesCompleteSignup* = Call_AndroidenterpriseEnterprisesCompleteSignup_578901(
    name: "androidenterpriseEnterprisesCompleteSignup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/completeSignup",
    validator: validate_AndroidenterpriseEnterprisesCompleteSignup_578902,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCompleteSignup_578903,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesEnroll_578916 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesEnroll_578918(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesEnroll_578917(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enrolls an enterprise with the calling EMM.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   token: JString (required)
  ##        : The token provided by the enterprise to register the EMM.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578919 = query.getOrDefault("key")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "key", valid_578919
  var valid_578920 = query.getOrDefault("prettyPrint")
  valid_578920 = validateParameter(valid_578920, JBool, required = false,
                                 default = newJBool(true))
  if valid_578920 != nil:
    section.add "prettyPrint", valid_578920
  var valid_578921 = query.getOrDefault("oauth_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "oauth_token", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("userIp")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "userIp", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  assert query != nil, "query argument is necessary due to required `token` field"
  var valid_578925 = query.getOrDefault("token")
  valid_578925 = validateParameter(valid_578925, JString, required = true,
                                 default = nil)
  if valid_578925 != nil:
    section.add "token", valid_578925
  var valid_578926 = query.getOrDefault("fields")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "fields", valid_578926
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

proc call*(call_578928: Call_AndroidenterpriseEnterprisesEnroll_578916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enrolls an enterprise with the calling EMM.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_AndroidenterpriseEnterprisesEnroll_578916;
          token: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesEnroll
  ## Enrolls an enterprise with the calling EMM.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   token: string (required)
  ##        : The token provided by the enterprise to register the EMM.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578930 = newJObject()
  var body_578931 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "userIp", newJString(userIp))
  add(query_578930, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578931 = body
  add(query_578930, "token", newJString(token))
  add(query_578930, "fields", newJString(fields))
  result = call_578929.call(nil, query_578930, nil, nil, body_578931)

var androidenterpriseEnterprisesEnroll* = Call_AndroidenterpriseEnterprisesEnroll_578916(
    name: "androidenterpriseEnterprisesEnroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/enroll",
    validator: validate_AndroidenterpriseEnterprisesEnroll_578917,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesEnroll_578918,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesPullNotificationSet_578932 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesPullNotificationSet_578934(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesPullNotificationSet_578933(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestMode: JString
  ##              : The request mode for pulling notifications.
  ## Specifying waitForNotifications will cause the request to block and wait until one or more notifications are present, or return an empty notification list if no notifications are present after some time.
  ## Speciying returnImmediately will cause the request to immediately return the pending notifications, or an empty list if no notifications are present.
  ## If omitted, defaults to waitForNotifications.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("requestMode")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("returnImmediately"))
  if valid_578941 != nil:
    section.add "requestMode", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_AndroidenterpriseEnterprisesPullNotificationSet_578932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_AndroidenterpriseEnterprisesPullNotificationSet_578932;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          requestMode: string = "returnImmediately"; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesPullNotificationSet
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   requestMode: string
  ##              : The request mode for pulling notifications.
  ## Specifying waitForNotifications will cause the request to block and wait until one or more notifications are present, or return an empty notification list if no notifications are present after some time.
  ## Speciying returnImmediately will cause the request to immediately return the pending notifications, or an empty list if no notifications are present.
  ## If omitted, defaults to waitForNotifications.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "requestMode", newJString(requestMode))
  add(query_578945, "fields", newJString(fields))
  result = call_578944.call(nil, query_578945, nil, nil, nil)

var androidenterpriseEnterprisesPullNotificationSet* = Call_AndroidenterpriseEnterprisesPullNotificationSet_578932(
    name: "androidenterpriseEnterprisesPullNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/pullNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesPullNotificationSet_578933,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesPullNotificationSet_578934,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGenerateSignupUrl_578946 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesGenerateSignupUrl_578948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesGenerateSignupUrl_578947(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates a sign-up URL.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   callbackUrl: JString
  ##              : The callback URL to which the Admin will be redirected after successfully creating an enterprise. Before redirecting there the system will add a single query parameter to this URL named "enterpriseToken" which will contain an opaque token to be used for the CompleteSignup request.
  ## Beware that this means that the URL will be parsed, the parameter added and then a new URL formatted, i.e. there may be some minor formatting changes and, more importantly, the URL must be well-formed so that it can be parsed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("userIp")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "userIp", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("callbackUrl")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callbackUrl", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_578946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a sign-up URL.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_578946;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          callbackUrl: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesGenerateSignupUrl
  ## Generates a sign-up URL.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   callbackUrl: string
  ##              : The callback URL to which the Admin will be redirected after successfully creating an enterprise. Before redirecting there the system will add a single query parameter to this URL named "enterpriseToken" which will contain an opaque token to be used for the CompleteSignup request.
  ## Beware that this means that the URL will be parsed, the parameter added and then a new URL formatted, i.e. there may be some minor formatting changes and, more importantly, the URL must be well-formed so that it can be parsed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "userIp", newJString(userIp))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(query_578959, "callbackUrl", newJString(callbackUrl))
  add(query_578959, "fields", newJString(fields))
  result = call_578958.call(nil, query_578959, nil, nil, nil)

var androidenterpriseEnterprisesGenerateSignupUrl* = Call_AndroidenterpriseEnterprisesGenerateSignupUrl_578946(
    name: "androidenterpriseEnterprisesGenerateSignupUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/signupUrl",
    validator: validate_AndroidenterpriseEnterprisesGenerateSignupUrl_578947,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGenerateSignupUrl_578948,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGet_578960 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesGet_578962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGet_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the name and domain of an enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_578977 = path.getOrDefault("enterpriseId")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "enterpriseId", valid_578977
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("prettyPrint")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "prettyPrint", valid_578979
  var valid_578980 = query.getOrDefault("oauth_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "oauth_token", valid_578980
  var valid_578981 = query.getOrDefault("alt")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("json"))
  if valid_578981 != nil:
    section.add "alt", valid_578981
  var valid_578982 = query.getOrDefault("userIp")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "userIp", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578985: Call_AndroidenterpriseEnterprisesGet_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the name and domain of an enterprise.
  ## 
  let valid = call_578985.validator(path, query, header, formData, body)
  let scheme = call_578985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578985.url(scheme.get, call_578985.host, call_578985.base,
                         call_578985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578985, url, valid)

proc call*(call_578986: Call_AndroidenterpriseEnterprisesGet_578960;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesGet
  ## Retrieves the name and domain of an enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578987 = newJObject()
  var query_578988 = newJObject()
  add(query_578988, "key", newJString(key))
  add(query_578988, "prettyPrint", newJBool(prettyPrint))
  add(query_578988, "oauth_token", newJString(oauthToken))
  add(query_578988, "alt", newJString(alt))
  add(query_578988, "userIp", newJString(userIp))
  add(query_578988, "quotaUser", newJString(quotaUser))
  add(path_578987, "enterpriseId", newJString(enterpriseId))
  add(query_578988, "fields", newJString(fields))
  result = call_578986.call(path_578987, query_578988, nil, nil, nil)

var androidenterpriseEnterprisesGet* = Call_AndroidenterpriseEnterprisesGet_578960(
    name: "androidenterpriseEnterprisesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}",
    validator: validate_AndroidenterpriseEnterprisesGet_578961,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesGet_578962,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetAccount_578989 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesSetAccount_578991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/account")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSetAccount_578990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_578992 = path.getOrDefault("enterpriseId")
  valid_578992 = validateParameter(valid_578992, JString, required = true,
                                 default = nil)
  if valid_578992 != nil:
    section.add "enterpriseId", valid_578992
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578993 = query.getOrDefault("key")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "key", valid_578993
  var valid_578994 = query.getOrDefault("prettyPrint")
  valid_578994 = validateParameter(valid_578994, JBool, required = false,
                                 default = newJBool(true))
  if valid_578994 != nil:
    section.add "prettyPrint", valid_578994
  var valid_578995 = query.getOrDefault("oauth_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "oauth_token", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("userIp")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "userIp", valid_578997
  var valid_578998 = query.getOrDefault("quotaUser")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "quotaUser", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
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

proc call*(call_579001: Call_AndroidenterpriseEnterprisesSetAccount_578989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  let valid = call_579001.validator(path, query, header, formData, body)
  let scheme = call_579001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579001.url(scheme.get, call_579001.host, call_579001.base,
                         call_579001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579001, url, valid)

proc call*(call_579002: Call_AndroidenterpriseEnterprisesSetAccount_578989;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesSetAccount
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579003 = newJObject()
  var query_579004 = newJObject()
  var body_579005 = newJObject()
  add(query_579004, "key", newJString(key))
  add(query_579004, "prettyPrint", newJBool(prettyPrint))
  add(query_579004, "oauth_token", newJString(oauthToken))
  add(query_579004, "alt", newJString(alt))
  add(query_579004, "userIp", newJString(userIp))
  add(query_579004, "quotaUser", newJString(quotaUser))
  add(path_579003, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579005 = body
  add(query_579004, "fields", newJString(fields))
  result = call_579002.call(path_579003, query_579004, nil, nil, body_579005)

var androidenterpriseEnterprisesSetAccount* = Call_AndroidenterpriseEnterprisesSetAccount_578989(
    name: "androidenterpriseEnterprisesSetAccount", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/account",
    validator: validate_AndroidenterpriseEnterprisesSetAccount_578990,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetAccount_578991,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCreateWebToken_579006 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesCreateWebToken_579008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/createWebToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesCreateWebToken_579007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579009 = path.getOrDefault("enterpriseId")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "enterpriseId", valid_579009
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("userIp")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "userIp", valid_579014
  var valid_579015 = query.getOrDefault("quotaUser")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "quotaUser", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
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

proc call*(call_579018: Call_AndroidenterpriseEnterprisesCreateWebToken_579006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_AndroidenterpriseEnterprisesCreateWebToken_579006;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesCreateWebToken
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  var body_579022 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(path_579020, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579022 = body
  add(query_579021, "fields", newJString(fields))
  result = call_579019.call(path_579020, query_579021, nil, nil, body_579022)

var androidenterpriseEnterprisesCreateWebToken* = Call_AndroidenterpriseEnterprisesCreateWebToken_579006(
    name: "androidenterpriseEnterprisesCreateWebToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/createWebToken",
    validator: validate_AndroidenterpriseEnterprisesCreateWebToken_579007,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCreateWebToken_579008,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesList_579023 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseGrouplicensesList_579025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicensesList_579024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579026 = path.getOrDefault("enterpriseId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "enterpriseId", valid_579026
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("userIp")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userIp", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579034: Call_AndroidenterpriseGrouplicensesList_579023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  let valid = call_579034.validator(path, query, header, formData, body)
  let scheme = call_579034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579034.url(scheme.get, call_579034.host, call_579034.base,
                         call_579034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579034, url, valid)

proc call*(call_579035: Call_AndroidenterpriseGrouplicensesList_579023;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseGrouplicensesList
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579036 = newJObject()
  var query_579037 = newJObject()
  add(query_579037, "key", newJString(key))
  add(query_579037, "prettyPrint", newJBool(prettyPrint))
  add(query_579037, "oauth_token", newJString(oauthToken))
  add(query_579037, "alt", newJString(alt))
  add(query_579037, "userIp", newJString(userIp))
  add(query_579037, "quotaUser", newJString(quotaUser))
  add(path_579036, "enterpriseId", newJString(enterpriseId))
  add(query_579037, "fields", newJString(fields))
  result = call_579035.call(path_579036, query_579037, nil, nil, nil)

var androidenterpriseGrouplicensesList* = Call_AndroidenterpriseGrouplicensesList_579023(
    name: "androidenterpriseGrouplicensesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses",
    validator: validate_AndroidenterpriseGrouplicensesList_579024,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesList_579025,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesGet_579038 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseGrouplicensesGet_579040(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "groupLicenseId" in path, "`groupLicenseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses/"),
               (kind: VariableSegment, value: "groupLicenseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicensesGet_579039(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   groupLicenseId: JString (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579041 = path.getOrDefault("enterpriseId")
  valid_579041 = validateParameter(valid_579041, JString, required = true,
                                 default = nil)
  if valid_579041 != nil:
    section.add "enterpriseId", valid_579041
  var valid_579042 = path.getOrDefault("groupLicenseId")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "groupLicenseId", valid_579042
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("userIp")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "userIp", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579050: Call_AndroidenterpriseGrouplicensesGet_579038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_AndroidenterpriseGrouplicensesGet_579038;
          enterpriseId: string; groupLicenseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseGrouplicensesGet
  ## Retrieves details of an enterprise's group license for a product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   groupLicenseId: string (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "userIp", newJString(userIp))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(path_579052, "enterpriseId", newJString(enterpriseId))
  add(path_579052, "groupLicenseId", newJString(groupLicenseId))
  add(query_579053, "fields", newJString(fields))
  result = call_579051.call(path_579052, query_579053, nil, nil, nil)

var androidenterpriseGrouplicensesGet* = Call_AndroidenterpriseGrouplicensesGet_579038(
    name: "androidenterpriseGrouplicensesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}",
    validator: validate_AndroidenterpriseGrouplicensesGet_579039,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesGet_579040,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicenseusersList_579054 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseGrouplicenseusersList_579056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "groupLicenseId" in path, "`groupLicenseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses/"),
               (kind: VariableSegment, value: "groupLicenseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicenseusersList_579055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   groupLicenseId: JString (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579057 = path.getOrDefault("enterpriseId")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "enterpriseId", valid_579057
  var valid_579058 = path.getOrDefault("groupLicenseId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "groupLicenseId", valid_579058
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("userIp")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "userIp", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_AndroidenterpriseGrouplicenseusersList_579054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_AndroidenterpriseGrouplicenseusersList_579054;
          enterpriseId: string; groupLicenseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseGrouplicenseusersList
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   groupLicenseId: string (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579068 = newJObject()
  var query_579069 = newJObject()
  add(query_579069, "key", newJString(key))
  add(query_579069, "prettyPrint", newJBool(prettyPrint))
  add(query_579069, "oauth_token", newJString(oauthToken))
  add(query_579069, "alt", newJString(alt))
  add(query_579069, "userIp", newJString(userIp))
  add(query_579069, "quotaUser", newJString(quotaUser))
  add(path_579068, "enterpriseId", newJString(enterpriseId))
  add(path_579068, "groupLicenseId", newJString(groupLicenseId))
  add(query_579069, "fields", newJString(fields))
  result = call_579067.call(path_579068, query_579069, nil, nil, nil)

var androidenterpriseGrouplicenseusersList* = Call_AndroidenterpriseGrouplicenseusersList_579054(
    name: "androidenterpriseGrouplicenseusersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}/users",
    validator: validate_AndroidenterpriseGrouplicenseusersList_579055,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseGrouplicenseusersList_579056,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsList_579070 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsList_579072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsList_579071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579073 = path.getOrDefault("enterpriseId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "enterpriseId", valid_579073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   approved: JBool
  ##           : Specifies whether to search among all products (false) or among only products that have been approved (true). Only "true" is supported, and should be specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   query: JString
  ##        : The search query as typed in the Google Play store search box. If omitted, all approved apps will be returned (using the pagination parameters), including apps that are not available in the store (e.g. unpublished apps).
  ##   token: JString
  ##        : A pagination token is contained in a request's response when there are more products. The token can be used in a subsequent request to obtain more products, and so forth. This parameter cannot be used in the initial request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de"). Results are returned in the language best matching the preferred language.
  ##   maxResults: JInt
  ##             : Specifies the maximum number of products that can be returned per request. If not specified, uses a default value of 100, which is also the maximum retrievable within a single response.
  section = newJObject()
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("approved")
  valid_579077 = validateParameter(valid_579077, JBool, required = false, default = nil)
  if valid_579077 != nil:
    section.add "approved", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("userIp")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "userIp", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("query")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "query", valid_579081
  var valid_579082 = query.getOrDefault("token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "token", valid_579082
  var valid_579083 = query.getOrDefault("fields")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "fields", valid_579083
  var valid_579084 = query.getOrDefault("language")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "language", valid_579084
  var valid_579085 = query.getOrDefault("maxResults")
  valid_579085 = validateParameter(valid_579085, JInt, required = false, default = nil)
  if valid_579085 != nil:
    section.add "maxResults", valid_579085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579086: Call_AndroidenterpriseProductsList_579070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_AndroidenterpriseProductsList_579070;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; approved: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; query: string = "";
          token: string = ""; fields: string = ""; language: string = "";
          maxResults: int = 0): Recallable =
  ## androidenterpriseProductsList
  ## Finds approved products that match a query, or all approved products if there is no query.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   approved: bool
  ##           : Specifies whether to search among all products (false) or among only products that have been approved (true). Only "true" is supported, and should be specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   query: string
  ##        : The search query as typed in the Google Play store search box. If omitted, all approved apps will be returned (using the pagination parameters), including apps that are not available in the store (e.g. unpublished apps).
  ##   token: string
  ##        : A pagination token is contained in a request's response when there are more products. The token can be used in a subsequent request to obtain more products, and so forth. This parameter cannot be used in the initial request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de"). Results are returned in the language best matching the preferred language.
  ##   maxResults: int
  ##             : Specifies the maximum number of products that can be returned per request. If not specified, uses a default value of 100, which is also the maximum retrievable within a single response.
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(query_579089, "approved", newJBool(approved))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "userIp", newJString(userIp))
  add(query_579089, "quotaUser", newJString(quotaUser))
  add(path_579088, "enterpriseId", newJString(enterpriseId))
  add(query_579089, "query", newJString(query))
  add(query_579089, "token", newJString(token))
  add(query_579089, "fields", newJString(fields))
  add(query_579089, "language", newJString(language))
  add(query_579089, "maxResults", newJInt(maxResults))
  result = call_579087.call(path_579088, query_579089, nil, nil, nil)

var androidenterpriseProductsList* = Call_AndroidenterpriseProductsList_579070(
    name: "androidenterpriseProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products",
    validator: validate_AndroidenterpriseProductsList_579071,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsList_579072,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGet_579090 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsGet_579092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGet_579091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product, e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579093 = path.getOrDefault("enterpriseId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "enterpriseId", valid_579093
  var valid_579094 = path.getOrDefault("productId")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "productId", valid_579094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  section = newJObject()
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("userIp")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "userIp", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("fields")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "fields", valid_579101
  var valid_579102 = query.getOrDefault("language")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "language", valid_579102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579103: Call_AndroidenterpriseProductsGet_579090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_AndroidenterpriseProductsGet_579090;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          language: string = ""): Recallable =
  ## androidenterpriseProductsGet
  ## Retrieves details of a product for display to an enterprise admin.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product, e.g. "app:com.google.android.gm".
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "userIp", newJString(userIp))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "enterpriseId", newJString(enterpriseId))
  add(query_579106, "fields", newJString(fields))
  add(path_579105, "productId", newJString(productId))
  add(query_579106, "language", newJString(language))
  result = call_579104.call(path_579105, query_579106, nil, nil, nil)

var androidenterpriseProductsGet* = Call_AndroidenterpriseProductsGet_579090(
    name: "androidenterpriseProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}",
    validator: validate_AndroidenterpriseProductsGet_579091,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsGet_579092,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetAppRestrictionsSchema_579107 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsGetAppRestrictionsSchema_579109(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/appRestrictionsSchema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGetAppRestrictionsSchema_579108(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579110 = path.getOrDefault("enterpriseId")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "enterpriseId", valid_579110
  var valid_579111 = path.getOrDefault("productId")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "productId", valid_579111
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  section = newJObject()
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("userIp")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "userIp", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("fields")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "fields", valid_579118
  var valid_579119 = query.getOrDefault("language")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "language", valid_579119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579120: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_579107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  let valid = call_579120.validator(path, query, header, formData, body)
  let scheme = call_579120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579120.url(scheme.get, call_579120.host, call_579120.base,
                         call_579120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579120, url, valid)

proc call*(call_579121: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_579107;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          language: string = ""): Recallable =
  ## androidenterpriseProductsGetAppRestrictionsSchema
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  var path_579122 = newJObject()
  var query_579123 = newJObject()
  add(query_579123, "key", newJString(key))
  add(query_579123, "prettyPrint", newJBool(prettyPrint))
  add(query_579123, "oauth_token", newJString(oauthToken))
  add(query_579123, "alt", newJString(alt))
  add(query_579123, "userIp", newJString(userIp))
  add(query_579123, "quotaUser", newJString(quotaUser))
  add(path_579122, "enterpriseId", newJString(enterpriseId))
  add(query_579123, "fields", newJString(fields))
  add(path_579122, "productId", newJString(productId))
  add(query_579123, "language", newJString(language))
  result = call_579121.call(path_579122, query_579123, nil, nil, nil)

var androidenterpriseProductsGetAppRestrictionsSchema* = Call_AndroidenterpriseProductsGetAppRestrictionsSchema_579107(
    name: "androidenterpriseProductsGetAppRestrictionsSchema",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/appRestrictionsSchema",
    validator: validate_AndroidenterpriseProductsGetAppRestrictionsSchema_579108,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetAppRestrictionsSchema_579109,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsApprove_579124 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsApprove_579126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/approve")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsApprove_579125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579127 = path.getOrDefault("enterpriseId")
  valid_579127 = validateParameter(valid_579127, JString, required = true,
                                 default = nil)
  if valid_579127 != nil:
    section.add "enterpriseId", valid_579127
  var valid_579128 = path.getOrDefault("productId")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "productId", valid_579128
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579129 = query.getOrDefault("key")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "key", valid_579129
  var valid_579130 = query.getOrDefault("prettyPrint")
  valid_579130 = validateParameter(valid_579130, JBool, required = false,
                                 default = newJBool(true))
  if valid_579130 != nil:
    section.add "prettyPrint", valid_579130
  var valid_579131 = query.getOrDefault("oauth_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "oauth_token", valid_579131
  var valid_579132 = query.getOrDefault("alt")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = newJString("json"))
  if valid_579132 != nil:
    section.add "alt", valid_579132
  var valid_579133 = query.getOrDefault("userIp")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "userIp", valid_579133
  var valid_579134 = query.getOrDefault("quotaUser")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "quotaUser", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
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

proc call*(call_579137: Call_AndroidenterpriseProductsApprove_579124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  let valid = call_579137.validator(path, query, header, formData, body)
  let scheme = call_579137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579137.url(scheme.get, call_579137.host, call_579137.base,
                         call_579137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579137, url, valid)

proc call*(call_579138: Call_AndroidenterpriseProductsApprove_579124;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseProductsApprove
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product.
  var path_579139 = newJObject()
  var query_579140 = newJObject()
  var body_579141 = newJObject()
  add(query_579140, "key", newJString(key))
  add(query_579140, "prettyPrint", newJBool(prettyPrint))
  add(query_579140, "oauth_token", newJString(oauthToken))
  add(query_579140, "alt", newJString(alt))
  add(query_579140, "userIp", newJString(userIp))
  add(query_579140, "quotaUser", newJString(quotaUser))
  add(path_579139, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579141 = body
  add(query_579140, "fields", newJString(fields))
  add(path_579139, "productId", newJString(productId))
  result = call_579138.call(path_579139, query_579140, nil, nil, body_579141)

var androidenterpriseProductsApprove* = Call_AndroidenterpriseProductsApprove_579124(
    name: "androidenterpriseProductsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/approve",
    validator: validate_AndroidenterpriseProductsApprove_579125,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsApprove_579126,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGenerateApprovalUrl_579142 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsGenerateApprovalUrl_579144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/generateApprovalUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGenerateApprovalUrl_579143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579145 = path.getOrDefault("enterpriseId")
  valid_579145 = validateParameter(valid_579145, JString, required = true,
                                 default = nil)
  if valid_579145 != nil:
    section.add "enterpriseId", valid_579145
  var valid_579146 = path.getOrDefault("productId")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "productId", valid_579146
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   languageCode: JString
  ##               : The BCP 47 language code used for permission names and descriptions in the returned iframe, for instance "en-US".
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("alt")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("json"))
  if valid_579150 != nil:
    section.add "alt", valid_579150
  var valid_579151 = query.getOrDefault("userIp")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "userIp", valid_579151
  var valid_579152 = query.getOrDefault("quotaUser")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "quotaUser", valid_579152
  var valid_579153 = query.getOrDefault("languageCode")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "languageCode", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_AndroidenterpriseProductsGenerateApprovalUrl_579142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_AndroidenterpriseProductsGenerateApprovalUrl_579142;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; languageCode: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseProductsGenerateApprovalUrl
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   languageCode: string
  ##               : The BCP 47 language code used for permission names and descriptions in the returned iframe, for instance "en-US".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product.
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(path_579157, "enterpriseId", newJString(enterpriseId))
  add(query_579158, "languageCode", newJString(languageCode))
  add(query_579158, "fields", newJString(fields))
  add(path_579157, "productId", newJString(productId))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var androidenterpriseProductsGenerateApprovalUrl* = Call_AndroidenterpriseProductsGenerateApprovalUrl_579142(
    name: "androidenterpriseProductsGenerateApprovalUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/generateApprovalUrl",
    validator: validate_AndroidenterpriseProductsGenerateApprovalUrl_579143,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGenerateApprovalUrl_579144,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationssettingsList_579159 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationssettingsList_579161(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/managedConfigurationsSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationssettingsList_579160(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product for which the managed configurations settings applies to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579162 = path.getOrDefault("enterpriseId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "enterpriseId", valid_579162
  var valid_579163 = path.getOrDefault("productId")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "productId", valid_579163
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("userIp")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "userIp", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("fields")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "fields", valid_579170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579171: Call_AndroidenterpriseManagedconfigurationssettingsList_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  let valid = call_579171.validator(path, query, header, formData, body)
  let scheme = call_579171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579171.url(scheme.get, call_579171.host, call_579171.base,
                         call_579171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579171, url, valid)

proc call*(call_579172: Call_AndroidenterpriseManagedconfigurationssettingsList_579159;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationssettingsList
  ## Lists all the managed configurations settings for the specified app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product for which the managed configurations settings applies to.
  var path_579173 = newJObject()
  var query_579174 = newJObject()
  add(query_579174, "key", newJString(key))
  add(query_579174, "prettyPrint", newJBool(prettyPrint))
  add(query_579174, "oauth_token", newJString(oauthToken))
  add(query_579174, "alt", newJString(alt))
  add(query_579174, "userIp", newJString(userIp))
  add(query_579174, "quotaUser", newJString(quotaUser))
  add(path_579173, "enterpriseId", newJString(enterpriseId))
  add(query_579174, "fields", newJString(fields))
  add(path_579173, "productId", newJString(productId))
  result = call_579172.call(path_579173, query_579174, nil, nil, nil)

var androidenterpriseManagedconfigurationssettingsList* = Call_AndroidenterpriseManagedconfigurationssettingsList_579159(
    name: "androidenterpriseManagedconfigurationssettingsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/managedConfigurationsSettings",
    validator: validate_AndroidenterpriseManagedconfigurationssettingsList_579160,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationssettingsList_579161,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetPermissions_579175 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsGetPermissions_579177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGetPermissions_579176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the Android app permissions required by this app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579178 = path.getOrDefault("enterpriseId")
  valid_579178 = validateParameter(valid_579178, JString, required = true,
                                 default = nil)
  if valid_579178 != nil:
    section.add "enterpriseId", valid_579178
  var valid_579179 = path.getOrDefault("productId")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "productId", valid_579179
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579180 = query.getOrDefault("key")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "key", valid_579180
  var valid_579181 = query.getOrDefault("prettyPrint")
  valid_579181 = validateParameter(valid_579181, JBool, required = false,
                                 default = newJBool(true))
  if valid_579181 != nil:
    section.add "prettyPrint", valid_579181
  var valid_579182 = query.getOrDefault("oauth_token")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "oauth_token", valid_579182
  var valid_579183 = query.getOrDefault("alt")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = newJString("json"))
  if valid_579183 != nil:
    section.add "alt", valid_579183
  var valid_579184 = query.getOrDefault("userIp")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "userIp", valid_579184
  var valid_579185 = query.getOrDefault("quotaUser")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "quotaUser", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579187: Call_AndroidenterpriseProductsGetPermissions_579175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Android app permissions required by this app.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_AndroidenterpriseProductsGetPermissions_579175;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseProductsGetPermissions
  ## Retrieves the Android app permissions required by this app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product.
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "userIp", newJString(userIp))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "enterpriseId", newJString(enterpriseId))
  add(query_579190, "fields", newJString(fields))
  add(path_579189, "productId", newJString(productId))
  result = call_579188.call(path_579189, query_579190, nil, nil, nil)

var androidenterpriseProductsGetPermissions* = Call_AndroidenterpriseProductsGetPermissions_579175(
    name: "androidenterpriseProductsGetPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/permissions",
    validator: validate_AndroidenterpriseProductsGetPermissions_579176,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetPermissions_579177,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsUnapprove_579191 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseProductsUnapprove_579193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/unapprove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsUnapprove_579192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579194 = path.getOrDefault("enterpriseId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "enterpriseId", valid_579194
  var valid_579195 = path.getOrDefault("productId")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = nil)
  if valid_579195 != nil:
    section.add "productId", valid_579195
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("alt")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("json"))
  if valid_579199 != nil:
    section.add "alt", valid_579199
  var valid_579200 = query.getOrDefault("userIp")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "userIp", valid_579200
  var valid_579201 = query.getOrDefault("quotaUser")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "quotaUser", valid_579201
  var valid_579202 = query.getOrDefault("fields")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "fields", valid_579202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579203: Call_AndroidenterpriseProductsUnapprove_579191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  let valid = call_579203.validator(path, query, header, formData, body)
  let scheme = call_579203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579203.url(scheme.get, call_579203.host, call_579203.base,
                         call_579203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579203, url, valid)

proc call*(call_579204: Call_AndroidenterpriseProductsUnapprove_579191;
          enterpriseId: string; productId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseProductsUnapprove
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   productId: string (required)
  ##            : The ID of the product.
  var path_579205 = newJObject()
  var query_579206 = newJObject()
  add(query_579206, "key", newJString(key))
  add(query_579206, "prettyPrint", newJBool(prettyPrint))
  add(query_579206, "oauth_token", newJString(oauthToken))
  add(query_579206, "alt", newJString(alt))
  add(query_579206, "userIp", newJString(userIp))
  add(query_579206, "quotaUser", newJString(quotaUser))
  add(path_579205, "enterpriseId", newJString(enterpriseId))
  add(query_579206, "fields", newJString(fields))
  add(path_579205, "productId", newJString(productId))
  result = call_579204.call(path_579205, query_579206, nil, nil, nil)

var androidenterpriseProductsUnapprove* = Call_AndroidenterpriseProductsUnapprove_579191(
    name: "androidenterpriseProductsUnapprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/unapprove",
    validator: validate_AndroidenterpriseProductsUnapprove_579192,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsUnapprove_579193,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSendTestPushNotification_579207 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesSendTestPushNotification_579209(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/sendTestPushNotification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSendTestPushNotification_579208(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579210 = path.getOrDefault("enterpriseId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "enterpriseId", valid_579210
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("userIp")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "userIp", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("fields")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fields", valid_579217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579218: Call_AndroidenterpriseEnterprisesSendTestPushNotification_579207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_AndroidenterpriseEnterprisesSendTestPushNotification_579207;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesSendTestPushNotification
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "userIp", newJString(userIp))
  add(query_579221, "quotaUser", newJString(quotaUser))
  add(path_579220, "enterpriseId", newJString(enterpriseId))
  add(query_579221, "fields", newJString(fields))
  result = call_579219.call(path_579220, query_579221, nil, nil, nil)

var androidenterpriseEnterprisesSendTestPushNotification* = Call_AndroidenterpriseEnterprisesSendTestPushNotification_579207(
    name: "androidenterpriseEnterprisesSendTestPushNotification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/sendTestPushNotification",
    validator: validate_AndroidenterpriseEnterprisesSendTestPushNotification_579208,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSendTestPushNotification_579209,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetServiceAccount_579222 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesGetServiceAccount_579224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGetServiceAccount_579223(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579225 = path.getOrDefault("enterpriseId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "enterpriseId", valid_579225
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   keyType: JString
  ##          : The type of credential to return with the service account. Required.
  section = newJObject()
  var valid_579226 = query.getOrDefault("key")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "key", valid_579226
  var valid_579227 = query.getOrDefault("prettyPrint")
  valid_579227 = validateParameter(valid_579227, JBool, required = false,
                                 default = newJBool(true))
  if valid_579227 != nil:
    section.add "prettyPrint", valid_579227
  var valid_579228 = query.getOrDefault("oauth_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "oauth_token", valid_579228
  var valid_579229 = query.getOrDefault("alt")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = newJString("json"))
  if valid_579229 != nil:
    section.add "alt", valid_579229
  var valid_579230 = query.getOrDefault("userIp")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "userIp", valid_579230
  var valid_579231 = query.getOrDefault("quotaUser")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "quotaUser", valid_579231
  var valid_579232 = query.getOrDefault("fields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "fields", valid_579232
  var valid_579233 = query.getOrDefault("keyType")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("googleCredentials"))
  if valid_579233 != nil:
    section.add "keyType", valid_579233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579234: Call_AndroidenterpriseEnterprisesGetServiceAccount_579222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ## 
  let valid = call_579234.validator(path, query, header, formData, body)
  let scheme = call_579234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579234.url(scheme.get, call_579234.host, call_579234.base,
                         call_579234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579234, url, valid)

proc call*(call_579235: Call_AndroidenterpriseEnterprisesGetServiceAccount_579222;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = "";
          keyType: string = "googleCredentials"): Recallable =
  ## androidenterpriseEnterprisesGetServiceAccount
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   keyType: string
  ##          : The type of credential to return with the service account. Required.
  var path_579236 = newJObject()
  var query_579237 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "userIp", newJString(userIp))
  add(query_579237, "quotaUser", newJString(quotaUser))
  add(path_579236, "enterpriseId", newJString(enterpriseId))
  add(query_579237, "fields", newJString(fields))
  add(query_579237, "keyType", newJString(keyType))
  result = call_579235.call(path_579236, query_579237, nil, nil, nil)

var androidenterpriseEnterprisesGetServiceAccount* = Call_AndroidenterpriseEnterprisesGetServiceAccount_579222(
    name: "androidenterpriseEnterprisesGetServiceAccount",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccount",
    validator: validate_AndroidenterpriseEnterprisesGetServiceAccount_579223,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetServiceAccount_579224,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysInsert_579253 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseServiceaccountkeysInsert_579255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysInsert_579254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579256 = path.getOrDefault("enterpriseId")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "enterpriseId", valid_579256
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579257 = query.getOrDefault("key")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "key", valid_579257
  var valid_579258 = query.getOrDefault("prettyPrint")
  valid_579258 = validateParameter(valid_579258, JBool, required = false,
                                 default = newJBool(true))
  if valid_579258 != nil:
    section.add "prettyPrint", valid_579258
  var valid_579259 = query.getOrDefault("oauth_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "oauth_token", valid_579259
  var valid_579260 = query.getOrDefault("alt")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("json"))
  if valid_579260 != nil:
    section.add "alt", valid_579260
  var valid_579261 = query.getOrDefault("userIp")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "userIp", valid_579261
  var valid_579262 = query.getOrDefault("quotaUser")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "quotaUser", valid_579262
  var valid_579263 = query.getOrDefault("fields")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "fields", valid_579263
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

proc call*(call_579265: Call_AndroidenterpriseServiceaccountkeysInsert_579253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  let valid = call_579265.validator(path, query, header, formData, body)
  let scheme = call_579265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579265.url(scheme.get, call_579265.host, call_579265.base,
                         call_579265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579265, url, valid)

proc call*(call_579266: Call_AndroidenterpriseServiceaccountkeysInsert_579253;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseServiceaccountkeysInsert
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579267 = newJObject()
  var query_579268 = newJObject()
  var body_579269 = newJObject()
  add(query_579268, "key", newJString(key))
  add(query_579268, "prettyPrint", newJBool(prettyPrint))
  add(query_579268, "oauth_token", newJString(oauthToken))
  add(query_579268, "alt", newJString(alt))
  add(query_579268, "userIp", newJString(userIp))
  add(query_579268, "quotaUser", newJString(quotaUser))
  add(path_579267, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579269 = body
  add(query_579268, "fields", newJString(fields))
  result = call_579266.call(path_579267, query_579268, nil, nil, body_579269)

var androidenterpriseServiceaccountkeysInsert* = Call_AndroidenterpriseServiceaccountkeysInsert_579253(
    name: "androidenterpriseServiceaccountkeysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysInsert_579254,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysInsert_579255,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysList_579238 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseServiceaccountkeysList_579240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysList_579239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579241 = path.getOrDefault("enterpriseId")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "enterpriseId", valid_579241
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579242 = query.getOrDefault("key")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "key", valid_579242
  var valid_579243 = query.getOrDefault("prettyPrint")
  valid_579243 = validateParameter(valid_579243, JBool, required = false,
                                 default = newJBool(true))
  if valid_579243 != nil:
    section.add "prettyPrint", valid_579243
  var valid_579244 = query.getOrDefault("oauth_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "oauth_token", valid_579244
  var valid_579245 = query.getOrDefault("alt")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("json"))
  if valid_579245 != nil:
    section.add "alt", valid_579245
  var valid_579246 = query.getOrDefault("userIp")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "userIp", valid_579246
  var valid_579247 = query.getOrDefault("quotaUser")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "quotaUser", valid_579247
  var valid_579248 = query.getOrDefault("fields")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "fields", valid_579248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579249: Call_AndroidenterpriseServiceaccountkeysList_579238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_AndroidenterpriseServiceaccountkeysList_579238;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseServiceaccountkeysList
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579251 = newJObject()
  var query_579252 = newJObject()
  add(query_579252, "key", newJString(key))
  add(query_579252, "prettyPrint", newJBool(prettyPrint))
  add(query_579252, "oauth_token", newJString(oauthToken))
  add(query_579252, "alt", newJString(alt))
  add(query_579252, "userIp", newJString(userIp))
  add(query_579252, "quotaUser", newJString(quotaUser))
  add(path_579251, "enterpriseId", newJString(enterpriseId))
  add(query_579252, "fields", newJString(fields))
  result = call_579250.call(path_579251, query_579252, nil, nil, nil)

var androidenterpriseServiceaccountkeysList* = Call_AndroidenterpriseServiceaccountkeysList_579238(
    name: "androidenterpriseServiceaccountkeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysList_579239,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysList_579240,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysDelete_579270 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseServiceaccountkeysDelete_579272(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "keyId" in path, "`keyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys/"),
               (kind: VariableSegment, value: "keyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysDelete_579271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyId: JString (required)
  ##        : The ID of the key.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyId` field"
  var valid_579273 = path.getOrDefault("keyId")
  valid_579273 = validateParameter(valid_579273, JString, required = true,
                                 default = nil)
  if valid_579273 != nil:
    section.add "keyId", valid_579273
  var valid_579274 = path.getOrDefault("enterpriseId")
  valid_579274 = validateParameter(valid_579274, JString, required = true,
                                 default = nil)
  if valid_579274 != nil:
    section.add "enterpriseId", valid_579274
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579275 = query.getOrDefault("key")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "key", valid_579275
  var valid_579276 = query.getOrDefault("prettyPrint")
  valid_579276 = validateParameter(valid_579276, JBool, required = false,
                                 default = newJBool(true))
  if valid_579276 != nil:
    section.add "prettyPrint", valid_579276
  var valid_579277 = query.getOrDefault("oauth_token")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "oauth_token", valid_579277
  var valid_579278 = query.getOrDefault("alt")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = newJString("json"))
  if valid_579278 != nil:
    section.add "alt", valid_579278
  var valid_579279 = query.getOrDefault("userIp")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "userIp", valid_579279
  var valid_579280 = query.getOrDefault("quotaUser")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "quotaUser", valid_579280
  var valid_579281 = query.getOrDefault("fields")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "fields", valid_579281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579282: Call_AndroidenterpriseServiceaccountkeysDelete_579270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_579282.validator(path, query, header, formData, body)
  let scheme = call_579282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579282.url(scheme.get, call_579282.host, call_579282.base,
                         call_579282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579282, url, valid)

proc call*(call_579283: Call_AndroidenterpriseServiceaccountkeysDelete_579270;
          keyId: string; enterpriseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseServiceaccountkeysDelete
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   keyId: string (required)
  ##        : The ID of the key.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579284 = newJObject()
  var query_579285 = newJObject()
  add(query_579285, "key", newJString(key))
  add(query_579285, "prettyPrint", newJBool(prettyPrint))
  add(query_579285, "oauth_token", newJString(oauthToken))
  add(path_579284, "keyId", newJString(keyId))
  add(query_579285, "alt", newJString(alt))
  add(query_579285, "userIp", newJString(userIp))
  add(query_579285, "quotaUser", newJString(quotaUser))
  add(path_579284, "enterpriseId", newJString(enterpriseId))
  add(query_579285, "fields", newJString(fields))
  result = call_579283.call(path_579284, query_579285, nil, nil, nil)

var androidenterpriseServiceaccountkeysDelete* = Call_AndroidenterpriseServiceaccountkeysDelete_579270(
    name: "androidenterpriseServiceaccountkeysDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys/{keyId}",
    validator: validate_AndroidenterpriseServiceaccountkeysDelete_579271,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysDelete_579272,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetStoreLayout_579301 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesSetStoreLayout_579303(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSetStoreLayout_579302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579304 = path.getOrDefault("enterpriseId")
  valid_579304 = validateParameter(valid_579304, JString, required = true,
                                 default = nil)
  if valid_579304 != nil:
    section.add "enterpriseId", valid_579304
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579305 = query.getOrDefault("key")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "key", valid_579305
  var valid_579306 = query.getOrDefault("prettyPrint")
  valid_579306 = validateParameter(valid_579306, JBool, required = false,
                                 default = newJBool(true))
  if valid_579306 != nil:
    section.add "prettyPrint", valid_579306
  var valid_579307 = query.getOrDefault("oauth_token")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "oauth_token", valid_579307
  var valid_579308 = query.getOrDefault("alt")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = newJString("json"))
  if valid_579308 != nil:
    section.add "alt", valid_579308
  var valid_579309 = query.getOrDefault("userIp")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "userIp", valid_579309
  var valid_579310 = query.getOrDefault("quotaUser")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "quotaUser", valid_579310
  var valid_579311 = query.getOrDefault("fields")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "fields", valid_579311
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

proc call*(call_579313: Call_AndroidenterpriseEnterprisesSetStoreLayout_579301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  let valid = call_579313.validator(path, query, header, formData, body)
  let scheme = call_579313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579313.url(scheme.get, call_579313.host, call_579313.base,
                         call_579313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579313, url, valid)

proc call*(call_579314: Call_AndroidenterpriseEnterprisesSetStoreLayout_579301;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesSetStoreLayout
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579315 = newJObject()
  var query_579316 = newJObject()
  var body_579317 = newJObject()
  add(query_579316, "key", newJString(key))
  add(query_579316, "prettyPrint", newJBool(prettyPrint))
  add(query_579316, "oauth_token", newJString(oauthToken))
  add(query_579316, "alt", newJString(alt))
  add(query_579316, "userIp", newJString(userIp))
  add(query_579316, "quotaUser", newJString(quotaUser))
  add(path_579315, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579317 = body
  add(query_579316, "fields", newJString(fields))
  result = call_579314.call(path_579315, query_579316, nil, nil, body_579317)

var androidenterpriseEnterprisesSetStoreLayout* = Call_AndroidenterpriseEnterprisesSetStoreLayout_579301(
    name: "androidenterpriseEnterprisesSetStoreLayout", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesSetStoreLayout_579302,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetStoreLayout_579303,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetStoreLayout_579286 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesGetStoreLayout_579288(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGetStoreLayout_579287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579289 = path.getOrDefault("enterpriseId")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "enterpriseId", valid_579289
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579290 = query.getOrDefault("key")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "key", valid_579290
  var valid_579291 = query.getOrDefault("prettyPrint")
  valid_579291 = validateParameter(valid_579291, JBool, required = false,
                                 default = newJBool(true))
  if valid_579291 != nil:
    section.add "prettyPrint", valid_579291
  var valid_579292 = query.getOrDefault("oauth_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "oauth_token", valid_579292
  var valid_579293 = query.getOrDefault("alt")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = newJString("json"))
  if valid_579293 != nil:
    section.add "alt", valid_579293
  var valid_579294 = query.getOrDefault("userIp")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "userIp", valid_579294
  var valid_579295 = query.getOrDefault("quotaUser")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "quotaUser", valid_579295
  var valid_579296 = query.getOrDefault("fields")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "fields", valid_579296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579297: Call_AndroidenterpriseEnterprisesGetStoreLayout_579286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  let valid = call_579297.validator(path, query, header, formData, body)
  let scheme = call_579297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579297.url(scheme.get, call_579297.host, call_579297.base,
                         call_579297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579297, url, valid)

proc call*(call_579298: Call_AndroidenterpriseEnterprisesGetStoreLayout_579286;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesGetStoreLayout
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579299 = newJObject()
  var query_579300 = newJObject()
  add(query_579300, "key", newJString(key))
  add(query_579300, "prettyPrint", newJBool(prettyPrint))
  add(query_579300, "oauth_token", newJString(oauthToken))
  add(query_579300, "alt", newJString(alt))
  add(query_579300, "userIp", newJString(userIp))
  add(query_579300, "quotaUser", newJString(quotaUser))
  add(path_579299, "enterpriseId", newJString(enterpriseId))
  add(query_579300, "fields", newJString(fields))
  result = call_579298.call(path_579299, query_579300, nil, nil, nil)

var androidenterpriseEnterprisesGetStoreLayout* = Call_AndroidenterpriseEnterprisesGetStoreLayout_579286(
    name: "androidenterpriseEnterprisesGetStoreLayout", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesGetStoreLayout_579287,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetStoreLayout_579288,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesInsert_579333 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesInsert_579335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesInsert_579334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579336 = path.getOrDefault("enterpriseId")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "enterpriseId", valid_579336
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579337 = query.getOrDefault("key")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "key", valid_579337
  var valid_579338 = query.getOrDefault("prettyPrint")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(true))
  if valid_579338 != nil:
    section.add "prettyPrint", valid_579338
  var valid_579339 = query.getOrDefault("oauth_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "oauth_token", valid_579339
  var valid_579340 = query.getOrDefault("alt")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = newJString("json"))
  if valid_579340 != nil:
    section.add "alt", valid_579340
  var valid_579341 = query.getOrDefault("userIp")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "userIp", valid_579341
  var valid_579342 = query.getOrDefault("quotaUser")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "quotaUser", valid_579342
  var valid_579343 = query.getOrDefault("fields")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "fields", valid_579343
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

proc call*(call_579345: Call_AndroidenterpriseStorelayoutpagesInsert_579333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new store page.
  ## 
  let valid = call_579345.validator(path, query, header, formData, body)
  let scheme = call_579345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579345.url(scheme.get, call_579345.host, call_579345.base,
                         call_579345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579345, url, valid)

proc call*(call_579346: Call_AndroidenterpriseStorelayoutpagesInsert_579333;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesInsert
  ## Inserts a new store page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579347 = newJObject()
  var query_579348 = newJObject()
  var body_579349 = newJObject()
  add(query_579348, "key", newJString(key))
  add(query_579348, "prettyPrint", newJBool(prettyPrint))
  add(query_579348, "oauth_token", newJString(oauthToken))
  add(query_579348, "alt", newJString(alt))
  add(query_579348, "userIp", newJString(userIp))
  add(query_579348, "quotaUser", newJString(quotaUser))
  add(path_579347, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579349 = body
  add(query_579348, "fields", newJString(fields))
  result = call_579346.call(path_579347, query_579348, nil, nil, body_579349)

var androidenterpriseStorelayoutpagesInsert* = Call_AndroidenterpriseStorelayoutpagesInsert_579333(
    name: "androidenterpriseStorelayoutpagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesInsert_579334,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesInsert_579335,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesList_579318 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesList_579320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesList_579319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all pages in the store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579321 = path.getOrDefault("enterpriseId")
  valid_579321 = validateParameter(valid_579321, JString, required = true,
                                 default = nil)
  if valid_579321 != nil:
    section.add "enterpriseId", valid_579321
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579322 = query.getOrDefault("key")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "key", valid_579322
  var valid_579323 = query.getOrDefault("prettyPrint")
  valid_579323 = validateParameter(valid_579323, JBool, required = false,
                                 default = newJBool(true))
  if valid_579323 != nil:
    section.add "prettyPrint", valid_579323
  var valid_579324 = query.getOrDefault("oauth_token")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "oauth_token", valid_579324
  var valid_579325 = query.getOrDefault("alt")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = newJString("json"))
  if valid_579325 != nil:
    section.add "alt", valid_579325
  var valid_579326 = query.getOrDefault("userIp")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "userIp", valid_579326
  var valid_579327 = query.getOrDefault("quotaUser")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "quotaUser", valid_579327
  var valid_579328 = query.getOrDefault("fields")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "fields", valid_579328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579329: Call_AndroidenterpriseStorelayoutpagesList_579318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all pages in the store.
  ## 
  let valid = call_579329.validator(path, query, header, formData, body)
  let scheme = call_579329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579329.url(scheme.get, call_579329.host, call_579329.base,
                         call_579329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579329, url, valid)

proc call*(call_579330: Call_AndroidenterpriseStorelayoutpagesList_579318;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesList
  ## Retrieves the details of all pages in the store.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579331 = newJObject()
  var query_579332 = newJObject()
  add(query_579332, "key", newJString(key))
  add(query_579332, "prettyPrint", newJBool(prettyPrint))
  add(query_579332, "oauth_token", newJString(oauthToken))
  add(query_579332, "alt", newJString(alt))
  add(query_579332, "userIp", newJString(userIp))
  add(query_579332, "quotaUser", newJString(quotaUser))
  add(path_579331, "enterpriseId", newJString(enterpriseId))
  add(query_579332, "fields", newJString(fields))
  result = call_579330.call(path_579331, query_579332, nil, nil, nil)

var androidenterpriseStorelayoutpagesList* = Call_AndroidenterpriseStorelayoutpagesList_579318(
    name: "androidenterpriseStorelayoutpagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesList_579319,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesList_579320,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesUpdate_579366 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesUpdate_579368(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesUpdate_579367(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the content of a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579369 = path.getOrDefault("enterpriseId")
  valid_579369 = validateParameter(valid_579369, JString, required = true,
                                 default = nil)
  if valid_579369 != nil:
    section.add "enterpriseId", valid_579369
  var valid_579370 = path.getOrDefault("pageId")
  valid_579370 = validateParameter(valid_579370, JString, required = true,
                                 default = nil)
  if valid_579370 != nil:
    section.add "pageId", valid_579370
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579371 = query.getOrDefault("key")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "key", valid_579371
  var valid_579372 = query.getOrDefault("prettyPrint")
  valid_579372 = validateParameter(valid_579372, JBool, required = false,
                                 default = newJBool(true))
  if valid_579372 != nil:
    section.add "prettyPrint", valid_579372
  var valid_579373 = query.getOrDefault("oauth_token")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "oauth_token", valid_579373
  var valid_579374 = query.getOrDefault("alt")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = newJString("json"))
  if valid_579374 != nil:
    section.add "alt", valid_579374
  var valid_579375 = query.getOrDefault("userIp")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "userIp", valid_579375
  var valid_579376 = query.getOrDefault("quotaUser")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "quotaUser", valid_579376
  var valid_579377 = query.getOrDefault("fields")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "fields", valid_579377
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

proc call*(call_579379: Call_AndroidenterpriseStorelayoutpagesUpdate_579366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page.
  ## 
  let valid = call_579379.validator(path, query, header, formData, body)
  let scheme = call_579379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579379.url(scheme.get, call_579379.host, call_579379.base,
                         call_579379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579379, url, valid)

proc call*(call_579380: Call_AndroidenterpriseStorelayoutpagesUpdate_579366;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesUpdate
  ## Updates the content of a store page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579381 = newJObject()
  var query_579382 = newJObject()
  var body_579383 = newJObject()
  add(query_579382, "key", newJString(key))
  add(query_579382, "prettyPrint", newJBool(prettyPrint))
  add(query_579382, "oauth_token", newJString(oauthToken))
  add(query_579382, "alt", newJString(alt))
  add(query_579382, "userIp", newJString(userIp))
  add(query_579382, "quotaUser", newJString(quotaUser))
  add(path_579381, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579383 = body
  add(query_579382, "fields", newJString(fields))
  add(path_579381, "pageId", newJString(pageId))
  result = call_579380.call(path_579381, query_579382, nil, nil, body_579383)

var androidenterpriseStorelayoutpagesUpdate* = Call_AndroidenterpriseStorelayoutpagesUpdate_579366(
    name: "androidenterpriseStorelayoutpagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesUpdate_579367,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesUpdate_579368,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesGet_579350 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesGet_579352(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesGet_579351(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579353 = path.getOrDefault("enterpriseId")
  valid_579353 = validateParameter(valid_579353, JString, required = true,
                                 default = nil)
  if valid_579353 != nil:
    section.add "enterpriseId", valid_579353
  var valid_579354 = path.getOrDefault("pageId")
  valid_579354 = validateParameter(valid_579354, JString, required = true,
                                 default = nil)
  if valid_579354 != nil:
    section.add "pageId", valid_579354
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579358 = query.getOrDefault("alt")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = newJString("json"))
  if valid_579358 != nil:
    section.add "alt", valid_579358
  var valid_579359 = query.getOrDefault("userIp")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "userIp", valid_579359
  var valid_579360 = query.getOrDefault("quotaUser")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "quotaUser", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579362: Call_AndroidenterpriseStorelayoutpagesGet_579350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a store page.
  ## 
  let valid = call_579362.validator(path, query, header, formData, body)
  let scheme = call_579362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579362.url(scheme.get, call_579362.host, call_579362.base,
                         call_579362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579362, url, valid)

proc call*(call_579363: Call_AndroidenterpriseStorelayoutpagesGet_579350;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesGet
  ## Retrieves details of a store page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579364 = newJObject()
  var query_579365 = newJObject()
  add(query_579365, "key", newJString(key))
  add(query_579365, "prettyPrint", newJBool(prettyPrint))
  add(query_579365, "oauth_token", newJString(oauthToken))
  add(query_579365, "alt", newJString(alt))
  add(query_579365, "userIp", newJString(userIp))
  add(query_579365, "quotaUser", newJString(quotaUser))
  add(path_579364, "enterpriseId", newJString(enterpriseId))
  add(query_579365, "fields", newJString(fields))
  add(path_579364, "pageId", newJString(pageId))
  result = call_579363.call(path_579364, query_579365, nil, nil, nil)

var androidenterpriseStorelayoutpagesGet* = Call_AndroidenterpriseStorelayoutpagesGet_579350(
    name: "androidenterpriseStorelayoutpagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesGet_579351,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesGet_579352,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesPatch_579400 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesPatch_579402(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesPatch_579401(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579403 = path.getOrDefault("enterpriseId")
  valid_579403 = validateParameter(valid_579403, JString, required = true,
                                 default = nil)
  if valid_579403 != nil:
    section.add "enterpriseId", valid_579403
  var valid_579404 = path.getOrDefault("pageId")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "pageId", valid_579404
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579405 = query.getOrDefault("key")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "key", valid_579405
  var valid_579406 = query.getOrDefault("prettyPrint")
  valid_579406 = validateParameter(valid_579406, JBool, required = false,
                                 default = newJBool(true))
  if valid_579406 != nil:
    section.add "prettyPrint", valid_579406
  var valid_579407 = query.getOrDefault("oauth_token")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "oauth_token", valid_579407
  var valid_579408 = query.getOrDefault("alt")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = newJString("json"))
  if valid_579408 != nil:
    section.add "alt", valid_579408
  var valid_579409 = query.getOrDefault("userIp")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "userIp", valid_579409
  var valid_579410 = query.getOrDefault("quotaUser")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "quotaUser", valid_579410
  var valid_579411 = query.getOrDefault("fields")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "fields", valid_579411
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

proc call*(call_579413: Call_AndroidenterpriseStorelayoutpagesPatch_579400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  let valid = call_579413.validator(path, query, header, formData, body)
  let scheme = call_579413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579413.url(scheme.get, call_579413.host, call_579413.base,
                         call_579413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579413, url, valid)

proc call*(call_579414: Call_AndroidenterpriseStorelayoutpagesPatch_579400;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesPatch
  ## Updates the content of a store page. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579415 = newJObject()
  var query_579416 = newJObject()
  var body_579417 = newJObject()
  add(query_579416, "key", newJString(key))
  add(query_579416, "prettyPrint", newJBool(prettyPrint))
  add(query_579416, "oauth_token", newJString(oauthToken))
  add(query_579416, "alt", newJString(alt))
  add(query_579416, "userIp", newJString(userIp))
  add(query_579416, "quotaUser", newJString(quotaUser))
  add(path_579415, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579417 = body
  add(query_579416, "fields", newJString(fields))
  add(path_579415, "pageId", newJString(pageId))
  result = call_579414.call(path_579415, query_579416, nil, nil, body_579417)

var androidenterpriseStorelayoutpagesPatch* = Call_AndroidenterpriseStorelayoutpagesPatch_579400(
    name: "androidenterpriseStorelayoutpagesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesPatch_579401,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesPatch_579402,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesDelete_579384 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutpagesDelete_579386(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesDelete_579385(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579387 = path.getOrDefault("enterpriseId")
  valid_579387 = validateParameter(valid_579387, JString, required = true,
                                 default = nil)
  if valid_579387 != nil:
    section.add "enterpriseId", valid_579387
  var valid_579388 = path.getOrDefault("pageId")
  valid_579388 = validateParameter(valid_579388, JString, required = true,
                                 default = nil)
  if valid_579388 != nil:
    section.add "pageId", valid_579388
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579389 = query.getOrDefault("key")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "key", valid_579389
  var valid_579390 = query.getOrDefault("prettyPrint")
  valid_579390 = validateParameter(valid_579390, JBool, required = false,
                                 default = newJBool(true))
  if valid_579390 != nil:
    section.add "prettyPrint", valid_579390
  var valid_579391 = query.getOrDefault("oauth_token")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "oauth_token", valid_579391
  var valid_579392 = query.getOrDefault("alt")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = newJString("json"))
  if valid_579392 != nil:
    section.add "alt", valid_579392
  var valid_579393 = query.getOrDefault("userIp")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "userIp", valid_579393
  var valid_579394 = query.getOrDefault("quotaUser")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "quotaUser", valid_579394
  var valid_579395 = query.getOrDefault("fields")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "fields", valid_579395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579396: Call_AndroidenterpriseStorelayoutpagesDelete_579384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a store page.
  ## 
  let valid = call_579396.validator(path, query, header, formData, body)
  let scheme = call_579396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579396.url(scheme.get, call_579396.host, call_579396.base,
                         call_579396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579396, url, valid)

proc call*(call_579397: Call_AndroidenterpriseStorelayoutpagesDelete_579384;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutpagesDelete
  ## Deletes a store page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579398 = newJObject()
  var query_579399 = newJObject()
  add(query_579399, "key", newJString(key))
  add(query_579399, "prettyPrint", newJBool(prettyPrint))
  add(query_579399, "oauth_token", newJString(oauthToken))
  add(query_579399, "alt", newJString(alt))
  add(query_579399, "userIp", newJString(userIp))
  add(query_579399, "quotaUser", newJString(quotaUser))
  add(path_579398, "enterpriseId", newJString(enterpriseId))
  add(query_579399, "fields", newJString(fields))
  add(path_579398, "pageId", newJString(pageId))
  result = call_579397.call(path_579398, query_579399, nil, nil, nil)

var androidenterpriseStorelayoutpagesDelete* = Call_AndroidenterpriseStorelayoutpagesDelete_579384(
    name: "androidenterpriseStorelayoutpagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesDelete_579385,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesDelete_579386,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersInsert_579434 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersInsert_579436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersInsert_579435(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new cluster in a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579437 = path.getOrDefault("enterpriseId")
  valid_579437 = validateParameter(valid_579437, JString, required = true,
                                 default = nil)
  if valid_579437 != nil:
    section.add "enterpriseId", valid_579437
  var valid_579438 = path.getOrDefault("pageId")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "pageId", valid_579438
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579442 = query.getOrDefault("alt")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("json"))
  if valid_579442 != nil:
    section.add "alt", valid_579442
  var valid_579443 = query.getOrDefault("userIp")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "userIp", valid_579443
  var valid_579444 = query.getOrDefault("quotaUser")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "quotaUser", valid_579444
  var valid_579445 = query.getOrDefault("fields")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "fields", valid_579445
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

proc call*(call_579447: Call_AndroidenterpriseStorelayoutclustersInsert_579434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new cluster in a page.
  ## 
  let valid = call_579447.validator(path, query, header, formData, body)
  let scheme = call_579447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579447.url(scheme.get, call_579447.host, call_579447.base,
                         call_579447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579447, url, valid)

proc call*(call_579448: Call_AndroidenterpriseStorelayoutclustersInsert_579434;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersInsert
  ## Inserts a new cluster in a page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579449 = newJObject()
  var query_579450 = newJObject()
  var body_579451 = newJObject()
  add(query_579450, "key", newJString(key))
  add(query_579450, "prettyPrint", newJBool(prettyPrint))
  add(query_579450, "oauth_token", newJString(oauthToken))
  add(query_579450, "alt", newJString(alt))
  add(query_579450, "userIp", newJString(userIp))
  add(query_579450, "quotaUser", newJString(quotaUser))
  add(path_579449, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579451 = body
  add(query_579450, "fields", newJString(fields))
  add(path_579449, "pageId", newJString(pageId))
  result = call_579448.call(path_579449, query_579450, nil, nil, body_579451)

var androidenterpriseStorelayoutclustersInsert* = Call_AndroidenterpriseStorelayoutclustersInsert_579434(
    name: "androidenterpriseStorelayoutclustersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersInsert_579435,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersInsert_579436,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersList_579418 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersList_579420(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersList_579419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579421 = path.getOrDefault("enterpriseId")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "enterpriseId", valid_579421
  var valid_579422 = path.getOrDefault("pageId")
  valid_579422 = validateParameter(valid_579422, JString, required = true,
                                 default = nil)
  if valid_579422 != nil:
    section.add "pageId", valid_579422
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579423 = query.getOrDefault("key")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "key", valid_579423
  var valid_579424 = query.getOrDefault("prettyPrint")
  valid_579424 = validateParameter(valid_579424, JBool, required = false,
                                 default = newJBool(true))
  if valid_579424 != nil:
    section.add "prettyPrint", valid_579424
  var valid_579425 = query.getOrDefault("oauth_token")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "oauth_token", valid_579425
  var valid_579426 = query.getOrDefault("alt")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = newJString("json"))
  if valid_579426 != nil:
    section.add "alt", valid_579426
  var valid_579427 = query.getOrDefault("userIp")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "userIp", valid_579427
  var valid_579428 = query.getOrDefault("quotaUser")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "quotaUser", valid_579428
  var valid_579429 = query.getOrDefault("fields")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "fields", valid_579429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579430: Call_AndroidenterpriseStorelayoutclustersList_579418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  let valid = call_579430.validator(path, query, header, formData, body)
  let scheme = call_579430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579430.url(scheme.get, call_579430.host, call_579430.base,
                         call_579430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579430, url, valid)

proc call*(call_579431: Call_AndroidenterpriseStorelayoutclustersList_579418;
          enterpriseId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersList
  ## Retrieves the details of all clusters on the specified page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579432 = newJObject()
  var query_579433 = newJObject()
  add(query_579433, "key", newJString(key))
  add(query_579433, "prettyPrint", newJBool(prettyPrint))
  add(query_579433, "oauth_token", newJString(oauthToken))
  add(query_579433, "alt", newJString(alt))
  add(query_579433, "userIp", newJString(userIp))
  add(query_579433, "quotaUser", newJString(quotaUser))
  add(path_579432, "enterpriseId", newJString(enterpriseId))
  add(query_579433, "fields", newJString(fields))
  add(path_579432, "pageId", newJString(pageId))
  result = call_579431.call(path_579432, query_579433, nil, nil, nil)

var androidenterpriseStorelayoutclustersList* = Call_AndroidenterpriseStorelayoutclustersList_579418(
    name: "androidenterpriseStorelayoutclustersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersList_579419,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersList_579420,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersUpdate_579469 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersUpdate_579471(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersUpdate_579470(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579472 = path.getOrDefault("enterpriseId")
  valid_579472 = validateParameter(valid_579472, JString, required = true,
                                 default = nil)
  if valid_579472 != nil:
    section.add "enterpriseId", valid_579472
  var valid_579473 = path.getOrDefault("clusterId")
  valid_579473 = validateParameter(valid_579473, JString, required = true,
                                 default = nil)
  if valid_579473 != nil:
    section.add "clusterId", valid_579473
  var valid_579474 = path.getOrDefault("pageId")
  valid_579474 = validateParameter(valid_579474, JString, required = true,
                                 default = nil)
  if valid_579474 != nil:
    section.add "pageId", valid_579474
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579475 = query.getOrDefault("key")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "key", valid_579475
  var valid_579476 = query.getOrDefault("prettyPrint")
  valid_579476 = validateParameter(valid_579476, JBool, required = false,
                                 default = newJBool(true))
  if valid_579476 != nil:
    section.add "prettyPrint", valid_579476
  var valid_579477 = query.getOrDefault("oauth_token")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "oauth_token", valid_579477
  var valid_579478 = query.getOrDefault("alt")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = newJString("json"))
  if valid_579478 != nil:
    section.add "alt", valid_579478
  var valid_579479 = query.getOrDefault("userIp")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "userIp", valid_579479
  var valid_579480 = query.getOrDefault("quotaUser")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "quotaUser", valid_579480
  var valid_579481 = query.getOrDefault("fields")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "fields", valid_579481
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

proc call*(call_579483: Call_AndroidenterpriseStorelayoutclustersUpdate_579469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster.
  ## 
  let valid = call_579483.validator(path, query, header, formData, body)
  let scheme = call_579483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579483.url(scheme.get, call_579483.host, call_579483.base,
                         call_579483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579483, url, valid)

proc call*(call_579484: Call_AndroidenterpriseStorelayoutclustersUpdate_579469;
          enterpriseId: string; clusterId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersUpdate
  ## Updates a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579485 = newJObject()
  var query_579486 = newJObject()
  var body_579487 = newJObject()
  add(query_579486, "key", newJString(key))
  add(query_579486, "prettyPrint", newJBool(prettyPrint))
  add(query_579486, "oauth_token", newJString(oauthToken))
  add(query_579486, "alt", newJString(alt))
  add(query_579486, "userIp", newJString(userIp))
  add(query_579486, "quotaUser", newJString(quotaUser))
  add(path_579485, "enterpriseId", newJString(enterpriseId))
  add(path_579485, "clusterId", newJString(clusterId))
  if body != nil:
    body_579487 = body
  add(query_579486, "fields", newJString(fields))
  add(path_579485, "pageId", newJString(pageId))
  result = call_579484.call(path_579485, query_579486, nil, nil, body_579487)

var androidenterpriseStorelayoutclustersUpdate* = Call_AndroidenterpriseStorelayoutclustersUpdate_579469(
    name: "androidenterpriseStorelayoutclustersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersUpdate_579470,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersUpdate_579471,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersGet_579452 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersGet_579454(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersGet_579453(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579455 = path.getOrDefault("enterpriseId")
  valid_579455 = validateParameter(valid_579455, JString, required = true,
                                 default = nil)
  if valid_579455 != nil:
    section.add "enterpriseId", valid_579455
  var valid_579456 = path.getOrDefault("clusterId")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "clusterId", valid_579456
  var valid_579457 = path.getOrDefault("pageId")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "pageId", valid_579457
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579458 = query.getOrDefault("key")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "key", valid_579458
  var valid_579459 = query.getOrDefault("prettyPrint")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "prettyPrint", valid_579459
  var valid_579460 = query.getOrDefault("oauth_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "oauth_token", valid_579460
  var valid_579461 = query.getOrDefault("alt")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = newJString("json"))
  if valid_579461 != nil:
    section.add "alt", valid_579461
  var valid_579462 = query.getOrDefault("userIp")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "userIp", valid_579462
  var valid_579463 = query.getOrDefault("quotaUser")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "quotaUser", valid_579463
  var valid_579464 = query.getOrDefault("fields")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "fields", valid_579464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579465: Call_AndroidenterpriseStorelayoutclustersGet_579452;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a cluster.
  ## 
  let valid = call_579465.validator(path, query, header, formData, body)
  let scheme = call_579465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579465.url(scheme.get, call_579465.host, call_579465.base,
                         call_579465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579465, url, valid)

proc call*(call_579466: Call_AndroidenterpriseStorelayoutclustersGet_579452;
          enterpriseId: string; clusterId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersGet
  ## Retrieves details of a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579467 = newJObject()
  var query_579468 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "userIp", newJString(userIp))
  add(query_579468, "quotaUser", newJString(quotaUser))
  add(path_579467, "enterpriseId", newJString(enterpriseId))
  add(path_579467, "clusterId", newJString(clusterId))
  add(query_579468, "fields", newJString(fields))
  add(path_579467, "pageId", newJString(pageId))
  result = call_579466.call(path_579467, query_579468, nil, nil, nil)

var androidenterpriseStorelayoutclustersGet* = Call_AndroidenterpriseStorelayoutclustersGet_579452(
    name: "androidenterpriseStorelayoutclustersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersGet_579453,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersGet_579454,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersPatch_579505 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersPatch_579507(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersPatch_579506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579508 = path.getOrDefault("enterpriseId")
  valid_579508 = validateParameter(valid_579508, JString, required = true,
                                 default = nil)
  if valid_579508 != nil:
    section.add "enterpriseId", valid_579508
  var valid_579509 = path.getOrDefault("clusterId")
  valid_579509 = validateParameter(valid_579509, JString, required = true,
                                 default = nil)
  if valid_579509 != nil:
    section.add "clusterId", valid_579509
  var valid_579510 = path.getOrDefault("pageId")
  valid_579510 = validateParameter(valid_579510, JString, required = true,
                                 default = nil)
  if valid_579510 != nil:
    section.add "pageId", valid_579510
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579511 = query.getOrDefault("key")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "key", valid_579511
  var valid_579512 = query.getOrDefault("prettyPrint")
  valid_579512 = validateParameter(valid_579512, JBool, required = false,
                                 default = newJBool(true))
  if valid_579512 != nil:
    section.add "prettyPrint", valid_579512
  var valid_579513 = query.getOrDefault("oauth_token")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "oauth_token", valid_579513
  var valid_579514 = query.getOrDefault("alt")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = newJString("json"))
  if valid_579514 != nil:
    section.add "alt", valid_579514
  var valid_579515 = query.getOrDefault("userIp")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "userIp", valid_579515
  var valid_579516 = query.getOrDefault("quotaUser")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "quotaUser", valid_579516
  var valid_579517 = query.getOrDefault("fields")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "fields", valid_579517
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

proc call*(call_579519: Call_AndroidenterpriseStorelayoutclustersPatch_579505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  let valid = call_579519.validator(path, query, header, formData, body)
  let scheme = call_579519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579519.url(scheme.get, call_579519.host, call_579519.base,
                         call_579519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579519, url, valid)

proc call*(call_579520: Call_AndroidenterpriseStorelayoutclustersPatch_579505;
          enterpriseId: string; clusterId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersPatch
  ## Updates a cluster. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579521 = newJObject()
  var query_579522 = newJObject()
  var body_579523 = newJObject()
  add(query_579522, "key", newJString(key))
  add(query_579522, "prettyPrint", newJBool(prettyPrint))
  add(query_579522, "oauth_token", newJString(oauthToken))
  add(query_579522, "alt", newJString(alt))
  add(query_579522, "userIp", newJString(userIp))
  add(query_579522, "quotaUser", newJString(quotaUser))
  add(path_579521, "enterpriseId", newJString(enterpriseId))
  add(path_579521, "clusterId", newJString(clusterId))
  if body != nil:
    body_579523 = body
  add(query_579522, "fields", newJString(fields))
  add(path_579521, "pageId", newJString(pageId))
  result = call_579520.call(path_579521, query_579522, nil, nil, body_579523)

var androidenterpriseStorelayoutclustersPatch* = Call_AndroidenterpriseStorelayoutclustersPatch_579505(
    name: "androidenterpriseStorelayoutclustersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersPatch_579506,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersPatch_579507,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersDelete_579488 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseStorelayoutclustersDelete_579490(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersDelete_579489(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579491 = path.getOrDefault("enterpriseId")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "enterpriseId", valid_579491
  var valid_579492 = path.getOrDefault("clusterId")
  valid_579492 = validateParameter(valid_579492, JString, required = true,
                                 default = nil)
  if valid_579492 != nil:
    section.add "clusterId", valid_579492
  var valid_579493 = path.getOrDefault("pageId")
  valid_579493 = validateParameter(valid_579493, JString, required = true,
                                 default = nil)
  if valid_579493 != nil:
    section.add "pageId", valid_579493
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579494 = query.getOrDefault("key")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "key", valid_579494
  var valid_579495 = query.getOrDefault("prettyPrint")
  valid_579495 = validateParameter(valid_579495, JBool, required = false,
                                 default = newJBool(true))
  if valid_579495 != nil:
    section.add "prettyPrint", valid_579495
  var valid_579496 = query.getOrDefault("oauth_token")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "oauth_token", valid_579496
  var valid_579497 = query.getOrDefault("alt")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = newJString("json"))
  if valid_579497 != nil:
    section.add "alt", valid_579497
  var valid_579498 = query.getOrDefault("userIp")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "userIp", valid_579498
  var valid_579499 = query.getOrDefault("quotaUser")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "quotaUser", valid_579499
  var valid_579500 = query.getOrDefault("fields")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "fields", valid_579500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579501: Call_AndroidenterpriseStorelayoutclustersDelete_579488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster.
  ## 
  let valid = call_579501.validator(path, query, header, formData, body)
  let scheme = call_579501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579501.url(scheme.get, call_579501.host, call_579501.base,
                         call_579501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579501, url, valid)

proc call*(call_579502: Call_AndroidenterpriseStorelayoutclustersDelete_579488;
          enterpriseId: string; clusterId: string; pageId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseStorelayoutclustersDelete
  ## Deletes a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579503 = newJObject()
  var query_579504 = newJObject()
  add(query_579504, "key", newJString(key))
  add(query_579504, "prettyPrint", newJBool(prettyPrint))
  add(query_579504, "oauth_token", newJString(oauthToken))
  add(query_579504, "alt", newJString(alt))
  add(query_579504, "userIp", newJString(userIp))
  add(query_579504, "quotaUser", newJString(quotaUser))
  add(path_579503, "enterpriseId", newJString(enterpriseId))
  add(path_579503, "clusterId", newJString(clusterId))
  add(query_579504, "fields", newJString(fields))
  add(path_579503, "pageId", newJString(pageId))
  result = call_579502.call(path_579503, query_579504, nil, nil, nil)

var androidenterpriseStorelayoutclustersDelete* = Call_AndroidenterpriseStorelayoutclustersDelete_579488(
    name: "androidenterpriseStorelayoutclustersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersDelete_579489,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersDelete_579490,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesUnenroll_579524 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEnterprisesUnenroll_579526(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/unenroll")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesUnenroll_579525(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579527 = path.getOrDefault("enterpriseId")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "enterpriseId", valid_579527
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579528 = query.getOrDefault("key")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "key", valid_579528
  var valid_579529 = query.getOrDefault("prettyPrint")
  valid_579529 = validateParameter(valid_579529, JBool, required = false,
                                 default = newJBool(true))
  if valid_579529 != nil:
    section.add "prettyPrint", valid_579529
  var valid_579530 = query.getOrDefault("oauth_token")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "oauth_token", valid_579530
  var valid_579531 = query.getOrDefault("alt")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = newJString("json"))
  if valid_579531 != nil:
    section.add "alt", valid_579531
  var valid_579532 = query.getOrDefault("userIp")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "userIp", valid_579532
  var valid_579533 = query.getOrDefault("quotaUser")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "quotaUser", valid_579533
  var valid_579534 = query.getOrDefault("fields")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fields", valid_579534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579535: Call_AndroidenterpriseEnterprisesUnenroll_579524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  let valid = call_579535.validator(path, query, header, formData, body)
  let scheme = call_579535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579535.url(scheme.get, call_579535.host, call_579535.base,
                         call_579535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579535, url, valid)

proc call*(call_579536: Call_AndroidenterpriseEnterprisesUnenroll_579524;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEnterprisesUnenroll
  ## Unenrolls an enterprise from the calling EMM.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579537 = newJObject()
  var query_579538 = newJObject()
  add(query_579538, "key", newJString(key))
  add(query_579538, "prettyPrint", newJBool(prettyPrint))
  add(query_579538, "oauth_token", newJString(oauthToken))
  add(query_579538, "alt", newJString(alt))
  add(query_579538, "userIp", newJString(userIp))
  add(query_579538, "quotaUser", newJString(quotaUser))
  add(path_579537, "enterpriseId", newJString(enterpriseId))
  add(query_579538, "fields", newJString(fields))
  result = call_579536.call(path_579537, query_579538, nil, nil, nil)

var androidenterpriseEnterprisesUnenroll* = Call_AndroidenterpriseEnterprisesUnenroll_579524(
    name: "androidenterpriseEnterprisesUnenroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/unenroll",
    validator: validate_AndroidenterpriseEnterprisesUnenroll_579525,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesUnenroll_579526,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersInsert_579555 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersInsert_579557(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersInsert_579556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579558 = path.getOrDefault("enterpriseId")
  valid_579558 = validateParameter(valid_579558, JString, required = true,
                                 default = nil)
  if valid_579558 != nil:
    section.add "enterpriseId", valid_579558
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579559 = query.getOrDefault("key")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "key", valid_579559
  var valid_579560 = query.getOrDefault("prettyPrint")
  valid_579560 = validateParameter(valid_579560, JBool, required = false,
                                 default = newJBool(true))
  if valid_579560 != nil:
    section.add "prettyPrint", valid_579560
  var valid_579561 = query.getOrDefault("oauth_token")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "oauth_token", valid_579561
  var valid_579562 = query.getOrDefault("alt")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = newJString("json"))
  if valid_579562 != nil:
    section.add "alt", valid_579562
  var valid_579563 = query.getOrDefault("userIp")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "userIp", valid_579563
  var valid_579564 = query.getOrDefault("quotaUser")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "quotaUser", valid_579564
  var valid_579565 = query.getOrDefault("fields")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "fields", valid_579565
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

proc call*(call_579567: Call_AndroidenterpriseUsersInsert_579555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  let valid = call_579567.validator(path, query, header, formData, body)
  let scheme = call_579567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579567.url(scheme.get, call_579567.host, call_579567.base,
                         call_579567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579567, url, valid)

proc call*(call_579568: Call_AndroidenterpriseUsersInsert_579555;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseUsersInsert
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579569 = newJObject()
  var query_579570 = newJObject()
  var body_579571 = newJObject()
  add(query_579570, "key", newJString(key))
  add(query_579570, "prettyPrint", newJBool(prettyPrint))
  add(query_579570, "oauth_token", newJString(oauthToken))
  add(query_579570, "alt", newJString(alt))
  add(query_579570, "userIp", newJString(userIp))
  add(query_579570, "quotaUser", newJString(quotaUser))
  add(path_579569, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_579571 = body
  add(query_579570, "fields", newJString(fields))
  result = call_579568.call(path_579569, query_579570, nil, nil, body_579571)

var androidenterpriseUsersInsert* = Call_AndroidenterpriseUsersInsert_579555(
    name: "androidenterpriseUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersInsert_579556,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersInsert_579557,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersList_579539 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersList_579541(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersList_579540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579542 = path.getOrDefault("enterpriseId")
  valid_579542 = validateParameter(valid_579542, JString, required = true,
                                 default = nil)
  if valid_579542 != nil:
    section.add "enterpriseId", valid_579542
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   email: JString (required)
  ##        : The exact primary email address of the user to look up.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579543 = query.getOrDefault("key")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "key", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  assert query != nil, "query argument is necessary due to required `email` field"
  var valid_579546 = query.getOrDefault("email")
  valid_579546 = validateParameter(valid_579546, JString, required = true,
                                 default = nil)
  if valid_579546 != nil:
    section.add "email", valid_579546
  var valid_579547 = query.getOrDefault("alt")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = newJString("json"))
  if valid_579547 != nil:
    section.add "alt", valid_579547
  var valid_579548 = query.getOrDefault("userIp")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "userIp", valid_579548
  var valid_579549 = query.getOrDefault("quotaUser")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "quotaUser", valid_579549
  var valid_579550 = query.getOrDefault("fields")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "fields", valid_579550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579551: Call_AndroidenterpriseUsersList_579539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  let valid = call_579551.validator(path, query, header, formData, body)
  let scheme = call_579551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579551.url(scheme.get, call_579551.host, call_579551.base,
                         call_579551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579551, url, valid)

proc call*(call_579552: Call_AndroidenterpriseUsersList_579539; email: string;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersList
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   email: string (required)
  ##        : The exact primary email address of the user to look up.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579553 = newJObject()
  var query_579554 = newJObject()
  add(query_579554, "key", newJString(key))
  add(query_579554, "prettyPrint", newJBool(prettyPrint))
  add(query_579554, "oauth_token", newJString(oauthToken))
  add(query_579554, "email", newJString(email))
  add(query_579554, "alt", newJString(alt))
  add(query_579554, "userIp", newJString(userIp))
  add(query_579554, "quotaUser", newJString(quotaUser))
  add(path_579553, "enterpriseId", newJString(enterpriseId))
  add(query_579554, "fields", newJString(fields))
  result = call_579552.call(path_579553, query_579554, nil, nil, nil)

var androidenterpriseUsersList* = Call_AndroidenterpriseUsersList_579539(
    name: "androidenterpriseUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersList_579540,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersList_579541,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersUpdate_579588 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersUpdate_579590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersUpdate_579589(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579591 = path.getOrDefault("enterpriseId")
  valid_579591 = validateParameter(valid_579591, JString, required = true,
                                 default = nil)
  if valid_579591 != nil:
    section.add "enterpriseId", valid_579591
  var valid_579592 = path.getOrDefault("userId")
  valid_579592 = validateParameter(valid_579592, JString, required = true,
                                 default = nil)
  if valid_579592 != nil:
    section.add "userId", valid_579592
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579593 = query.getOrDefault("key")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "key", valid_579593
  var valid_579594 = query.getOrDefault("prettyPrint")
  valid_579594 = validateParameter(valid_579594, JBool, required = false,
                                 default = newJBool(true))
  if valid_579594 != nil:
    section.add "prettyPrint", valid_579594
  var valid_579595 = query.getOrDefault("oauth_token")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "oauth_token", valid_579595
  var valid_579596 = query.getOrDefault("alt")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = newJString("json"))
  if valid_579596 != nil:
    section.add "alt", valid_579596
  var valid_579597 = query.getOrDefault("userIp")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "userIp", valid_579597
  var valid_579598 = query.getOrDefault("quotaUser")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "quotaUser", valid_579598
  var valid_579599 = query.getOrDefault("fields")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "fields", valid_579599
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

proc call*(call_579601: Call_AndroidenterpriseUsersUpdate_579588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  let valid = call_579601.validator(path, query, header, formData, body)
  let scheme = call_579601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579601.url(scheme.get, call_579601.host, call_579601.base,
                         call_579601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579601, url, valid)

proc call*(call_579602: Call_AndroidenterpriseUsersUpdate_579588;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseUsersUpdate
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579603 = newJObject()
  var query_579604 = newJObject()
  var body_579605 = newJObject()
  add(query_579604, "key", newJString(key))
  add(query_579604, "prettyPrint", newJBool(prettyPrint))
  add(query_579604, "oauth_token", newJString(oauthToken))
  add(query_579604, "alt", newJString(alt))
  add(query_579604, "userIp", newJString(userIp))
  add(query_579604, "quotaUser", newJString(quotaUser))
  add(path_579603, "enterpriseId", newJString(enterpriseId))
  add(path_579603, "userId", newJString(userId))
  if body != nil:
    body_579605 = body
  add(query_579604, "fields", newJString(fields))
  result = call_579602.call(path_579603, query_579604, nil, nil, body_579605)

var androidenterpriseUsersUpdate* = Call_AndroidenterpriseUsersUpdate_579588(
    name: "androidenterpriseUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersUpdate_579589,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersUpdate_579590,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGet_579572 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersGet_579574(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGet_579573(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a user's details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579575 = path.getOrDefault("enterpriseId")
  valid_579575 = validateParameter(valid_579575, JString, required = true,
                                 default = nil)
  if valid_579575 != nil:
    section.add "enterpriseId", valid_579575
  var valid_579576 = path.getOrDefault("userId")
  valid_579576 = validateParameter(valid_579576, JString, required = true,
                                 default = nil)
  if valid_579576 != nil:
    section.add "userId", valid_579576
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579577 = query.getOrDefault("key")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "key", valid_579577
  var valid_579578 = query.getOrDefault("prettyPrint")
  valid_579578 = validateParameter(valid_579578, JBool, required = false,
                                 default = newJBool(true))
  if valid_579578 != nil:
    section.add "prettyPrint", valid_579578
  var valid_579579 = query.getOrDefault("oauth_token")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "oauth_token", valid_579579
  var valid_579580 = query.getOrDefault("alt")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = newJString("json"))
  if valid_579580 != nil:
    section.add "alt", valid_579580
  var valid_579581 = query.getOrDefault("userIp")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "userIp", valid_579581
  var valid_579582 = query.getOrDefault("quotaUser")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "quotaUser", valid_579582
  var valid_579583 = query.getOrDefault("fields")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "fields", valid_579583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579584: Call_AndroidenterpriseUsersGet_579572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a user's details.
  ## 
  let valid = call_579584.validator(path, query, header, formData, body)
  let scheme = call_579584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579584.url(scheme.get, call_579584.host, call_579584.base,
                         call_579584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579584, url, valid)

proc call*(call_579585: Call_AndroidenterpriseUsersGet_579572;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersGet
  ## Retrieves a user's details.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579586 = newJObject()
  var query_579587 = newJObject()
  add(query_579587, "key", newJString(key))
  add(query_579587, "prettyPrint", newJBool(prettyPrint))
  add(query_579587, "oauth_token", newJString(oauthToken))
  add(query_579587, "alt", newJString(alt))
  add(query_579587, "userIp", newJString(userIp))
  add(query_579587, "quotaUser", newJString(quotaUser))
  add(path_579586, "enterpriseId", newJString(enterpriseId))
  add(path_579586, "userId", newJString(userId))
  add(query_579587, "fields", newJString(fields))
  result = call_579585.call(path_579586, query_579587, nil, nil, nil)

var androidenterpriseUsersGet* = Call_AndroidenterpriseUsersGet_579572(
    name: "androidenterpriseUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersGet_579573,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGet_579574,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersPatch_579622 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersPatch_579624(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersPatch_579623(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579625 = path.getOrDefault("enterpriseId")
  valid_579625 = validateParameter(valid_579625, JString, required = true,
                                 default = nil)
  if valid_579625 != nil:
    section.add "enterpriseId", valid_579625
  var valid_579626 = path.getOrDefault("userId")
  valid_579626 = validateParameter(valid_579626, JString, required = true,
                                 default = nil)
  if valid_579626 != nil:
    section.add "userId", valid_579626
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579627 = query.getOrDefault("key")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "key", valid_579627
  var valid_579628 = query.getOrDefault("prettyPrint")
  valid_579628 = validateParameter(valid_579628, JBool, required = false,
                                 default = newJBool(true))
  if valid_579628 != nil:
    section.add "prettyPrint", valid_579628
  var valid_579629 = query.getOrDefault("oauth_token")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "oauth_token", valid_579629
  var valid_579630 = query.getOrDefault("alt")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = newJString("json"))
  if valid_579630 != nil:
    section.add "alt", valid_579630
  var valid_579631 = query.getOrDefault("userIp")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "userIp", valid_579631
  var valid_579632 = query.getOrDefault("quotaUser")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "quotaUser", valid_579632
  var valid_579633 = query.getOrDefault("fields")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "fields", valid_579633
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

proc call*(call_579635: Call_AndroidenterpriseUsersPatch_579622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  let valid = call_579635.validator(path, query, header, formData, body)
  let scheme = call_579635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579635.url(scheme.get, call_579635.host, call_579635.base,
                         call_579635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579635, url, valid)

proc call*(call_579636: Call_AndroidenterpriseUsersPatch_579622;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseUsersPatch
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579637 = newJObject()
  var query_579638 = newJObject()
  var body_579639 = newJObject()
  add(query_579638, "key", newJString(key))
  add(query_579638, "prettyPrint", newJBool(prettyPrint))
  add(query_579638, "oauth_token", newJString(oauthToken))
  add(query_579638, "alt", newJString(alt))
  add(query_579638, "userIp", newJString(userIp))
  add(query_579638, "quotaUser", newJString(quotaUser))
  add(path_579637, "enterpriseId", newJString(enterpriseId))
  add(path_579637, "userId", newJString(userId))
  if body != nil:
    body_579639 = body
  add(query_579638, "fields", newJString(fields))
  result = call_579636.call(path_579637, query_579638, nil, nil, body_579639)

var androidenterpriseUsersPatch* = Call_AndroidenterpriseUsersPatch_579622(
    name: "androidenterpriseUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersPatch_579623,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersPatch_579624,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersDelete_579606 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersDelete_579608(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersDelete_579607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an EMM-managed user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579609 = path.getOrDefault("enterpriseId")
  valid_579609 = validateParameter(valid_579609, JString, required = true,
                                 default = nil)
  if valid_579609 != nil:
    section.add "enterpriseId", valid_579609
  var valid_579610 = path.getOrDefault("userId")
  valid_579610 = validateParameter(valid_579610, JString, required = true,
                                 default = nil)
  if valid_579610 != nil:
    section.add "userId", valid_579610
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579611 = query.getOrDefault("key")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = nil)
  if valid_579611 != nil:
    section.add "key", valid_579611
  var valid_579612 = query.getOrDefault("prettyPrint")
  valid_579612 = validateParameter(valid_579612, JBool, required = false,
                                 default = newJBool(true))
  if valid_579612 != nil:
    section.add "prettyPrint", valid_579612
  var valid_579613 = query.getOrDefault("oauth_token")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "oauth_token", valid_579613
  var valid_579614 = query.getOrDefault("alt")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = newJString("json"))
  if valid_579614 != nil:
    section.add "alt", valid_579614
  var valid_579615 = query.getOrDefault("userIp")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "userIp", valid_579615
  var valid_579616 = query.getOrDefault("quotaUser")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "quotaUser", valid_579616
  var valid_579617 = query.getOrDefault("fields")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "fields", valid_579617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579618: Call_AndroidenterpriseUsersDelete_579606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleted an EMM-managed user.
  ## 
  let valid = call_579618.validator(path, query, header, formData, body)
  let scheme = call_579618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579618.url(scheme.get, call_579618.host, call_579618.base,
                         call_579618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579618, url, valid)

proc call*(call_579619: Call_AndroidenterpriseUsersDelete_579606;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersDelete
  ## Deleted an EMM-managed user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579620 = newJObject()
  var query_579621 = newJObject()
  add(query_579621, "key", newJString(key))
  add(query_579621, "prettyPrint", newJBool(prettyPrint))
  add(query_579621, "oauth_token", newJString(oauthToken))
  add(query_579621, "alt", newJString(alt))
  add(query_579621, "userIp", newJString(userIp))
  add(query_579621, "quotaUser", newJString(quotaUser))
  add(path_579620, "enterpriseId", newJString(enterpriseId))
  add(path_579620, "userId", newJString(userId))
  add(query_579621, "fields", newJString(fields))
  result = call_579619.call(path_579620, query_579621, nil, nil, nil)

var androidenterpriseUsersDelete* = Call_AndroidenterpriseUsersDelete_579606(
    name: "androidenterpriseUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersDelete_579607,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersDelete_579608,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateAuthenticationToken_579640 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersGenerateAuthenticationToken_579642(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/authenticationToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGenerateAuthenticationToken_579641(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579643 = path.getOrDefault("enterpriseId")
  valid_579643 = validateParameter(valid_579643, JString, required = true,
                                 default = nil)
  if valid_579643 != nil:
    section.add "enterpriseId", valid_579643
  var valid_579644 = path.getOrDefault("userId")
  valid_579644 = validateParameter(valid_579644, JString, required = true,
                                 default = nil)
  if valid_579644 != nil:
    section.add "userId", valid_579644
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579645 = query.getOrDefault("key")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "key", valid_579645
  var valid_579646 = query.getOrDefault("prettyPrint")
  valid_579646 = validateParameter(valid_579646, JBool, required = false,
                                 default = newJBool(true))
  if valid_579646 != nil:
    section.add "prettyPrint", valid_579646
  var valid_579647 = query.getOrDefault("oauth_token")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "oauth_token", valid_579647
  var valid_579648 = query.getOrDefault("alt")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = newJString("json"))
  if valid_579648 != nil:
    section.add "alt", valid_579648
  var valid_579649 = query.getOrDefault("userIp")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "userIp", valid_579649
  var valid_579650 = query.getOrDefault("quotaUser")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "quotaUser", valid_579650
  var valid_579651 = query.getOrDefault("fields")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "fields", valid_579651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579652: Call_AndroidenterpriseUsersGenerateAuthenticationToken_579640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_579652.validator(path, query, header, formData, body)
  let scheme = call_579652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579652.url(scheme.get, call_579652.host, call_579652.base,
                         call_579652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579652, url, valid)

proc call*(call_579653: Call_AndroidenterpriseUsersGenerateAuthenticationToken_579640;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersGenerateAuthenticationToken
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579654 = newJObject()
  var query_579655 = newJObject()
  add(query_579655, "key", newJString(key))
  add(query_579655, "prettyPrint", newJBool(prettyPrint))
  add(query_579655, "oauth_token", newJString(oauthToken))
  add(query_579655, "alt", newJString(alt))
  add(query_579655, "userIp", newJString(userIp))
  add(query_579655, "quotaUser", newJString(quotaUser))
  add(path_579654, "enterpriseId", newJString(enterpriseId))
  add(path_579654, "userId", newJString(userId))
  add(query_579655, "fields", newJString(fields))
  result = call_579653.call(path_579654, query_579655, nil, nil, nil)

var androidenterpriseUsersGenerateAuthenticationToken* = Call_AndroidenterpriseUsersGenerateAuthenticationToken_579640(
    name: "androidenterpriseUsersGenerateAuthenticationToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/authenticationToken",
    validator: validate_AndroidenterpriseUsersGenerateAuthenticationToken_579641,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGenerateAuthenticationToken_579642,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersSetAvailableProductSet_579672 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersSetAvailableProductSet_579674(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/availableProductSet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersSetAvailableProductSet_579673(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579675 = path.getOrDefault("enterpriseId")
  valid_579675 = validateParameter(valid_579675, JString, required = true,
                                 default = nil)
  if valid_579675 != nil:
    section.add "enterpriseId", valid_579675
  var valid_579676 = path.getOrDefault("userId")
  valid_579676 = validateParameter(valid_579676, JString, required = true,
                                 default = nil)
  if valid_579676 != nil:
    section.add "userId", valid_579676
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579677 = query.getOrDefault("key")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = nil)
  if valid_579677 != nil:
    section.add "key", valid_579677
  var valid_579678 = query.getOrDefault("prettyPrint")
  valid_579678 = validateParameter(valid_579678, JBool, required = false,
                                 default = newJBool(true))
  if valid_579678 != nil:
    section.add "prettyPrint", valid_579678
  var valid_579679 = query.getOrDefault("oauth_token")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = nil)
  if valid_579679 != nil:
    section.add "oauth_token", valid_579679
  var valid_579680 = query.getOrDefault("alt")
  valid_579680 = validateParameter(valid_579680, JString, required = false,
                                 default = newJString("json"))
  if valid_579680 != nil:
    section.add "alt", valid_579680
  var valid_579681 = query.getOrDefault("userIp")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = nil)
  if valid_579681 != nil:
    section.add "userIp", valid_579681
  var valid_579682 = query.getOrDefault("quotaUser")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = nil)
  if valid_579682 != nil:
    section.add "quotaUser", valid_579682
  var valid_579683 = query.getOrDefault("fields")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "fields", valid_579683
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

proc call*(call_579685: Call_AndroidenterpriseUsersSetAvailableProductSet_579672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  let valid = call_579685.validator(path, query, header, formData, body)
  let scheme = call_579685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579685.url(scheme.get, call_579685.host, call_579685.base,
                         call_579685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579685, url, valid)

proc call*(call_579686: Call_AndroidenterpriseUsersSetAvailableProductSet_579672;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseUsersSetAvailableProductSet
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579687 = newJObject()
  var query_579688 = newJObject()
  var body_579689 = newJObject()
  add(query_579688, "key", newJString(key))
  add(query_579688, "prettyPrint", newJBool(prettyPrint))
  add(query_579688, "oauth_token", newJString(oauthToken))
  add(query_579688, "alt", newJString(alt))
  add(query_579688, "userIp", newJString(userIp))
  add(query_579688, "quotaUser", newJString(quotaUser))
  add(path_579687, "enterpriseId", newJString(enterpriseId))
  add(path_579687, "userId", newJString(userId))
  if body != nil:
    body_579689 = body
  add(query_579688, "fields", newJString(fields))
  result = call_579686.call(path_579687, query_579688, nil, nil, body_579689)

var androidenterpriseUsersSetAvailableProductSet* = Call_AndroidenterpriseUsersSetAvailableProductSet_579672(
    name: "androidenterpriseUsersSetAvailableProductSet",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersSetAvailableProductSet_579673,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersSetAvailableProductSet_579674,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGetAvailableProductSet_579656 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersGetAvailableProductSet_579658(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/availableProductSet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGetAvailableProductSet_579657(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579659 = path.getOrDefault("enterpriseId")
  valid_579659 = validateParameter(valid_579659, JString, required = true,
                                 default = nil)
  if valid_579659 != nil:
    section.add "enterpriseId", valid_579659
  var valid_579660 = path.getOrDefault("userId")
  valid_579660 = validateParameter(valid_579660, JString, required = true,
                                 default = nil)
  if valid_579660 != nil:
    section.add "userId", valid_579660
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579661 = query.getOrDefault("key")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "key", valid_579661
  var valid_579662 = query.getOrDefault("prettyPrint")
  valid_579662 = validateParameter(valid_579662, JBool, required = false,
                                 default = newJBool(true))
  if valid_579662 != nil:
    section.add "prettyPrint", valid_579662
  var valid_579663 = query.getOrDefault("oauth_token")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "oauth_token", valid_579663
  var valid_579664 = query.getOrDefault("alt")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = newJString("json"))
  if valid_579664 != nil:
    section.add "alt", valid_579664
  var valid_579665 = query.getOrDefault("userIp")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "userIp", valid_579665
  var valid_579666 = query.getOrDefault("quotaUser")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "quotaUser", valid_579666
  var valid_579667 = query.getOrDefault("fields")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "fields", valid_579667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579668: Call_AndroidenterpriseUsersGetAvailableProductSet_579656;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  let valid = call_579668.validator(path, query, header, formData, body)
  let scheme = call_579668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579668.url(scheme.get, call_579668.host, call_579668.base,
                         call_579668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579668, url, valid)

proc call*(call_579669: Call_AndroidenterpriseUsersGetAvailableProductSet_579656;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersGetAvailableProductSet
  ## Retrieves the set of products a user is entitled to access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579670 = newJObject()
  var query_579671 = newJObject()
  add(query_579671, "key", newJString(key))
  add(query_579671, "prettyPrint", newJBool(prettyPrint))
  add(query_579671, "oauth_token", newJString(oauthToken))
  add(query_579671, "alt", newJString(alt))
  add(query_579671, "userIp", newJString(userIp))
  add(query_579671, "quotaUser", newJString(quotaUser))
  add(path_579670, "enterpriseId", newJString(enterpriseId))
  add(path_579670, "userId", newJString(userId))
  add(query_579671, "fields", newJString(fields))
  result = call_579669.call(path_579670, query_579671, nil, nil, nil)

var androidenterpriseUsersGetAvailableProductSet* = Call_AndroidenterpriseUsersGetAvailableProductSet_579656(
    name: "androidenterpriseUsersGetAvailableProductSet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersGetAvailableProductSet_579657,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGetAvailableProductSet_579658,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeDeviceAccess_579690 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersRevokeDeviceAccess_579692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/deviceAccess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersRevokeDeviceAccess_579691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579693 = path.getOrDefault("enterpriseId")
  valid_579693 = validateParameter(valid_579693, JString, required = true,
                                 default = nil)
  if valid_579693 != nil:
    section.add "enterpriseId", valid_579693
  var valid_579694 = path.getOrDefault("userId")
  valid_579694 = validateParameter(valid_579694, JString, required = true,
                                 default = nil)
  if valid_579694 != nil:
    section.add "userId", valid_579694
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579695 = query.getOrDefault("key")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "key", valid_579695
  var valid_579696 = query.getOrDefault("prettyPrint")
  valid_579696 = validateParameter(valid_579696, JBool, required = false,
                                 default = newJBool(true))
  if valid_579696 != nil:
    section.add "prettyPrint", valid_579696
  var valid_579697 = query.getOrDefault("oauth_token")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "oauth_token", valid_579697
  var valid_579698 = query.getOrDefault("alt")
  valid_579698 = validateParameter(valid_579698, JString, required = false,
                                 default = newJString("json"))
  if valid_579698 != nil:
    section.add "alt", valid_579698
  var valid_579699 = query.getOrDefault("userIp")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = nil)
  if valid_579699 != nil:
    section.add "userIp", valid_579699
  var valid_579700 = query.getOrDefault("quotaUser")
  valid_579700 = validateParameter(valid_579700, JString, required = false,
                                 default = nil)
  if valid_579700 != nil:
    section.add "quotaUser", valid_579700
  var valid_579701 = query.getOrDefault("fields")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "fields", valid_579701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579702: Call_AndroidenterpriseUsersRevokeDeviceAccess_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_579702.validator(path, query, header, formData, body)
  let scheme = call_579702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579702.url(scheme.get, call_579702.host, call_579702.base,
                         call_579702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579702, url, valid)

proc call*(call_579703: Call_AndroidenterpriseUsersRevokeDeviceAccess_579690;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersRevokeDeviceAccess
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579704 = newJObject()
  var query_579705 = newJObject()
  add(query_579705, "key", newJString(key))
  add(query_579705, "prettyPrint", newJBool(prettyPrint))
  add(query_579705, "oauth_token", newJString(oauthToken))
  add(query_579705, "alt", newJString(alt))
  add(query_579705, "userIp", newJString(userIp))
  add(query_579705, "quotaUser", newJString(quotaUser))
  add(path_579704, "enterpriseId", newJString(enterpriseId))
  add(path_579704, "userId", newJString(userId))
  add(query_579705, "fields", newJString(fields))
  result = call_579703.call(path_579704, query_579705, nil, nil, nil)

var androidenterpriseUsersRevokeDeviceAccess* = Call_AndroidenterpriseUsersRevokeDeviceAccess_579690(
    name: "androidenterpriseUsersRevokeDeviceAccess", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/deviceAccess",
    validator: validate_AndroidenterpriseUsersRevokeDeviceAccess_579691,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersRevokeDeviceAccess_579692,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesList_579706 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesList_579708(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesList_579707(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579709 = path.getOrDefault("enterpriseId")
  valid_579709 = validateParameter(valid_579709, JString, required = true,
                                 default = nil)
  if valid_579709 != nil:
    section.add "enterpriseId", valid_579709
  var valid_579710 = path.getOrDefault("userId")
  valid_579710 = validateParameter(valid_579710, JString, required = true,
                                 default = nil)
  if valid_579710 != nil:
    section.add "userId", valid_579710
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579711 = query.getOrDefault("key")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "key", valid_579711
  var valid_579712 = query.getOrDefault("prettyPrint")
  valid_579712 = validateParameter(valid_579712, JBool, required = false,
                                 default = newJBool(true))
  if valid_579712 != nil:
    section.add "prettyPrint", valid_579712
  var valid_579713 = query.getOrDefault("oauth_token")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "oauth_token", valid_579713
  var valid_579714 = query.getOrDefault("alt")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = newJString("json"))
  if valid_579714 != nil:
    section.add "alt", valid_579714
  var valid_579715 = query.getOrDefault("userIp")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = nil)
  if valid_579715 != nil:
    section.add "userIp", valid_579715
  var valid_579716 = query.getOrDefault("quotaUser")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "quotaUser", valid_579716
  var valid_579717 = query.getOrDefault("fields")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "fields", valid_579717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579718: Call_AndroidenterpriseDevicesList_579706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  let valid = call_579718.validator(path, query, header, formData, body)
  let scheme = call_579718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579718.url(scheme.get, call_579718.host, call_579718.base,
                         call_579718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579718, url, valid)

proc call*(call_579719: Call_AndroidenterpriseDevicesList_579706;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseDevicesList
  ## Retrieves the IDs of all of a user's devices.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579720 = newJObject()
  var query_579721 = newJObject()
  add(query_579721, "key", newJString(key))
  add(query_579721, "prettyPrint", newJBool(prettyPrint))
  add(query_579721, "oauth_token", newJString(oauthToken))
  add(query_579721, "alt", newJString(alt))
  add(query_579721, "userIp", newJString(userIp))
  add(query_579721, "quotaUser", newJString(quotaUser))
  add(path_579720, "enterpriseId", newJString(enterpriseId))
  add(path_579720, "userId", newJString(userId))
  add(query_579721, "fields", newJString(fields))
  result = call_579719.call(path_579720, query_579721, nil, nil, nil)

var androidenterpriseDevicesList* = Call_AndroidenterpriseDevicesList_579706(
    name: "androidenterpriseDevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices",
    validator: validate_AndroidenterpriseDevicesList_579707,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesList_579708,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesUpdate_579739 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesUpdate_579741(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesUpdate_579740(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the device policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579742 = path.getOrDefault("enterpriseId")
  valid_579742 = validateParameter(valid_579742, JString, required = true,
                                 default = nil)
  if valid_579742 != nil:
    section.add "enterpriseId", valid_579742
  var valid_579743 = path.getOrDefault("userId")
  valid_579743 = validateParameter(valid_579743, JString, required = true,
                                 default = nil)
  if valid_579743 != nil:
    section.add "userId", valid_579743
  var valid_579744 = path.getOrDefault("deviceId")
  valid_579744 = validateParameter(valid_579744, JString, required = true,
                                 default = nil)
  if valid_579744 != nil:
    section.add "deviceId", valid_579744
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   updateMask: JString
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579745 = query.getOrDefault("key")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "key", valid_579745
  var valid_579746 = query.getOrDefault("prettyPrint")
  valid_579746 = validateParameter(valid_579746, JBool, required = false,
                                 default = newJBool(true))
  if valid_579746 != nil:
    section.add "prettyPrint", valid_579746
  var valid_579747 = query.getOrDefault("oauth_token")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = nil)
  if valid_579747 != nil:
    section.add "oauth_token", valid_579747
  var valid_579748 = query.getOrDefault("alt")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = newJString("json"))
  if valid_579748 != nil:
    section.add "alt", valid_579748
  var valid_579749 = query.getOrDefault("userIp")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "userIp", valid_579749
  var valid_579750 = query.getOrDefault("quotaUser")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "quotaUser", valid_579750
  var valid_579751 = query.getOrDefault("updateMask")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "updateMask", valid_579751
  var valid_579752 = query.getOrDefault("fields")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "fields", valid_579752
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

proc call*(call_579754: Call_AndroidenterpriseDevicesUpdate_579739; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy
  ## 
  let valid = call_579754.validator(path, query, header, formData, body)
  let scheme = call_579754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579754.url(scheme.get, call_579754.host, call_579754.base,
                         call_579754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579754, url, valid)

proc call*(call_579755: Call_AndroidenterpriseDevicesUpdate_579739;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseDevicesUpdate
  ## Updates the device policy
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   updateMask: string
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_579756 = newJObject()
  var query_579757 = newJObject()
  var body_579758 = newJObject()
  add(query_579757, "key", newJString(key))
  add(query_579757, "prettyPrint", newJBool(prettyPrint))
  add(query_579757, "oauth_token", newJString(oauthToken))
  add(query_579757, "alt", newJString(alt))
  add(query_579757, "userIp", newJString(userIp))
  add(query_579757, "quotaUser", newJString(quotaUser))
  add(query_579757, "updateMask", newJString(updateMask))
  add(path_579756, "enterpriseId", newJString(enterpriseId))
  add(path_579756, "userId", newJString(userId))
  if body != nil:
    body_579758 = body
  add(query_579757, "fields", newJString(fields))
  add(path_579756, "deviceId", newJString(deviceId))
  result = call_579755.call(path_579756, query_579757, nil, nil, body_579758)

var androidenterpriseDevicesUpdate* = Call_AndroidenterpriseDevicesUpdate_579739(
    name: "androidenterpriseDevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesUpdate_579740,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesUpdate_579741,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGet_579722 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesGet_579724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesGet_579723(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579725 = path.getOrDefault("enterpriseId")
  valid_579725 = validateParameter(valid_579725, JString, required = true,
                                 default = nil)
  if valid_579725 != nil:
    section.add "enterpriseId", valid_579725
  var valid_579726 = path.getOrDefault("userId")
  valid_579726 = validateParameter(valid_579726, JString, required = true,
                                 default = nil)
  if valid_579726 != nil:
    section.add "userId", valid_579726
  var valid_579727 = path.getOrDefault("deviceId")
  valid_579727 = validateParameter(valid_579727, JString, required = true,
                                 default = nil)
  if valid_579727 != nil:
    section.add "deviceId", valid_579727
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579728 = query.getOrDefault("key")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "key", valid_579728
  var valid_579729 = query.getOrDefault("prettyPrint")
  valid_579729 = validateParameter(valid_579729, JBool, required = false,
                                 default = newJBool(true))
  if valid_579729 != nil:
    section.add "prettyPrint", valid_579729
  var valid_579730 = query.getOrDefault("oauth_token")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "oauth_token", valid_579730
  var valid_579731 = query.getOrDefault("alt")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = newJString("json"))
  if valid_579731 != nil:
    section.add "alt", valid_579731
  var valid_579732 = query.getOrDefault("userIp")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "userIp", valid_579732
  var valid_579733 = query.getOrDefault("quotaUser")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "quotaUser", valid_579733
  var valid_579734 = query.getOrDefault("fields")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "fields", valid_579734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579735: Call_AndroidenterpriseDevicesGet_579722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a device.
  ## 
  let valid = call_579735.validator(path, query, header, formData, body)
  let scheme = call_579735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579735.url(scheme.get, call_579735.host, call_579735.base,
                         call_579735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579735, url, valid)

proc call*(call_579736: Call_AndroidenterpriseDevicesGet_579722;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseDevicesGet
  ## Retrieves the details of a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_579737 = newJObject()
  var query_579738 = newJObject()
  add(query_579738, "key", newJString(key))
  add(query_579738, "prettyPrint", newJBool(prettyPrint))
  add(query_579738, "oauth_token", newJString(oauthToken))
  add(query_579738, "alt", newJString(alt))
  add(query_579738, "userIp", newJString(userIp))
  add(query_579738, "quotaUser", newJString(quotaUser))
  add(path_579737, "enterpriseId", newJString(enterpriseId))
  add(path_579737, "userId", newJString(userId))
  add(query_579738, "fields", newJString(fields))
  add(path_579737, "deviceId", newJString(deviceId))
  result = call_579736.call(path_579737, query_579738, nil, nil, nil)

var androidenterpriseDevicesGet* = Call_AndroidenterpriseDevicesGet_579722(
    name: "androidenterpriseDevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesGet_579723,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGet_579724,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesPatch_579759 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesPatch_579761(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesPatch_579760(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579762 = path.getOrDefault("enterpriseId")
  valid_579762 = validateParameter(valid_579762, JString, required = true,
                                 default = nil)
  if valid_579762 != nil:
    section.add "enterpriseId", valid_579762
  var valid_579763 = path.getOrDefault("userId")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "userId", valid_579763
  var valid_579764 = path.getOrDefault("deviceId")
  valid_579764 = validateParameter(valid_579764, JString, required = true,
                                 default = nil)
  if valid_579764 != nil:
    section.add "deviceId", valid_579764
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   updateMask: JString
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579765 = query.getOrDefault("key")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "key", valid_579765
  var valid_579766 = query.getOrDefault("prettyPrint")
  valid_579766 = validateParameter(valid_579766, JBool, required = false,
                                 default = newJBool(true))
  if valid_579766 != nil:
    section.add "prettyPrint", valid_579766
  var valid_579767 = query.getOrDefault("oauth_token")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "oauth_token", valid_579767
  var valid_579768 = query.getOrDefault("alt")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = newJString("json"))
  if valid_579768 != nil:
    section.add "alt", valid_579768
  var valid_579769 = query.getOrDefault("userIp")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "userIp", valid_579769
  var valid_579770 = query.getOrDefault("quotaUser")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "quotaUser", valid_579770
  var valid_579771 = query.getOrDefault("updateMask")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "updateMask", valid_579771
  var valid_579772 = query.getOrDefault("fields")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "fields", valid_579772
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

proc call*(call_579774: Call_AndroidenterpriseDevicesPatch_579759; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  let valid = call_579774.validator(path, query, header, formData, body)
  let scheme = call_579774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579774.url(scheme.get, call_579774.host, call_579774.base,
                         call_579774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579774, url, valid)

proc call*(call_579775: Call_AndroidenterpriseDevicesPatch_579759;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseDevicesPatch
  ## Updates the device policy. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   updateMask: string
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_579776 = newJObject()
  var query_579777 = newJObject()
  var body_579778 = newJObject()
  add(query_579777, "key", newJString(key))
  add(query_579777, "prettyPrint", newJBool(prettyPrint))
  add(query_579777, "oauth_token", newJString(oauthToken))
  add(query_579777, "alt", newJString(alt))
  add(query_579777, "userIp", newJString(userIp))
  add(query_579777, "quotaUser", newJString(quotaUser))
  add(query_579777, "updateMask", newJString(updateMask))
  add(path_579776, "enterpriseId", newJString(enterpriseId))
  add(path_579776, "userId", newJString(userId))
  if body != nil:
    body_579778 = body
  add(query_579777, "fields", newJString(fields))
  add(path_579776, "deviceId", newJString(deviceId))
  result = call_579775.call(path_579776, query_579777, nil, nil, body_579778)

var androidenterpriseDevicesPatch* = Call_AndroidenterpriseDevicesPatch_579759(
    name: "androidenterpriseDevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesPatch_579760,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesPatch_579761,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesForceReportUpload_579779 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesForceReportUpload_579781(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/forceReportUpload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesForceReportUpload_579780(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579782 = path.getOrDefault("enterpriseId")
  valid_579782 = validateParameter(valid_579782, JString, required = true,
                                 default = nil)
  if valid_579782 != nil:
    section.add "enterpriseId", valid_579782
  var valid_579783 = path.getOrDefault("userId")
  valid_579783 = validateParameter(valid_579783, JString, required = true,
                                 default = nil)
  if valid_579783 != nil:
    section.add "userId", valid_579783
  var valid_579784 = path.getOrDefault("deviceId")
  valid_579784 = validateParameter(valid_579784, JString, required = true,
                                 default = nil)
  if valid_579784 != nil:
    section.add "deviceId", valid_579784
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579785 = query.getOrDefault("key")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "key", valid_579785
  var valid_579786 = query.getOrDefault("prettyPrint")
  valid_579786 = validateParameter(valid_579786, JBool, required = false,
                                 default = newJBool(true))
  if valid_579786 != nil:
    section.add "prettyPrint", valid_579786
  var valid_579787 = query.getOrDefault("oauth_token")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "oauth_token", valid_579787
  var valid_579788 = query.getOrDefault("alt")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = newJString("json"))
  if valid_579788 != nil:
    section.add "alt", valid_579788
  var valid_579789 = query.getOrDefault("userIp")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "userIp", valid_579789
  var valid_579790 = query.getOrDefault("quotaUser")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "quotaUser", valid_579790
  var valid_579791 = query.getOrDefault("fields")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "fields", valid_579791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579792: Call_AndroidenterpriseDevicesForceReportUpload_579779;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  let valid = call_579792.validator(path, query, header, formData, body)
  let scheme = call_579792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579792.url(scheme.get, call_579792.host, call_579792.base,
                         call_579792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579792, url, valid)

proc call*(call_579793: Call_AndroidenterpriseDevicesForceReportUpload_579779;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseDevicesForceReportUpload
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_579794 = newJObject()
  var query_579795 = newJObject()
  add(query_579795, "key", newJString(key))
  add(query_579795, "prettyPrint", newJBool(prettyPrint))
  add(query_579795, "oauth_token", newJString(oauthToken))
  add(query_579795, "alt", newJString(alt))
  add(query_579795, "userIp", newJString(userIp))
  add(query_579795, "quotaUser", newJString(quotaUser))
  add(path_579794, "enterpriseId", newJString(enterpriseId))
  add(path_579794, "userId", newJString(userId))
  add(query_579795, "fields", newJString(fields))
  add(path_579794, "deviceId", newJString(deviceId))
  result = call_579793.call(path_579794, query_579795, nil, nil, nil)

var androidenterpriseDevicesForceReportUpload* = Call_AndroidenterpriseDevicesForceReportUpload_579779(
    name: "androidenterpriseDevicesForceReportUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/forceReportUpload",
    validator: validate_AndroidenterpriseDevicesForceReportUpload_579780,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseDevicesForceReportUpload_579781,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsList_579796 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseInstallsList_579798(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsList_579797(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579799 = path.getOrDefault("enterpriseId")
  valid_579799 = validateParameter(valid_579799, JString, required = true,
                                 default = nil)
  if valid_579799 != nil:
    section.add "enterpriseId", valid_579799
  var valid_579800 = path.getOrDefault("userId")
  valid_579800 = validateParameter(valid_579800, JString, required = true,
                                 default = nil)
  if valid_579800 != nil:
    section.add "userId", valid_579800
  var valid_579801 = path.getOrDefault("deviceId")
  valid_579801 = validateParameter(valid_579801, JString, required = true,
                                 default = nil)
  if valid_579801 != nil:
    section.add "deviceId", valid_579801
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579802 = query.getOrDefault("key")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "key", valid_579802
  var valid_579803 = query.getOrDefault("prettyPrint")
  valid_579803 = validateParameter(valid_579803, JBool, required = false,
                                 default = newJBool(true))
  if valid_579803 != nil:
    section.add "prettyPrint", valid_579803
  var valid_579804 = query.getOrDefault("oauth_token")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "oauth_token", valid_579804
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("userIp")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "userIp", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579808 = query.getOrDefault("fields")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "fields", valid_579808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579809: Call_AndroidenterpriseInstallsList_579796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  let valid = call_579809.validator(path, query, header, formData, body)
  let scheme = call_579809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579809.url(scheme.get, call_579809.host, call_579809.base,
                         call_579809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579809, url, valid)

proc call*(call_579810: Call_AndroidenterpriseInstallsList_579796;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseInstallsList
  ## Retrieves the details of all apps installed on the specified device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579811 = newJObject()
  var query_579812 = newJObject()
  add(query_579812, "key", newJString(key))
  add(query_579812, "prettyPrint", newJBool(prettyPrint))
  add(query_579812, "oauth_token", newJString(oauthToken))
  add(query_579812, "alt", newJString(alt))
  add(query_579812, "userIp", newJString(userIp))
  add(query_579812, "quotaUser", newJString(quotaUser))
  add(path_579811, "enterpriseId", newJString(enterpriseId))
  add(path_579811, "userId", newJString(userId))
  add(query_579812, "fields", newJString(fields))
  add(path_579811, "deviceId", newJString(deviceId))
  result = call_579810.call(path_579811, query_579812, nil, nil, nil)

var androidenterpriseInstallsList* = Call_AndroidenterpriseInstallsList_579796(
    name: "androidenterpriseInstallsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs",
    validator: validate_AndroidenterpriseInstallsList_579797,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsList_579798,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsUpdate_579831 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseInstallsUpdate_579833(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsUpdate_579832(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_579834 = path.getOrDefault("installId")
  valid_579834 = validateParameter(valid_579834, JString, required = true,
                                 default = nil)
  if valid_579834 != nil:
    section.add "installId", valid_579834
  var valid_579835 = path.getOrDefault("enterpriseId")
  valid_579835 = validateParameter(valid_579835, JString, required = true,
                                 default = nil)
  if valid_579835 != nil:
    section.add "enterpriseId", valid_579835
  var valid_579836 = path.getOrDefault("userId")
  valid_579836 = validateParameter(valid_579836, JString, required = true,
                                 default = nil)
  if valid_579836 != nil:
    section.add "userId", valid_579836
  var valid_579837 = path.getOrDefault("deviceId")
  valid_579837 = validateParameter(valid_579837, JString, required = true,
                                 default = nil)
  if valid_579837 != nil:
    section.add "deviceId", valid_579837
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579838 = query.getOrDefault("key")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "key", valid_579838
  var valid_579839 = query.getOrDefault("prettyPrint")
  valid_579839 = validateParameter(valid_579839, JBool, required = false,
                                 default = newJBool(true))
  if valid_579839 != nil:
    section.add "prettyPrint", valid_579839
  var valid_579840 = query.getOrDefault("oauth_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "oauth_token", valid_579840
  var valid_579841 = query.getOrDefault("alt")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("json"))
  if valid_579841 != nil:
    section.add "alt", valid_579841
  var valid_579842 = query.getOrDefault("userIp")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "userIp", valid_579842
  var valid_579843 = query.getOrDefault("quotaUser")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "quotaUser", valid_579843
  var valid_579844 = query.getOrDefault("fields")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "fields", valid_579844
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

proc call*(call_579846: Call_AndroidenterpriseInstallsUpdate_579831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  let valid = call_579846.validator(path, query, header, formData, body)
  let scheme = call_579846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579846.url(scheme.get, call_579846.host, call_579846.base,
                         call_579846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579846, url, valid)

proc call*(call_579847: Call_AndroidenterpriseInstallsUpdate_579831;
          installId: string; enterpriseId: string; userId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseInstallsUpdate
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579848 = newJObject()
  var query_579849 = newJObject()
  var body_579850 = newJObject()
  add(query_579849, "key", newJString(key))
  add(query_579849, "prettyPrint", newJBool(prettyPrint))
  add(query_579849, "oauth_token", newJString(oauthToken))
  add(path_579848, "installId", newJString(installId))
  add(query_579849, "alt", newJString(alt))
  add(query_579849, "userIp", newJString(userIp))
  add(query_579849, "quotaUser", newJString(quotaUser))
  add(path_579848, "enterpriseId", newJString(enterpriseId))
  add(path_579848, "userId", newJString(userId))
  if body != nil:
    body_579850 = body
  add(query_579849, "fields", newJString(fields))
  add(path_579848, "deviceId", newJString(deviceId))
  result = call_579847.call(path_579848, query_579849, nil, nil, body_579850)

var androidenterpriseInstallsUpdate* = Call_AndroidenterpriseInstallsUpdate_579831(
    name: "androidenterpriseInstallsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsUpdate_579832,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsUpdate_579833,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsGet_579813 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseInstallsGet_579815(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsGet_579814(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an installation of an app on a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_579816 = path.getOrDefault("installId")
  valid_579816 = validateParameter(valid_579816, JString, required = true,
                                 default = nil)
  if valid_579816 != nil:
    section.add "installId", valid_579816
  var valid_579817 = path.getOrDefault("enterpriseId")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "enterpriseId", valid_579817
  var valid_579818 = path.getOrDefault("userId")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "userId", valid_579818
  var valid_579819 = path.getOrDefault("deviceId")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "deviceId", valid_579819
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579820 = query.getOrDefault("key")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "key", valid_579820
  var valid_579821 = query.getOrDefault("prettyPrint")
  valid_579821 = validateParameter(valid_579821, JBool, required = false,
                                 default = newJBool(true))
  if valid_579821 != nil:
    section.add "prettyPrint", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("quotaUser")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "quotaUser", valid_579825
  var valid_579826 = query.getOrDefault("fields")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "fields", valid_579826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579827: Call_AndroidenterpriseInstallsGet_579813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of an installation of an app on a device.
  ## 
  let valid = call_579827.validator(path, query, header, formData, body)
  let scheme = call_579827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579827.url(scheme.get, call_579827.host, call_579827.base,
                         call_579827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579827, url, valid)

proc call*(call_579828: Call_AndroidenterpriseInstallsGet_579813;
          installId: string; enterpriseId: string; userId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseInstallsGet
  ## Retrieves details of an installation of an app on a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579829 = newJObject()
  var query_579830 = newJObject()
  add(query_579830, "key", newJString(key))
  add(query_579830, "prettyPrint", newJBool(prettyPrint))
  add(query_579830, "oauth_token", newJString(oauthToken))
  add(path_579829, "installId", newJString(installId))
  add(query_579830, "alt", newJString(alt))
  add(query_579830, "userIp", newJString(userIp))
  add(query_579830, "quotaUser", newJString(quotaUser))
  add(path_579829, "enterpriseId", newJString(enterpriseId))
  add(path_579829, "userId", newJString(userId))
  add(query_579830, "fields", newJString(fields))
  add(path_579829, "deviceId", newJString(deviceId))
  result = call_579828.call(path_579829, query_579830, nil, nil, nil)

var androidenterpriseInstallsGet* = Call_AndroidenterpriseInstallsGet_579813(
    name: "androidenterpriseInstallsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsGet_579814,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsGet_579815,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsPatch_579869 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseInstallsPatch_579871(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsPatch_579870(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_579872 = path.getOrDefault("installId")
  valid_579872 = validateParameter(valid_579872, JString, required = true,
                                 default = nil)
  if valid_579872 != nil:
    section.add "installId", valid_579872
  var valid_579873 = path.getOrDefault("enterpriseId")
  valid_579873 = validateParameter(valid_579873, JString, required = true,
                                 default = nil)
  if valid_579873 != nil:
    section.add "enterpriseId", valid_579873
  var valid_579874 = path.getOrDefault("userId")
  valid_579874 = validateParameter(valid_579874, JString, required = true,
                                 default = nil)
  if valid_579874 != nil:
    section.add "userId", valid_579874
  var valid_579875 = path.getOrDefault("deviceId")
  valid_579875 = validateParameter(valid_579875, JString, required = true,
                                 default = nil)
  if valid_579875 != nil:
    section.add "deviceId", valid_579875
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579876 = query.getOrDefault("key")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "key", valid_579876
  var valid_579877 = query.getOrDefault("prettyPrint")
  valid_579877 = validateParameter(valid_579877, JBool, required = false,
                                 default = newJBool(true))
  if valid_579877 != nil:
    section.add "prettyPrint", valid_579877
  var valid_579878 = query.getOrDefault("oauth_token")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = nil)
  if valid_579878 != nil:
    section.add "oauth_token", valid_579878
  var valid_579879 = query.getOrDefault("alt")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = newJString("json"))
  if valid_579879 != nil:
    section.add "alt", valid_579879
  var valid_579880 = query.getOrDefault("userIp")
  valid_579880 = validateParameter(valid_579880, JString, required = false,
                                 default = nil)
  if valid_579880 != nil:
    section.add "userIp", valid_579880
  var valid_579881 = query.getOrDefault("quotaUser")
  valid_579881 = validateParameter(valid_579881, JString, required = false,
                                 default = nil)
  if valid_579881 != nil:
    section.add "quotaUser", valid_579881
  var valid_579882 = query.getOrDefault("fields")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = nil)
  if valid_579882 != nil:
    section.add "fields", valid_579882
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

proc call*(call_579884: Call_AndroidenterpriseInstallsPatch_579869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  let valid = call_579884.validator(path, query, header, formData, body)
  let scheme = call_579884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579884.url(scheme.get, call_579884.host, call_579884.base,
                         call_579884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579884, url, valid)

proc call*(call_579885: Call_AndroidenterpriseInstallsPatch_579869;
          installId: string; enterpriseId: string; userId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseInstallsPatch
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579886 = newJObject()
  var query_579887 = newJObject()
  var body_579888 = newJObject()
  add(query_579887, "key", newJString(key))
  add(query_579887, "prettyPrint", newJBool(prettyPrint))
  add(query_579887, "oauth_token", newJString(oauthToken))
  add(path_579886, "installId", newJString(installId))
  add(query_579887, "alt", newJString(alt))
  add(query_579887, "userIp", newJString(userIp))
  add(query_579887, "quotaUser", newJString(quotaUser))
  add(path_579886, "enterpriseId", newJString(enterpriseId))
  add(path_579886, "userId", newJString(userId))
  if body != nil:
    body_579888 = body
  add(query_579887, "fields", newJString(fields))
  add(path_579886, "deviceId", newJString(deviceId))
  result = call_579885.call(path_579886, query_579887, nil, nil, body_579888)

var androidenterpriseInstallsPatch* = Call_AndroidenterpriseInstallsPatch_579869(
    name: "androidenterpriseInstallsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsPatch_579870,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsPatch_579871,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsDelete_579851 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseInstallsDelete_579853(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsDelete_579852(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_579854 = path.getOrDefault("installId")
  valid_579854 = validateParameter(valid_579854, JString, required = true,
                                 default = nil)
  if valid_579854 != nil:
    section.add "installId", valid_579854
  var valid_579855 = path.getOrDefault("enterpriseId")
  valid_579855 = validateParameter(valid_579855, JString, required = true,
                                 default = nil)
  if valid_579855 != nil:
    section.add "enterpriseId", valid_579855
  var valid_579856 = path.getOrDefault("userId")
  valid_579856 = validateParameter(valid_579856, JString, required = true,
                                 default = nil)
  if valid_579856 != nil:
    section.add "userId", valid_579856
  var valid_579857 = path.getOrDefault("deviceId")
  valid_579857 = validateParameter(valid_579857, JString, required = true,
                                 default = nil)
  if valid_579857 != nil:
    section.add "deviceId", valid_579857
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579858 = query.getOrDefault("key")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "key", valid_579858
  var valid_579859 = query.getOrDefault("prettyPrint")
  valid_579859 = validateParameter(valid_579859, JBool, required = false,
                                 default = newJBool(true))
  if valid_579859 != nil:
    section.add "prettyPrint", valid_579859
  var valid_579860 = query.getOrDefault("oauth_token")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = nil)
  if valid_579860 != nil:
    section.add "oauth_token", valid_579860
  var valid_579861 = query.getOrDefault("alt")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = newJString("json"))
  if valid_579861 != nil:
    section.add "alt", valid_579861
  var valid_579862 = query.getOrDefault("userIp")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "userIp", valid_579862
  var valid_579863 = query.getOrDefault("quotaUser")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "quotaUser", valid_579863
  var valid_579864 = query.getOrDefault("fields")
  valid_579864 = validateParameter(valid_579864, JString, required = false,
                                 default = nil)
  if valid_579864 != nil:
    section.add "fields", valid_579864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_AndroidenterpriseInstallsDelete_579851;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579866: Call_AndroidenterpriseInstallsDelete_579851;
          installId: string; enterpriseId: string; userId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseInstallsDelete
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579867 = newJObject()
  var query_579868 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(path_579867, "installId", newJString(installId))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "userIp", newJString(userIp))
  add(query_579868, "quotaUser", newJString(quotaUser))
  add(path_579867, "enterpriseId", newJString(enterpriseId))
  add(path_579867, "userId", newJString(userId))
  add(query_579868, "fields", newJString(fields))
  add(path_579867, "deviceId", newJString(deviceId))
  result = call_579866.call(path_579867, query_579868, nil, nil, nil)

var androidenterpriseInstallsDelete* = Call_AndroidenterpriseInstallsDelete_579851(
    name: "androidenterpriseInstallsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsDelete_579852,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsDelete_579853,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceList_579889 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsfordeviceList_579891(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceList_579890(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579892 = path.getOrDefault("enterpriseId")
  valid_579892 = validateParameter(valid_579892, JString, required = true,
                                 default = nil)
  if valid_579892 != nil:
    section.add "enterpriseId", valid_579892
  var valid_579893 = path.getOrDefault("userId")
  valid_579893 = validateParameter(valid_579893, JString, required = true,
                                 default = nil)
  if valid_579893 != nil:
    section.add "userId", valid_579893
  var valid_579894 = path.getOrDefault("deviceId")
  valid_579894 = validateParameter(valid_579894, JString, required = true,
                                 default = nil)
  if valid_579894 != nil:
    section.add "deviceId", valid_579894
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579895 = query.getOrDefault("key")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "key", valid_579895
  var valid_579896 = query.getOrDefault("prettyPrint")
  valid_579896 = validateParameter(valid_579896, JBool, required = false,
                                 default = newJBool(true))
  if valid_579896 != nil:
    section.add "prettyPrint", valid_579896
  var valid_579897 = query.getOrDefault("oauth_token")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "oauth_token", valid_579897
  var valid_579898 = query.getOrDefault("alt")
  valid_579898 = validateParameter(valid_579898, JString, required = false,
                                 default = newJString("json"))
  if valid_579898 != nil:
    section.add "alt", valid_579898
  var valid_579899 = query.getOrDefault("userIp")
  valid_579899 = validateParameter(valid_579899, JString, required = false,
                                 default = nil)
  if valid_579899 != nil:
    section.add "userIp", valid_579899
  var valid_579900 = query.getOrDefault("quotaUser")
  valid_579900 = validateParameter(valid_579900, JString, required = false,
                                 default = nil)
  if valid_579900 != nil:
    section.add "quotaUser", valid_579900
  var valid_579901 = query.getOrDefault("fields")
  valid_579901 = validateParameter(valid_579901, JString, required = false,
                                 default = nil)
  if valid_579901 != nil:
    section.add "fields", valid_579901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579902: Call_AndroidenterpriseManagedconfigurationsfordeviceList_579889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  let valid = call_579902.validator(path, query, header, formData, body)
  let scheme = call_579902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579902.url(scheme.get, call_579902.host, call_579902.base,
                         call_579902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579902, url, valid)

proc call*(call_579903: Call_AndroidenterpriseManagedconfigurationsfordeviceList_579889;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceList
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579904 = newJObject()
  var query_579905 = newJObject()
  add(query_579905, "key", newJString(key))
  add(query_579905, "prettyPrint", newJBool(prettyPrint))
  add(query_579905, "oauth_token", newJString(oauthToken))
  add(query_579905, "alt", newJString(alt))
  add(query_579905, "userIp", newJString(userIp))
  add(query_579905, "quotaUser", newJString(quotaUser))
  add(path_579904, "enterpriseId", newJString(enterpriseId))
  add(path_579904, "userId", newJString(userId))
  add(query_579905, "fields", newJString(fields))
  add(path_579904, "deviceId", newJString(deviceId))
  result = call_579903.call(path_579904, query_579905, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceList* = Call_AndroidenterpriseManagedconfigurationsfordeviceList_579889(
    name: "androidenterpriseManagedconfigurationsfordeviceList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceList_579890,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceList_579891,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579924 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579926(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579925(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579927 = path.getOrDefault("enterpriseId")
  valid_579927 = validateParameter(valid_579927, JString, required = true,
                                 default = nil)
  if valid_579927 != nil:
    section.add "enterpriseId", valid_579927
  var valid_579928 = path.getOrDefault("userId")
  valid_579928 = validateParameter(valid_579928, JString, required = true,
                                 default = nil)
  if valid_579928 != nil:
    section.add "userId", valid_579928
  var valid_579929 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_579929 = validateParameter(valid_579929, JString, required = true,
                                 default = nil)
  if valid_579929 != nil:
    section.add "managedConfigurationForDeviceId", valid_579929
  var valid_579930 = path.getOrDefault("deviceId")
  valid_579930 = validateParameter(valid_579930, JString, required = true,
                                 default = nil)
  if valid_579930 != nil:
    section.add "deviceId", valid_579930
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579931 = query.getOrDefault("key")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "key", valid_579931
  var valid_579932 = query.getOrDefault("prettyPrint")
  valid_579932 = validateParameter(valid_579932, JBool, required = false,
                                 default = newJBool(true))
  if valid_579932 != nil:
    section.add "prettyPrint", valid_579932
  var valid_579933 = query.getOrDefault("oauth_token")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "oauth_token", valid_579933
  var valid_579934 = query.getOrDefault("alt")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = newJString("json"))
  if valid_579934 != nil:
    section.add "alt", valid_579934
  var valid_579935 = query.getOrDefault("userIp")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "userIp", valid_579935
  var valid_579936 = query.getOrDefault("quotaUser")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "quotaUser", valid_579936
  var valid_579937 = query.getOrDefault("fields")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "fields", valid_579937
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

proc call*(call_579939: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579924;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_579939.validator(path, query, header, formData, body)
  let scheme = call_579939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579939.url(scheme.get, call_579939.host, call_579939.base,
                         call_579939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579939, url, valid)

proc call*(call_579940: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579924;
          enterpriseId: string; userId: string;
          managedConfigurationForDeviceId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceUpdate
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579941 = newJObject()
  var query_579942 = newJObject()
  var body_579943 = newJObject()
  add(query_579942, "key", newJString(key))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(path_579941, "enterpriseId", newJString(enterpriseId))
  add(path_579941, "userId", newJString(userId))
  add(path_579941, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  if body != nil:
    body_579943 = body
  add(query_579942, "fields", newJString(fields))
  add(path_579941, "deviceId", newJString(deviceId))
  result = call_579940.call(path_579941, query_579942, nil, nil, body_579943)

var androidenterpriseManagedconfigurationsfordeviceUpdate* = Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579924(
    name: "androidenterpriseManagedconfigurationsfordeviceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579925,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_579926,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceGet_579906 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsfordeviceGet_579908(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceGet_579907(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves details of a per-device managed configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579909 = path.getOrDefault("enterpriseId")
  valid_579909 = validateParameter(valid_579909, JString, required = true,
                                 default = nil)
  if valid_579909 != nil:
    section.add "enterpriseId", valid_579909
  var valid_579910 = path.getOrDefault("userId")
  valid_579910 = validateParameter(valid_579910, JString, required = true,
                                 default = nil)
  if valid_579910 != nil:
    section.add "userId", valid_579910
  var valid_579911 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_579911 = validateParameter(valid_579911, JString, required = true,
                                 default = nil)
  if valid_579911 != nil:
    section.add "managedConfigurationForDeviceId", valid_579911
  var valid_579912 = path.getOrDefault("deviceId")
  valid_579912 = validateParameter(valid_579912, JString, required = true,
                                 default = nil)
  if valid_579912 != nil:
    section.add "deviceId", valid_579912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579913 = query.getOrDefault("key")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "key", valid_579913
  var valid_579914 = query.getOrDefault("prettyPrint")
  valid_579914 = validateParameter(valid_579914, JBool, required = false,
                                 default = newJBool(true))
  if valid_579914 != nil:
    section.add "prettyPrint", valid_579914
  var valid_579915 = query.getOrDefault("oauth_token")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "oauth_token", valid_579915
  var valid_579916 = query.getOrDefault("alt")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = newJString("json"))
  if valid_579916 != nil:
    section.add "alt", valid_579916
  var valid_579917 = query.getOrDefault("userIp")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = nil)
  if valid_579917 != nil:
    section.add "userIp", valid_579917
  var valid_579918 = query.getOrDefault("quotaUser")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "quotaUser", valid_579918
  var valid_579919 = query.getOrDefault("fields")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "fields", valid_579919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579920: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_579906;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-device managed configuration.
  ## 
  let valid = call_579920.validator(path, query, header, formData, body)
  let scheme = call_579920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579920.url(scheme.get, call_579920.host, call_579920.base,
                         call_579920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579920, url, valid)

proc call*(call_579921: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_579906;
          enterpriseId: string; userId: string;
          managedConfigurationForDeviceId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceGet
  ## Retrieves details of a per-device managed configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579922 = newJObject()
  var query_579923 = newJObject()
  add(query_579923, "key", newJString(key))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(path_579922, "enterpriseId", newJString(enterpriseId))
  add(path_579922, "userId", newJString(userId))
  add(path_579922, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_579923, "fields", newJString(fields))
  add(path_579922, "deviceId", newJString(deviceId))
  result = call_579921.call(path_579922, query_579923, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceGet* = Call_AndroidenterpriseManagedconfigurationsfordeviceGet_579906(
    name: "androidenterpriseManagedconfigurationsfordeviceGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceGet_579907,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceGet_579908,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordevicePatch_579962 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsfordevicePatch_579964(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordevicePatch_579963(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579965 = path.getOrDefault("enterpriseId")
  valid_579965 = validateParameter(valid_579965, JString, required = true,
                                 default = nil)
  if valid_579965 != nil:
    section.add "enterpriseId", valid_579965
  var valid_579966 = path.getOrDefault("userId")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "userId", valid_579966
  var valid_579967 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_579967 = validateParameter(valid_579967, JString, required = true,
                                 default = nil)
  if valid_579967 != nil:
    section.add "managedConfigurationForDeviceId", valid_579967
  var valid_579968 = path.getOrDefault("deviceId")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "deviceId", valid_579968
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("userIp")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "userIp", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
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

proc call*(call_579977: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_579962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_579962;
          enterpriseId: string; userId: string;
          managedConfigurationForDeviceId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsfordevicePatch
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  var body_579981 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "userIp", newJString(userIp))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(path_579979, "enterpriseId", newJString(enterpriseId))
  add(path_579979, "userId", newJString(userId))
  add(path_579979, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  if body != nil:
    body_579981 = body
  add(query_579980, "fields", newJString(fields))
  add(path_579979, "deviceId", newJString(deviceId))
  result = call_579978.call(path_579979, query_579980, nil, nil, body_579981)

var androidenterpriseManagedconfigurationsfordevicePatch* = Call_AndroidenterpriseManagedconfigurationsfordevicePatch_579962(
    name: "androidenterpriseManagedconfigurationsfordevicePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordevicePatch_579963,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordevicePatch_579964,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_579944 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsfordeviceDelete_579946(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_579945(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579947 = path.getOrDefault("enterpriseId")
  valid_579947 = validateParameter(valid_579947, JString, required = true,
                                 default = nil)
  if valid_579947 != nil:
    section.add "enterpriseId", valid_579947
  var valid_579948 = path.getOrDefault("userId")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = nil)
  if valid_579948 != nil:
    section.add "userId", valid_579948
  var valid_579949 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_579949 = validateParameter(valid_579949, JString, required = true,
                                 default = nil)
  if valid_579949 != nil:
    section.add "managedConfigurationForDeviceId", valid_579949
  var valid_579950 = path.getOrDefault("deviceId")
  valid_579950 = validateParameter(valid_579950, JString, required = true,
                                 default = nil)
  if valid_579950 != nil:
    section.add "deviceId", valid_579950
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579951 = query.getOrDefault("key")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "key", valid_579951
  var valid_579952 = query.getOrDefault("prettyPrint")
  valid_579952 = validateParameter(valid_579952, JBool, required = false,
                                 default = newJBool(true))
  if valid_579952 != nil:
    section.add "prettyPrint", valid_579952
  var valid_579953 = query.getOrDefault("oauth_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "oauth_token", valid_579953
  var valid_579954 = query.getOrDefault("alt")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("json"))
  if valid_579954 != nil:
    section.add "alt", valid_579954
  var valid_579955 = query.getOrDefault("userIp")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "userIp", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("fields")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "fields", valid_579957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579958: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_579944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_579944;
          enterpriseId: string; userId: string;
          managedConfigurationForDeviceId: string; deviceId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceDelete
  ## Removes a per-device managed configuration for an app for the specified device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  var path_579960 = newJObject()
  var query_579961 = newJObject()
  add(query_579961, "key", newJString(key))
  add(query_579961, "prettyPrint", newJBool(prettyPrint))
  add(query_579961, "oauth_token", newJString(oauthToken))
  add(query_579961, "alt", newJString(alt))
  add(query_579961, "userIp", newJString(userIp))
  add(query_579961, "quotaUser", newJString(quotaUser))
  add(path_579960, "enterpriseId", newJString(enterpriseId))
  add(path_579960, "userId", newJString(userId))
  add(path_579960, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_579961, "fields", newJString(fields))
  add(path_579960, "deviceId", newJString(deviceId))
  result = call_579959.call(path_579960, query_579961, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceDelete* = Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_579944(
    name: "androidenterpriseManagedconfigurationsfordeviceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_579945,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceDelete_579946,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesSetState_579999 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesSetState_580001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/state")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesSetState_580000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580002 = path.getOrDefault("enterpriseId")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "enterpriseId", valid_580002
  var valid_580003 = path.getOrDefault("userId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "userId", valid_580003
  var valid_580004 = path.getOrDefault("deviceId")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "deviceId", valid_580004
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("prettyPrint")
  valid_580006 = validateParameter(valid_580006, JBool, required = false,
                                 default = newJBool(true))
  if valid_580006 != nil:
    section.add "prettyPrint", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("userIp")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "userIp", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
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

proc call*(call_580013: Call_AndroidenterpriseDevicesSetState_579999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_AndroidenterpriseDevicesSetState_579999;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseDevicesSetState
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  var body_580017 = newJObject()
  add(query_580016, "key", newJString(key))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(path_580015, "enterpriseId", newJString(enterpriseId))
  add(path_580015, "userId", newJString(userId))
  if body != nil:
    body_580017 = body
  add(query_580016, "fields", newJString(fields))
  add(path_580015, "deviceId", newJString(deviceId))
  result = call_580014.call(path_580015, query_580016, nil, nil, body_580017)

var androidenterpriseDevicesSetState* = Call_AndroidenterpriseDevicesSetState_579999(
    name: "androidenterpriseDevicesSetState", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesSetState_580000,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesSetState_580001,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGetState_579982 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseDevicesGetState_579984(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/state")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesGetState_579983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_579985 = path.getOrDefault("enterpriseId")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "enterpriseId", valid_579985
  var valid_579986 = path.getOrDefault("userId")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "userId", valid_579986
  var valid_579987 = path.getOrDefault("deviceId")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "deviceId", valid_579987
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("userIp")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "userIp", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579995: Call_AndroidenterpriseDevicesGetState_579982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_AndroidenterpriseDevicesGetState_579982;
          enterpriseId: string; userId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseDevicesGetState
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  add(query_579998, "key", newJString(key))
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "userIp", newJString(userIp))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(path_579997, "enterpriseId", newJString(enterpriseId))
  add(path_579997, "userId", newJString(userId))
  add(query_579998, "fields", newJString(fields))
  add(path_579997, "deviceId", newJString(deviceId))
  result = call_579996.call(path_579997, query_579998, nil, nil, nil)

var androidenterpriseDevicesGetState* = Call_AndroidenterpriseDevicesGetState_579982(
    name: "androidenterpriseDevicesGetState", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesGetState_579983,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGetState_579984,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsList_580018 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEntitlementsList_580020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsList_580019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580021 = path.getOrDefault("enterpriseId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "enterpriseId", valid_580021
  var valid_580022 = path.getOrDefault("userId")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "userId", valid_580022
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_AndroidenterpriseEntitlementsList_580018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_AndroidenterpriseEntitlementsList_580018;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseEntitlementsList
  ## Lists all entitlements for the specified user. Only the ID is set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "enterpriseId", newJString(enterpriseId))
  add(path_580032, "userId", newJString(userId))
  add(query_580033, "fields", newJString(fields))
  result = call_580031.call(path_580032, query_580033, nil, nil, nil)

var androidenterpriseEntitlementsList* = Call_AndroidenterpriseEntitlementsList_580018(
    name: "androidenterpriseEntitlementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/entitlements",
    validator: validate_AndroidenterpriseEntitlementsList_580019,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsList_580020,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsUpdate_580051 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEntitlementsUpdate_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsUpdate_580052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580054 = path.getOrDefault("enterpriseId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "enterpriseId", valid_580054
  var valid_580055 = path.getOrDefault("userId")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "userId", valid_580055
  var valid_580056 = path.getOrDefault("entitlementId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "entitlementId", valid_580056
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   install: JBool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("quotaUser")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "quotaUser", valid_580062
  var valid_580063 = query.getOrDefault("install")
  valid_580063 = validateParameter(valid_580063, JBool, required = false, default = nil)
  if valid_580063 != nil:
    section.add "install", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
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

proc call*(call_580066: Call_AndroidenterpriseEntitlementsUpdate_580051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_AndroidenterpriseEntitlementsUpdate_580051;
          enterpriseId: string; userId: string; entitlementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          install: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEntitlementsUpdate
  ## Adds or updates an entitlement to an app for a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   install: bool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  var body_580070 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "userIp", newJString(userIp))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "enterpriseId", newJString(enterpriseId))
  add(query_580069, "install", newJBool(install))
  add(path_580068, "userId", newJString(userId))
  if body != nil:
    body_580070 = body
  add(path_580068, "entitlementId", newJString(entitlementId))
  add(query_580069, "fields", newJString(fields))
  result = call_580067.call(path_580068, query_580069, nil, nil, body_580070)

var androidenterpriseEntitlementsUpdate* = Call_AndroidenterpriseEntitlementsUpdate_580051(
    name: "androidenterpriseEntitlementsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsUpdate_580052,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsUpdate_580053,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsGet_580034 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEntitlementsGet_580036(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsGet_580035(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an entitlement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580037 = path.getOrDefault("enterpriseId")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "enterpriseId", valid_580037
  var valid_580038 = path.getOrDefault("userId")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "userId", valid_580038
  var valid_580039 = path.getOrDefault("entitlementId")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "entitlementId", valid_580039
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_AndroidenterpriseEntitlementsGet_580034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an entitlement.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_AndroidenterpriseEntitlementsGet_580034;
          enterpriseId: string; userId: string; entitlementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseEntitlementsGet
  ## Retrieves details of an entitlement.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  add(query_580050, "key", newJString(key))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "userIp", newJString(userIp))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(path_580049, "enterpriseId", newJString(enterpriseId))
  add(path_580049, "userId", newJString(userId))
  add(path_580049, "entitlementId", newJString(entitlementId))
  add(query_580050, "fields", newJString(fields))
  result = call_580048.call(path_580049, query_580050, nil, nil, nil)

var androidenterpriseEntitlementsGet* = Call_AndroidenterpriseEntitlementsGet_580034(
    name: "androidenterpriseEntitlementsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsGet_580035,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsGet_580036,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsPatch_580088 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEntitlementsPatch_580090(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsPatch_580089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580091 = path.getOrDefault("enterpriseId")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "enterpriseId", valid_580091
  var valid_580092 = path.getOrDefault("userId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userId", valid_580092
  var valid_580093 = path.getOrDefault("entitlementId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "entitlementId", valid_580093
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   install: JBool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("install")
  valid_580100 = validateParameter(valid_580100, JBool, required = false, default = nil)
  if valid_580100 != nil:
    section.add "install", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
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

proc call*(call_580103: Call_AndroidenterpriseEntitlementsPatch_580088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_AndroidenterpriseEntitlementsPatch_580088;
          enterpriseId: string; userId: string; entitlementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          install: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseEntitlementsPatch
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   install: bool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(path_580105, "enterpriseId", newJString(enterpriseId))
  add(query_580106, "install", newJBool(install))
  add(path_580105, "userId", newJString(userId))
  if body != nil:
    body_580107 = body
  add(path_580105, "entitlementId", newJString(entitlementId))
  add(query_580106, "fields", newJString(fields))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var androidenterpriseEntitlementsPatch* = Call_AndroidenterpriseEntitlementsPatch_580088(
    name: "androidenterpriseEntitlementsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsPatch_580089,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsPatch_580090,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsDelete_580071 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseEntitlementsDelete_580073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsDelete_580072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an entitlement to an app for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580074 = path.getOrDefault("enterpriseId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "enterpriseId", valid_580074
  var valid_580075 = path.getOrDefault("userId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "userId", valid_580075
  var valid_580076 = path.getOrDefault("entitlementId")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "entitlementId", valid_580076
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("userIp")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userIp", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580084: Call_AndroidenterpriseEntitlementsDelete_580071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an entitlement to an app for a user.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_AndroidenterpriseEntitlementsDelete_580071;
          enterpriseId: string; userId: string; entitlementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## androidenterpriseEntitlementsDelete
  ## Removes an entitlement to an app for a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  add(query_580087, "key", newJString(key))
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "userIp", newJString(userIp))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(path_580086, "enterpriseId", newJString(enterpriseId))
  add(path_580086, "userId", newJString(userId))
  add(path_580086, "entitlementId", newJString(entitlementId))
  add(query_580087, "fields", newJString(fields))
  result = call_580085.call(path_580086, query_580087, nil, nil, nil)

var androidenterpriseEntitlementsDelete* = Call_AndroidenterpriseEntitlementsDelete_580071(
    name: "androidenterpriseEntitlementsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsDelete_580072,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsDelete_580073,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserList_580108 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsforuserList_580110(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/managedConfigurationsForUser")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserList_580109(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580111 = path.getOrDefault("enterpriseId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "enterpriseId", valid_580111
  var valid_580112 = path.getOrDefault("userId")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userId", valid_580112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("userIp")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "userIp", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580120: Call_AndroidenterpriseManagedconfigurationsforuserList_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  let valid = call_580120.validator(path, query, header, formData, body)
  let scheme = call_580120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580120.url(scheme.get, call_580120.host, call_580120.base,
                         call_580120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580120, url, valid)

proc call*(call_580121: Call_AndroidenterpriseManagedconfigurationsforuserList_580108;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsforuserList
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580122 = newJObject()
  var query_580123 = newJObject()
  add(query_580123, "key", newJString(key))
  add(query_580123, "prettyPrint", newJBool(prettyPrint))
  add(query_580123, "oauth_token", newJString(oauthToken))
  add(query_580123, "alt", newJString(alt))
  add(query_580123, "userIp", newJString(userIp))
  add(query_580123, "quotaUser", newJString(quotaUser))
  add(path_580122, "enterpriseId", newJString(enterpriseId))
  add(path_580122, "userId", newJString(userId))
  add(query_580123, "fields", newJString(fields))
  result = call_580121.call(path_580122, query_580123, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserList* = Call_AndroidenterpriseManagedconfigurationsforuserList_580108(
    name: "androidenterpriseManagedconfigurationsforuserList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserList_580109,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserList_580110,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserUpdate_580141 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsforuserUpdate_580143(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserUpdate_580142(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580144 = path.getOrDefault("enterpriseId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "enterpriseId", valid_580144
  var valid_580145 = path.getOrDefault("userId")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "userId", valid_580145
  var valid_580146 = path.getOrDefault("managedConfigurationForUserId")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "managedConfigurationForUserId", valid_580146
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("prettyPrint")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(true))
  if valid_580148 != nil:
    section.add "prettyPrint", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("userIp")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "userIp", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
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

proc call*(call_580155: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_580141;
          enterpriseId: string; userId: string;
          managedConfigurationForUserId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsforuserUpdate
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  var body_580159 = newJObject()
  add(query_580158, "key", newJString(key))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "userIp", newJString(userIp))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(path_580157, "enterpriseId", newJString(enterpriseId))
  add(path_580157, "userId", newJString(userId))
  if body != nil:
    body_580159 = body
  add(path_580157, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_580158, "fields", newJString(fields))
  result = call_580156.call(path_580157, query_580158, nil, nil, body_580159)

var androidenterpriseManagedconfigurationsforuserUpdate* = Call_AndroidenterpriseManagedconfigurationsforuserUpdate_580141(
    name: "androidenterpriseManagedconfigurationsforuserUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserUpdate_580142,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserUpdate_580143,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserGet_580124 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsforuserGet_580126(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserGet_580125(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580127 = path.getOrDefault("enterpriseId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "enterpriseId", valid_580127
  var valid_580128 = path.getOrDefault("userId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "userId", valid_580128
  var valid_580129 = path.getOrDefault("managedConfigurationForUserId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "managedConfigurationForUserId", valid_580129
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_AndroidenterpriseManagedconfigurationsforuserGet_580124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_AndroidenterpriseManagedconfigurationsforuserGet_580124;
          enterpriseId: string; userId: string;
          managedConfigurationForUserId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsforuserGet
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "key", newJString(key))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "userIp", newJString(userIp))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(path_580139, "enterpriseId", newJString(enterpriseId))
  add(path_580139, "userId", newJString(userId))
  add(path_580139, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_580140, "fields", newJString(fields))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserGet* = Call_AndroidenterpriseManagedconfigurationsforuserGet_580124(
    name: "androidenterpriseManagedconfigurationsforuserGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserGet_580125,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserGet_580126,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserPatch_580177 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsforuserPatch_580179(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserPatch_580178(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580180 = path.getOrDefault("enterpriseId")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "enterpriseId", valid_580180
  var valid_580181 = path.getOrDefault("userId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "userId", valid_580181
  var valid_580182 = path.getOrDefault("managedConfigurationForUserId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "managedConfigurationForUserId", valid_580182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("userIp")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "userIp", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
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

proc call*(call_580191: Call_AndroidenterpriseManagedconfigurationsforuserPatch_580177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_AndroidenterpriseManagedconfigurationsforuserPatch_580177;
          enterpriseId: string; userId: string;
          managedConfigurationForUserId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsforuserPatch
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   body: JObject
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(path_580193, "enterpriseId", newJString(enterpriseId))
  add(path_580193, "userId", newJString(userId))
  if body != nil:
    body_580195 = body
  add(path_580193, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_580194, "fields", newJString(fields))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var androidenterpriseManagedconfigurationsforuserPatch* = Call_AndroidenterpriseManagedconfigurationsforuserPatch_580177(
    name: "androidenterpriseManagedconfigurationsforuserPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserPatch_580178,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserPatch_580179,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserDelete_580160 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseManagedconfigurationsforuserDelete_580162(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserDelete_580161(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580163 = path.getOrDefault("enterpriseId")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "enterpriseId", valid_580163
  var valid_580164 = path.getOrDefault("userId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "userId", valid_580164
  var valid_580165 = path.getOrDefault("managedConfigurationForUserId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "managedConfigurationForUserId", valid_580165
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("userIp")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "userIp", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_AndroidenterpriseManagedconfigurationsforuserDelete_580160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_AndroidenterpriseManagedconfigurationsforuserDelete_580160;
          enterpriseId: string; userId: string;
          managedConfigurationForUserId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseManagedconfigurationsforuserDelete
  ## Removes a per-user managed configuration for an app for the specified user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "userIp", newJString(userIp))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(path_580175, "enterpriseId", newJString(enterpriseId))
  add(path_580175, "userId", newJString(userId))
  add(path_580175, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_580176, "fields", newJString(fields))
  result = call_580174.call(path_580175, query_580176, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserDelete* = Call_AndroidenterpriseManagedconfigurationsforuserDelete_580160(
    name: "androidenterpriseManagedconfigurationsforuserDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserDelete_580161,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserDelete_580162,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateToken_580196 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersGenerateToken_580198(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGenerateToken_580197(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580199 = path.getOrDefault("enterpriseId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "enterpriseId", valid_580199
  var valid_580200 = path.getOrDefault("userId")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "userId", valid_580200
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580208: Call_AndroidenterpriseUsersGenerateToken_580196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_AndroidenterpriseUsersGenerateToken_580196;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersGenerateToken
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580210 = newJObject()
  var query_580211 = newJObject()
  add(query_580211, "key", newJString(key))
  add(query_580211, "prettyPrint", newJBool(prettyPrint))
  add(query_580211, "oauth_token", newJString(oauthToken))
  add(query_580211, "alt", newJString(alt))
  add(query_580211, "userIp", newJString(userIp))
  add(query_580211, "quotaUser", newJString(quotaUser))
  add(path_580210, "enterpriseId", newJString(enterpriseId))
  add(path_580210, "userId", newJString(userId))
  add(query_580211, "fields", newJString(fields))
  result = call_580209.call(path_580210, query_580211, nil, nil, nil)

var androidenterpriseUsersGenerateToken* = Call_AndroidenterpriseUsersGenerateToken_580196(
    name: "androidenterpriseUsersGenerateToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersGenerateToken_580197,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGenerateToken_580198,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeToken_580212 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseUsersRevokeToken_580214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersRevokeToken_580213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580215 = path.getOrDefault("enterpriseId")
  valid_580215 = validateParameter(valid_580215, JString, required = true,
                                 default = nil)
  if valid_580215 != nil:
    section.add "enterpriseId", valid_580215
  var valid_580216 = path.getOrDefault("userId")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "userId", valid_580216
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("userIp")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "userIp", valid_580221
  var valid_580222 = query.getOrDefault("quotaUser")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "quotaUser", valid_580222
  var valid_580223 = query.getOrDefault("fields")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "fields", valid_580223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580224: Call_AndroidenterpriseUsersRevokeToken_580212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  let valid = call_580224.validator(path, query, header, formData, body)
  let scheme = call_580224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580224.url(scheme.get, call_580224.host, call_580224.base,
                         call_580224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580224, url, valid)

proc call*(call_580225: Call_AndroidenterpriseUsersRevokeToken_580212;
          enterpriseId: string; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseUsersRevokeToken
  ## Revokes a previously generated token (activation code) for the user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   userId: string (required)
  ##         : The ID of the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580226 = newJObject()
  var query_580227 = newJObject()
  add(query_580227, "key", newJString(key))
  add(query_580227, "prettyPrint", newJBool(prettyPrint))
  add(query_580227, "oauth_token", newJString(oauthToken))
  add(query_580227, "alt", newJString(alt))
  add(query_580227, "userIp", newJString(userIp))
  add(query_580227, "quotaUser", newJString(quotaUser))
  add(path_580226, "enterpriseId", newJString(enterpriseId))
  add(path_580226, "userId", newJString(userId))
  add(query_580227, "fields", newJString(fields))
  result = call_580225.call(path_580226, query_580227, nil, nil, nil)

var androidenterpriseUsersRevokeToken* = Call_AndroidenterpriseUsersRevokeToken_580212(
    name: "androidenterpriseUsersRevokeToken", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersRevokeToken_580213,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersRevokeToken_580214,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsInsert_580243 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsInsert_580245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsInsert_580244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new web app for the enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580246 = path.getOrDefault("enterpriseId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "enterpriseId", valid_580246
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(true))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("userIp")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "userIp", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
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

proc call*(call_580255: Call_AndroidenterpriseWebappsInsert_580243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new web app for the enterprise.
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_AndroidenterpriseWebappsInsert_580243;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## androidenterpriseWebappsInsert
  ## Creates a new web app for the enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  var body_580259 = newJObject()
  add(query_580258, "key", newJString(key))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "userIp", newJString(userIp))
  add(query_580258, "quotaUser", newJString(quotaUser))
  add(path_580257, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580259 = body
  add(query_580258, "fields", newJString(fields))
  result = call_580256.call(path_580257, query_580258, nil, nil, body_580259)

var androidenterpriseWebappsInsert* = Call_AndroidenterpriseWebappsInsert_580243(
    name: "androidenterpriseWebappsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsInsert_580244,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsInsert_580245,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsList_580228 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsList_580230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsList_580229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580231 = path.getOrDefault("enterpriseId")
  valid_580231 = validateParameter(valid_580231, JString, required = true,
                                 default = nil)
  if valid_580231 != nil:
    section.add "enterpriseId", valid_580231
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  var valid_580234 = query.getOrDefault("oauth_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "oauth_token", valid_580234
  var valid_580235 = query.getOrDefault("alt")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = newJString("json"))
  if valid_580235 != nil:
    section.add "alt", valid_580235
  var valid_580236 = query.getOrDefault("userIp")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "userIp", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("fields")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "fields", valid_580238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580239: Call_AndroidenterpriseWebappsList_580228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  let valid = call_580239.validator(path, query, header, formData, body)
  let scheme = call_580239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580239.url(scheme.get, call_580239.host, call_580239.base,
                         call_580239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580239, url, valid)

proc call*(call_580240: Call_AndroidenterpriseWebappsList_580228;
          enterpriseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseWebappsList
  ## Retrieves the details of all web apps for a given enterprise.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580241 = newJObject()
  var query_580242 = newJObject()
  add(query_580242, "key", newJString(key))
  add(query_580242, "prettyPrint", newJBool(prettyPrint))
  add(query_580242, "oauth_token", newJString(oauthToken))
  add(query_580242, "alt", newJString(alt))
  add(query_580242, "userIp", newJString(userIp))
  add(query_580242, "quotaUser", newJString(quotaUser))
  add(path_580241, "enterpriseId", newJString(enterpriseId))
  add(query_580242, "fields", newJString(fields))
  result = call_580240.call(path_580241, query_580242, nil, nil, nil)

var androidenterpriseWebappsList* = Call_AndroidenterpriseWebappsList_580228(
    name: "androidenterpriseWebappsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsList_580229,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsList_580230,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsUpdate_580276 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsUpdate_580278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsUpdate_580277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580279 = path.getOrDefault("enterpriseId")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "enterpriseId", valid_580279
  var valid_580280 = path.getOrDefault("webAppId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "webAppId", valid_580280
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580281 = query.getOrDefault("key")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "key", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
  var valid_580283 = query.getOrDefault("oauth_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "oauth_token", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("userIp")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "userIp", valid_580285
  var valid_580286 = query.getOrDefault("quotaUser")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "quotaUser", valid_580286
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
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

proc call*(call_580289: Call_AndroidenterpriseWebappsUpdate_580276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_AndroidenterpriseWebappsUpdate_580276;
          enterpriseId: string; webAppId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseWebappsUpdate
  ## Updates an existing web app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  var body_580293 = newJObject()
  add(query_580292, "key", newJString(key))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "userIp", newJString(userIp))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(path_580291, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580293 = body
  add(query_580292, "fields", newJString(fields))
  add(path_580291, "webAppId", newJString(webAppId))
  result = call_580290.call(path_580291, query_580292, nil, nil, body_580293)

var androidenterpriseWebappsUpdate* = Call_AndroidenterpriseWebappsUpdate_580276(
    name: "androidenterpriseWebappsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsUpdate_580277,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsUpdate_580278,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsGet_580260 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsGet_580262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsGet_580261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580263 = path.getOrDefault("enterpriseId")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "enterpriseId", valid_580263
  var valid_580264 = path.getOrDefault("webAppId")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "webAppId", valid_580264
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580265 = query.getOrDefault("key")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "key", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
  var valid_580267 = query.getOrDefault("oauth_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "oauth_token", valid_580267
  var valid_580268 = query.getOrDefault("alt")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("json"))
  if valid_580268 != nil:
    section.add "alt", valid_580268
  var valid_580269 = query.getOrDefault("userIp")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "userIp", valid_580269
  var valid_580270 = query.getOrDefault("quotaUser")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "quotaUser", valid_580270
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580272: Call_AndroidenterpriseWebappsGet_580260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing web app.
  ## 
  let valid = call_580272.validator(path, query, header, formData, body)
  let scheme = call_580272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580272.url(scheme.get, call_580272.host, call_580272.base,
                         call_580272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580272, url, valid)

proc call*(call_580273: Call_AndroidenterpriseWebappsGet_580260;
          enterpriseId: string; webAppId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseWebappsGet
  ## Gets an existing web app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  var path_580274 = newJObject()
  var query_580275 = newJObject()
  add(query_580275, "key", newJString(key))
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "userIp", newJString(userIp))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(path_580274, "enterpriseId", newJString(enterpriseId))
  add(query_580275, "fields", newJString(fields))
  add(path_580274, "webAppId", newJString(webAppId))
  result = call_580273.call(path_580274, query_580275, nil, nil, nil)

var androidenterpriseWebappsGet* = Call_AndroidenterpriseWebappsGet_580260(
    name: "androidenterpriseWebappsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsGet_580261,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsGet_580262,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsPatch_580310 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsPatch_580312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsPatch_580311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580313 = path.getOrDefault("enterpriseId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "enterpriseId", valid_580313
  var valid_580314 = path.getOrDefault("webAppId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "webAppId", valid_580314
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580315 = query.getOrDefault("key")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "key", valid_580315
  var valid_580316 = query.getOrDefault("prettyPrint")
  valid_580316 = validateParameter(valid_580316, JBool, required = false,
                                 default = newJBool(true))
  if valid_580316 != nil:
    section.add "prettyPrint", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("userIp")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "userIp", valid_580319
  var valid_580320 = query.getOrDefault("quotaUser")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "quotaUser", valid_580320
  var valid_580321 = query.getOrDefault("fields")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "fields", valid_580321
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

proc call*(call_580323: Call_AndroidenterpriseWebappsPatch_580310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_AndroidenterpriseWebappsPatch_580310;
          enterpriseId: string; webAppId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## androidenterpriseWebappsPatch
  ## Updates an existing web app. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "key", newJString(key))
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "userIp", newJString(userIp))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(path_580325, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580327 = body
  add(query_580326, "fields", newJString(fields))
  add(path_580325, "webAppId", newJString(webAppId))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var androidenterpriseWebappsPatch* = Call_AndroidenterpriseWebappsPatch_580310(
    name: "androidenterpriseWebappsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsPatch_580311,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsPatch_580312,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsDelete_580294 = ref object of OpenApiRestCall_578348
proc url_AndroidenterpriseWebappsDelete_580296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsDelete_580295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_580297 = path.getOrDefault("enterpriseId")
  valid_580297 = validateParameter(valid_580297, JString, required = true,
                                 default = nil)
  if valid_580297 != nil:
    section.add "enterpriseId", valid_580297
  var valid_580298 = path.getOrDefault("webAppId")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "webAppId", valid_580298
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580299 = query.getOrDefault("key")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "key", valid_580299
  var valid_580300 = query.getOrDefault("prettyPrint")
  valid_580300 = validateParameter(valid_580300, JBool, required = false,
                                 default = newJBool(true))
  if valid_580300 != nil:
    section.add "prettyPrint", valid_580300
  var valid_580301 = query.getOrDefault("oauth_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "oauth_token", valid_580301
  var valid_580302 = query.getOrDefault("alt")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = newJString("json"))
  if valid_580302 != nil:
    section.add "alt", valid_580302
  var valid_580303 = query.getOrDefault("userIp")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "userIp", valid_580303
  var valid_580304 = query.getOrDefault("quotaUser")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "quotaUser", valid_580304
  var valid_580305 = query.getOrDefault("fields")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "fields", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_AndroidenterpriseWebappsDelete_580294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing web app.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_AndroidenterpriseWebappsDelete_580294;
          enterpriseId: string; webAppId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## androidenterpriseWebappsDelete
  ## Deletes an existing web app.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "key", newJString(key))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "userIp", newJString(userIp))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(path_580308, "enterpriseId", newJString(enterpriseId))
  add(query_580309, "fields", newJString(fields))
  add(path_580308, "webAppId", newJString(webAppId))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var androidenterpriseWebappsDelete* = Call_AndroidenterpriseWebappsDelete_580294(
    name: "androidenterpriseWebappsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsDelete_580295,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsDelete_580296,
    schemes: {Scheme.Https})
type
  Call_AndroidenterprisePermissionsGet_580328 = ref object of OpenApiRestCall_578348
proc url_AndroidenterprisePermissionsGet_580330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterprisePermissionsGet_580329(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permissionId: JString (required)
  ##               : The ID of the permission.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `permissionId` field"
  var valid_580331 = path.getOrDefault("permissionId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "permissionId", valid_580331
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de")
  section = newJObject()
  var valid_580332 = query.getOrDefault("key")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "key", valid_580332
  var valid_580333 = query.getOrDefault("prettyPrint")
  valid_580333 = validateParameter(valid_580333, JBool, required = false,
                                 default = newJBool(true))
  if valid_580333 != nil:
    section.add "prettyPrint", valid_580333
  var valid_580334 = query.getOrDefault("oauth_token")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "oauth_token", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("userIp")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "userIp", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("language")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "language", valid_580339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580340: Call_AndroidenterprisePermissionsGet_580328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  let valid = call_580340.validator(path, query, header, formData, body)
  let scheme = call_580340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580340.url(scheme.get, call_580340.host, call_580340.base,
                         call_580340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580340, url, valid)

proc call*(call_580341: Call_AndroidenterprisePermissionsGet_580328;
          permissionId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; language: string = ""): Recallable =
  ## androidenterprisePermissionsGet
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de")
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  var path_580342 = newJObject()
  var query_580343 = newJObject()
  add(query_580343, "key", newJString(key))
  add(query_580343, "prettyPrint", newJBool(prettyPrint))
  add(query_580343, "oauth_token", newJString(oauthToken))
  add(query_580343, "alt", newJString(alt))
  add(query_580343, "userIp", newJString(userIp))
  add(query_580343, "quotaUser", newJString(quotaUser))
  add(query_580343, "fields", newJString(fields))
  add(query_580343, "language", newJString(language))
  add(path_580342, "permissionId", newJString(permissionId))
  result = call_580341.call(path_580342, query_580343, nil, nil, nil)

var androidenterprisePermissionsGet* = Call_AndroidenterprisePermissionsGet_580328(
    name: "androidenterprisePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissions/{permissionId}",
    validator: validate_AndroidenterprisePermissionsGet_580329,
    base: "/androidenterprise/v1", url: url_AndroidenterprisePermissionsGet_580330,
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
