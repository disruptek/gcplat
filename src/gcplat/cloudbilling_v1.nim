
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Billing
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Allows developers to manage billing for their Google Cloud Platform projects
##     programmatically.
## 
## https://cloud.google.com/billing/
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudbilling"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbillingBillingAccountsCreate_578885 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsCreate_578887(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsCreate_578886(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
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
  var valid_578888 = query.getOrDefault("key")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "key", valid_578888
  var valid_578889 = query.getOrDefault("prettyPrint")
  valid_578889 = validateParameter(valid_578889, JBool, required = false,
                                 default = newJBool(true))
  if valid_578889 != nil:
    section.add "prettyPrint", valid_578889
  var valid_578890 = query.getOrDefault("oauth_token")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "oauth_token", valid_578890
  var valid_578891 = query.getOrDefault("$.xgafv")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("1"))
  if valid_578891 != nil:
    section.add "$.xgafv", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("uploadType")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "uploadType", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("callback")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "callback", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  var valid_578897 = query.getOrDefault("access_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "access_token", valid_578897
  var valid_578898 = query.getOrDefault("upload_protocol")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "upload_protocol", valid_578898
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

proc call*(call_578900: Call_CloudbillingBillingAccountsCreate_578885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_CloudbillingBillingAccountsCreate_578885;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsCreate
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
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
  var query_578902 = newJObject()
  var body_578903 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578903 = body
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  result = call_578901.call(nil, query_578902, nil, nil, body_578903)

var cloudbillingBillingAccountsCreate* = Call_CloudbillingBillingAccountsCreate_578885(
    name: "cloudbillingBillingAccountsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsCreate_578886, base: "/",
    url: url_CloudbillingBillingAccountsCreate_578887, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsList_578610 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   pageSize: JInt
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("filter")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "filter", valid_578745
  var valid_578746 = query.getOrDefault("pageToken")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "pageToken", valid_578746
  var valid_578747 = query.getOrDefault("callback")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "callback", valid_578747
  var valid_578748 = query.getOrDefault("fields")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "fields", valid_578748
  var valid_578749 = query.getOrDefault("access_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "access_token", valid_578749
  var valid_578750 = query.getOrDefault("upload_protocol")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "upload_protocol", valid_578750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578773: Call_CloudbillingBillingAccountsList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_578773.validator(path, query, header, formData, body)
  let scheme = call_578773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578773.url(scheme.get, call_578773.host, call_578773.base,
                         call_578773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578773, url, valid)

proc call*(call_578844: Call_CloudbillingBillingAccountsList_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsList
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578845 = newJObject()
  add(query_578845, "key", newJString(key))
  add(query_578845, "prettyPrint", newJBool(prettyPrint))
  add(query_578845, "oauth_token", newJString(oauthToken))
  add(query_578845, "$.xgafv", newJString(Xgafv))
  add(query_578845, "pageSize", newJInt(pageSize))
  add(query_578845, "alt", newJString(alt))
  add(query_578845, "uploadType", newJString(uploadType))
  add(query_578845, "quotaUser", newJString(quotaUser))
  add(query_578845, "filter", newJString(filter))
  add(query_578845, "pageToken", newJString(pageToken))
  add(query_578845, "callback", newJString(callback))
  add(query_578845, "fields", newJString(fields))
  add(query_578845, "access_token", newJString(accessToken))
  add(query_578845, "upload_protocol", newJString(uploadProtocol))
  result = call_578844.call(nil, query_578845, nil, nil, nil)

var cloudbillingBillingAccountsList* = Call_CloudbillingBillingAccountsList_578610(
    name: "cloudbillingBillingAccountsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsList_578611, base: "/",
    url: url_CloudbillingBillingAccountsList_578612, schemes: {Scheme.Https})
type
  Call_CloudbillingServicesList_578904 = ref object of OpenApiRestCall_578339
proc url_CloudbillingServicesList_578906(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingServicesList_578905(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all public cloud services.
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
  ##   pageSize: JInt
  ##           : Requested page size. Defaults to 5000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578907 = query.getOrDefault("key")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "key", valid_578907
  var valid_578908 = query.getOrDefault("prettyPrint")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(true))
  if valid_578908 != nil:
    section.add "prettyPrint", valid_578908
  var valid_578909 = query.getOrDefault("oauth_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "oauth_token", valid_578909
  var valid_578910 = query.getOrDefault("$.xgafv")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("1"))
  if valid_578910 != nil:
    section.add "$.xgafv", valid_578910
  var valid_578911 = query.getOrDefault("pageSize")
  valid_578911 = validateParameter(valid_578911, JInt, required = false, default = nil)
  if valid_578911 != nil:
    section.add "pageSize", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("pageToken")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "pageToken", valid_578915
  var valid_578916 = query.getOrDefault("callback")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "callback", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
  var valid_578918 = query.getOrDefault("access_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "access_token", valid_578918
  var valid_578919 = query.getOrDefault("upload_protocol")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "upload_protocol", valid_578919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578920: Call_CloudbillingServicesList_578904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public cloud services.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_CloudbillingServicesList_578904; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingServicesList
  ## Lists all public cloud services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "$.xgafv", newJString(Xgafv))
  add(query_578922, "pageSize", newJInt(pageSize))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "uploadType", newJString(uploadType))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(query_578922, "pageToken", newJString(pageToken))
  add(query_578922, "callback", newJString(callback))
  add(query_578922, "fields", newJString(fields))
  add(query_578922, "access_token", newJString(accessToken))
  add(query_578922, "upload_protocol", newJString(uploadProtocol))
  result = call_578921.call(nil, query_578922, nil, nil, nil)

var cloudbillingServicesList* = Call_CloudbillingServicesList_578904(
    name: "cloudbillingServicesList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/services",
    validator: validate_CloudbillingServicesList_578905, base: "/",
    url: url_CloudbillingServicesList_578906, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGet_578923 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsGet_578925(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudbillingBillingAccountsGet_578924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578940 = path.getOrDefault("name")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "name", valid_578940
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
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("$.xgafv")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("1"))
  if valid_578944 != nil:
    section.add "$.xgafv", valid_578944
  var valid_578945 = query.getOrDefault("alt")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("json"))
  if valid_578945 != nil:
    section.add "alt", valid_578945
  var valid_578946 = query.getOrDefault("uploadType")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "uploadType", valid_578946
  var valid_578947 = query.getOrDefault("quotaUser")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "quotaUser", valid_578947
  var valid_578948 = query.getOrDefault("callback")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "callback", valid_578948
  var valid_578949 = query.getOrDefault("fields")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "fields", valid_578949
  var valid_578950 = query.getOrDefault("access_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "access_token", valid_578950
  var valid_578951 = query.getOrDefault("upload_protocol")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "upload_protocol", valid_578951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578952: Call_CloudbillingBillingAccountsGet_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_CloudbillingBillingAccountsGet_578923; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsGet
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(query_578955, "$.xgafv", newJString(Xgafv))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "uploadType", newJString(uploadType))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(path_578954, "name", newJString(name))
  add(query_578955, "callback", newJString(callback))
  add(query_578955, "fields", newJString(fields))
  add(query_578955, "access_token", newJString(accessToken))
  add(query_578955, "upload_protocol", newJString(uploadProtocol))
  result = call_578953.call(path_578954, query_578955, nil, nil, nil)

var cloudbillingBillingAccountsGet* = Call_CloudbillingBillingAccountsGet_578923(
    name: "cloudbillingBillingAccountsGet", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsGet_578924, base: "/",
    url: url_CloudbillingBillingAccountsGet_578925, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsPatch_578956 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsPatch_578958(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudbillingBillingAccountsPatch_578957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the billing account resource to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578959 = path.getOrDefault("name")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "name", valid_578959
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
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("$.xgafv")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("1"))
  if valid_578963 != nil:
    section.add "$.xgafv", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("uploadType")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "uploadType", valid_578965
  var valid_578966 = query.getOrDefault("quotaUser")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "quotaUser", valid_578966
  var valid_578967 = query.getOrDefault("updateMask")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "updateMask", valid_578967
  var valid_578968 = query.getOrDefault("callback")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "callback", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
  var valid_578970 = query.getOrDefault("access_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "access_token", valid_578970
  var valid_578971 = query.getOrDefault("upload_protocol")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "upload_protocol", valid_578971
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

proc call*(call_578973: Call_CloudbillingBillingAccountsPatch_578956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_CloudbillingBillingAccountsPatch_578956; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsPatch
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
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
  ##       : The name of the billing account resource to be updated.
  ##   updateMask: string
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  var body_578977 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "$.xgafv", newJString(Xgafv))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "uploadType", newJString(uploadType))
  add(query_578976, "quotaUser", newJString(quotaUser))
  add(path_578975, "name", newJString(name))
  add(query_578976, "updateMask", newJString(updateMask))
  if body != nil:
    body_578977 = body
  add(query_578976, "callback", newJString(callback))
  add(query_578976, "fields", newJString(fields))
  add(query_578976, "access_token", newJString(accessToken))
  add(query_578976, "upload_protocol", newJString(uploadProtocol))
  result = call_578974.call(path_578975, query_578976, nil, nil, body_578977)

var cloudbillingBillingAccountsPatch* = Call_CloudbillingBillingAccountsPatch_578956(
    name: "cloudbillingBillingAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsPatch_578957, base: "/",
    url: url_CloudbillingBillingAccountsPatch_578958, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsUpdateBillingInfo_578997 = ref object of OpenApiRestCall_578339
proc url_CloudbillingProjectsUpdateBillingInfo_578999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingProjectsUpdateBillingInfo_578998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579000 = path.getOrDefault("name")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "name", valid_579000
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("$.xgafv")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("1"))
  if valid_579004 != nil:
    section.add "$.xgafv", valid_579004
  var valid_579005 = query.getOrDefault("alt")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("json"))
  if valid_579005 != nil:
    section.add "alt", valid_579005
  var valid_579006 = query.getOrDefault("uploadType")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "uploadType", valid_579006
  var valid_579007 = query.getOrDefault("quotaUser")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "quotaUser", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
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

proc call*(call_579013: Call_CloudbillingProjectsUpdateBillingInfo_578997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_CloudbillingProjectsUpdateBillingInfo_578997;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingProjectsUpdateBillingInfo
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
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
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579015 = newJObject()
  var query_579016 = newJObject()
  var body_579017 = newJObject()
  add(query_579016, "key", newJString(key))
  add(query_579016, "prettyPrint", newJBool(prettyPrint))
  add(query_579016, "oauth_token", newJString(oauthToken))
  add(query_579016, "$.xgafv", newJString(Xgafv))
  add(query_579016, "alt", newJString(alt))
  add(query_579016, "uploadType", newJString(uploadType))
  add(query_579016, "quotaUser", newJString(quotaUser))
  add(path_579015, "name", newJString(name))
  if body != nil:
    body_579017 = body
  add(query_579016, "callback", newJString(callback))
  add(query_579016, "fields", newJString(fields))
  add(query_579016, "access_token", newJString(accessToken))
  add(query_579016, "upload_protocol", newJString(uploadProtocol))
  result = call_579014.call(path_579015, query_579016, nil, nil, body_579017)

var cloudbillingProjectsUpdateBillingInfo* = Call_CloudbillingProjectsUpdateBillingInfo_578997(
    name: "cloudbillingProjectsUpdateBillingInfo", meth: HttpMethod.HttpPut,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsUpdateBillingInfo_578998, base: "/",
    url: url_CloudbillingProjectsUpdateBillingInfo_578999, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsGetBillingInfo_578978 = ref object of OpenApiRestCall_578339
proc url_CloudbillingProjectsGetBillingInfo_578980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingProjectsGetBillingInfo_578979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578981 = path.getOrDefault("name")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "name", valid_578981
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("$.xgafv")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("1"))
  if valid_578985 != nil:
    section.add "$.xgafv", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("uploadType")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "uploadType", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("callback")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "callback", valid_578989
  var valid_578990 = query.getOrDefault("fields")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "fields", valid_578990
  var valid_578991 = query.getOrDefault("access_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "access_token", valid_578991
  var valid_578992 = query.getOrDefault("upload_protocol")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "upload_protocol", valid_578992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578993: Call_CloudbillingProjectsGetBillingInfo_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_CloudbillingProjectsGetBillingInfo_578978;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingProjectsGetBillingInfo
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
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
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(query_578996, "$.xgafv", newJString(Xgafv))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "uploadType", newJString(uploadType))
  add(query_578996, "quotaUser", newJString(quotaUser))
  add(path_578995, "name", newJString(name))
  add(query_578996, "callback", newJString(callback))
  add(query_578996, "fields", newJString(fields))
  add(query_578996, "access_token", newJString(accessToken))
  add(query_578996, "upload_protocol", newJString(uploadProtocol))
  result = call_578994.call(path_578995, query_578996, nil, nil, nil)

var cloudbillingProjectsGetBillingInfo* = Call_CloudbillingProjectsGetBillingInfo_578978(
    name: "cloudbillingProjectsGetBillingInfo", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsGetBillingInfo_578979, base: "/",
    url: url_CloudbillingProjectsGetBillingInfo_578980, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsProjectsList_579018 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsProjectsList_579020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsProjectsList_579019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579021 = path.getOrDefault("name")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "name", valid_579021
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
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579022 = query.getOrDefault("key")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "key", valid_579022
  var valid_579023 = query.getOrDefault("prettyPrint")
  valid_579023 = validateParameter(valid_579023, JBool, required = false,
                                 default = newJBool(true))
  if valid_579023 != nil:
    section.add "prettyPrint", valid_579023
  var valid_579024 = query.getOrDefault("oauth_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "oauth_token", valid_579024
  var valid_579025 = query.getOrDefault("$.xgafv")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("1"))
  if valid_579025 != nil:
    section.add "$.xgafv", valid_579025
  var valid_579026 = query.getOrDefault("pageSize")
  valid_579026 = validateParameter(valid_579026, JInt, required = false, default = nil)
  if valid_579026 != nil:
    section.add "pageSize", valid_579026
  var valid_579027 = query.getOrDefault("alt")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("json"))
  if valid_579027 != nil:
    section.add "alt", valid_579027
  var valid_579028 = query.getOrDefault("uploadType")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "uploadType", valid_579028
  var valid_579029 = query.getOrDefault("quotaUser")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "quotaUser", valid_579029
  var valid_579030 = query.getOrDefault("pageToken")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "pageToken", valid_579030
  var valid_579031 = query.getOrDefault("callback")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "callback", valid_579031
  var valid_579032 = query.getOrDefault("fields")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "fields", valid_579032
  var valid_579033 = query.getOrDefault("access_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "access_token", valid_579033
  var valid_579034 = query.getOrDefault("upload_protocol")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "upload_protocol", valid_579034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579035: Call_CloudbillingBillingAccountsProjectsList_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579035.validator(path, query, header, formData, body)
  let scheme = call_579035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579035.url(scheme.get, call_579035.host, call_579035.base,
                         call_579035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579035, url, valid)

proc call*(call_579036: Call_CloudbillingBillingAccountsProjectsList_579018;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsProjectsList
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579037 = newJObject()
  var query_579038 = newJObject()
  add(query_579038, "key", newJString(key))
  add(query_579038, "prettyPrint", newJBool(prettyPrint))
  add(query_579038, "oauth_token", newJString(oauthToken))
  add(query_579038, "$.xgafv", newJString(Xgafv))
  add(query_579038, "pageSize", newJInt(pageSize))
  add(query_579038, "alt", newJString(alt))
  add(query_579038, "uploadType", newJString(uploadType))
  add(query_579038, "quotaUser", newJString(quotaUser))
  add(path_579037, "name", newJString(name))
  add(query_579038, "pageToken", newJString(pageToken))
  add(query_579038, "callback", newJString(callback))
  add(query_579038, "fields", newJString(fields))
  add(query_579038, "access_token", newJString(accessToken))
  add(query_579038, "upload_protocol", newJString(uploadProtocol))
  result = call_579036.call(path_579037, query_579038, nil, nil, nil)

var cloudbillingBillingAccountsProjectsList* = Call_CloudbillingBillingAccountsProjectsList_579018(
    name: "cloudbillingBillingAccountsProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/projects",
    validator: validate_CloudbillingBillingAccountsProjectsList_579019, base: "/",
    url: url_CloudbillingBillingAccountsProjectsList_579020,
    schemes: {Scheme.Https})
type
  Call_CloudbillingServicesSkusList_579039 = ref object of OpenApiRestCall_578339
proc url_CloudbillingServicesSkusList_579041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingServicesSkusList_579040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579042 = path.getOrDefault("parent")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "parent", valid_579042
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
  ##           : Requested page size. Defaults to 5000.
  ##   startTime: JString
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
  ##   currencyCode: JString
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: JString
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
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
  var valid_579046 = query.getOrDefault("$.xgafv")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("1"))
  if valid_579046 != nil:
    section.add "$.xgafv", valid_579046
  var valid_579047 = query.getOrDefault("pageSize")
  valid_579047 = validateParameter(valid_579047, JInt, required = false, default = nil)
  if valid_579047 != nil:
    section.add "pageSize", valid_579047
  var valid_579048 = query.getOrDefault("startTime")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "startTime", valid_579048
  var valid_579049 = query.getOrDefault("alt")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("json"))
  if valid_579049 != nil:
    section.add "alt", valid_579049
  var valid_579050 = query.getOrDefault("uploadType")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "uploadType", valid_579050
  var valid_579051 = query.getOrDefault("quotaUser")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "quotaUser", valid_579051
  var valid_579052 = query.getOrDefault("pageToken")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "pageToken", valid_579052
  var valid_579053 = query.getOrDefault("currencyCode")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "currencyCode", valid_579053
  var valid_579054 = query.getOrDefault("callback")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "callback", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("access_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "access_token", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
  var valid_579058 = query.getOrDefault("endTime")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "endTime", valid_579058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579059: Call_CloudbillingServicesSkusList_579039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_CloudbillingServicesSkusList_579039; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; currencyCode: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          endTime: string = ""): Recallable =
  ## cloudbillingServicesSkusList
  ## Lists all publicly available SKUs for a given cloud service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   startTime: string
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
  ##   currencyCode: string
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: string
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(query_579062, "$.xgafv", newJString(Xgafv))
  add(query_579062, "pageSize", newJInt(pageSize))
  add(query_579062, "startTime", newJString(startTime))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "uploadType", newJString(uploadType))
  add(query_579062, "quotaUser", newJString(quotaUser))
  add(query_579062, "pageToken", newJString(pageToken))
  add(query_579062, "currencyCode", newJString(currencyCode))
  add(query_579062, "callback", newJString(callback))
  add(path_579061, "parent", newJString(parent))
  add(query_579062, "fields", newJString(fields))
  add(query_579062, "access_token", newJString(accessToken))
  add(query_579062, "upload_protocol", newJString(uploadProtocol))
  add(query_579062, "endTime", newJString(endTime))
  result = call_579060.call(path_579061, query_579062, nil, nil, nil)

var cloudbillingServicesSkusList* = Call_CloudbillingServicesSkusList_579039(
    name: "cloudbillingServicesSkusList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{parent}/skus",
    validator: validate_CloudbillingServicesSkusList_579040, base: "/",
    url: url_CloudbillingServicesSkusList_579041, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGetIamPolicy_579063 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsGetIamPolicy_579065(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGetIamPolicy_579064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579066 = path.getOrDefault("resource")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "resource", valid_579066
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "options.requestedPolicyVersion", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("callback")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "callback", valid_579075
  var valid_579076 = query.getOrDefault("fields")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "fields", valid_579076
  var valid_579077 = query.getOrDefault("access_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "access_token", valid_579077
  var valid_579078 = query.getOrDefault("upload_protocol")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "upload_protocol", valid_579078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579079: Call_CloudbillingBillingAccountsGetIamPolicy_579063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_CloudbillingBillingAccountsGetIamPolicy_579063;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsGetIamPolicy
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(query_579082, "$.xgafv", newJString(Xgafv))
  add(query_579082, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "uploadType", newJString(uploadType))
  add(query_579082, "quotaUser", newJString(quotaUser))
  add(path_579081, "resource", newJString(resource))
  add(query_579082, "callback", newJString(callback))
  add(query_579082, "fields", newJString(fields))
  add(query_579082, "access_token", newJString(accessToken))
  add(query_579082, "upload_protocol", newJString(uploadProtocol))
  result = call_579080.call(path_579081, query_579082, nil, nil, nil)

var cloudbillingBillingAccountsGetIamPolicy* = Call_CloudbillingBillingAccountsGetIamPolicy_579063(
    name: "cloudbillingBillingAccountsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudbillingBillingAccountsGetIamPolicy_579064, base: "/",
    url: url_CloudbillingBillingAccountsGetIamPolicy_579065,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsSetIamPolicy_579083 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsSetIamPolicy_579085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsSetIamPolicy_579084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579086 = path.getOrDefault("resource")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "resource", valid_579086
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
  var valid_579087 = query.getOrDefault("key")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "key", valid_579087
  var valid_579088 = query.getOrDefault("prettyPrint")
  valid_579088 = validateParameter(valid_579088, JBool, required = false,
                                 default = newJBool(true))
  if valid_579088 != nil:
    section.add "prettyPrint", valid_579088
  var valid_579089 = query.getOrDefault("oauth_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "oauth_token", valid_579089
  var valid_579090 = query.getOrDefault("$.xgafv")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = newJString("1"))
  if valid_579090 != nil:
    section.add "$.xgafv", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("uploadType")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "uploadType", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("callback")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "callback", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  var valid_579096 = query.getOrDefault("access_token")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "access_token", valid_579096
  var valid_579097 = query.getOrDefault("upload_protocol")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "upload_protocol", valid_579097
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

proc call*(call_579099: Call_CloudbillingBillingAccountsSetIamPolicy_579083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579099.validator(path, query, header, formData, body)
  let scheme = call_579099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579099.url(scheme.get, call_579099.host, call_579099.base,
                         call_579099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579099, url, valid)

proc call*(call_579100: Call_CloudbillingBillingAccountsSetIamPolicy_579083;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsSetIamPolicy
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579101 = newJObject()
  var query_579102 = newJObject()
  var body_579103 = newJObject()
  add(query_579102, "key", newJString(key))
  add(query_579102, "prettyPrint", newJBool(prettyPrint))
  add(query_579102, "oauth_token", newJString(oauthToken))
  add(query_579102, "$.xgafv", newJString(Xgafv))
  add(query_579102, "alt", newJString(alt))
  add(query_579102, "uploadType", newJString(uploadType))
  add(query_579102, "quotaUser", newJString(quotaUser))
  add(path_579101, "resource", newJString(resource))
  if body != nil:
    body_579103 = body
  add(query_579102, "callback", newJString(callback))
  add(query_579102, "fields", newJString(fields))
  add(query_579102, "access_token", newJString(accessToken))
  add(query_579102, "upload_protocol", newJString(uploadProtocol))
  result = call_579100.call(path_579101, query_579102, nil, nil, body_579103)

var cloudbillingBillingAccountsSetIamPolicy* = Call_CloudbillingBillingAccountsSetIamPolicy_579083(
    name: "cloudbillingBillingAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudbillingBillingAccountsSetIamPolicy_579084, base: "/",
    url: url_CloudbillingBillingAccountsSetIamPolicy_579085,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsTestIamPermissions_579104 = ref object of OpenApiRestCall_578339
proc url_CloudbillingBillingAccountsTestIamPermissions_579106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsTestIamPermissions_579105(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579107 = path.getOrDefault("resource")
  valid_579107 = validateParameter(valid_579107, JString, required = true,
                                 default = nil)
  if valid_579107 != nil:
    section.add "resource", valid_579107
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
  var valid_579108 = query.getOrDefault("key")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "key", valid_579108
  var valid_579109 = query.getOrDefault("prettyPrint")
  valid_579109 = validateParameter(valid_579109, JBool, required = false,
                                 default = newJBool(true))
  if valid_579109 != nil:
    section.add "prettyPrint", valid_579109
  var valid_579110 = query.getOrDefault("oauth_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "oauth_token", valid_579110
  var valid_579111 = query.getOrDefault("$.xgafv")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("1"))
  if valid_579111 != nil:
    section.add "$.xgafv", valid_579111
  var valid_579112 = query.getOrDefault("alt")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("json"))
  if valid_579112 != nil:
    section.add "alt", valid_579112
  var valid_579113 = query.getOrDefault("uploadType")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "uploadType", valid_579113
  var valid_579114 = query.getOrDefault("quotaUser")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "quotaUser", valid_579114
  var valid_579115 = query.getOrDefault("callback")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "callback", valid_579115
  var valid_579116 = query.getOrDefault("fields")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "fields", valid_579116
  var valid_579117 = query.getOrDefault("access_token")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "access_token", valid_579117
  var valid_579118 = query.getOrDefault("upload_protocol")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "upload_protocol", valid_579118
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

proc call*(call_579120: Call_CloudbillingBillingAccountsTestIamPermissions_579104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  let valid = call_579120.validator(path, query, header, formData, body)
  let scheme = call_579120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579120.url(scheme.get, call_579120.host, call_579120.base,
                         call_579120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579120, url, valid)

proc call*(call_579121: Call_CloudbillingBillingAccountsTestIamPermissions_579104;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudbillingBillingAccountsTestIamPermissions
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579122 = newJObject()
  var query_579123 = newJObject()
  var body_579124 = newJObject()
  add(query_579123, "key", newJString(key))
  add(query_579123, "prettyPrint", newJBool(prettyPrint))
  add(query_579123, "oauth_token", newJString(oauthToken))
  add(query_579123, "$.xgafv", newJString(Xgafv))
  add(query_579123, "alt", newJString(alt))
  add(query_579123, "uploadType", newJString(uploadType))
  add(query_579123, "quotaUser", newJString(quotaUser))
  add(path_579122, "resource", newJString(resource))
  if body != nil:
    body_579124 = body
  add(query_579123, "callback", newJString(callback))
  add(query_579123, "fields", newJString(fields))
  add(query_579123, "access_token", newJString(accessToken))
  add(query_579123, "upload_protocol", newJString(uploadProtocol))
  result = call_579121.call(path_579122, query_579123, nil, nil, body_579124)

var cloudbillingBillingAccountsTestIamPermissions* = Call_CloudbillingBillingAccountsTestIamPermissions_579104(
    name: "cloudbillingBillingAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudbilling.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudbillingBillingAccountsTestIamPermissions_579105,
    base: "/", url: url_CloudbillingBillingAccountsTestIamPermissions_579106,
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
