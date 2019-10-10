
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudbilling"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbillingBillingAccountsCreate_588985 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsCreate_588987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsCreate_588986(path: JsonNode;
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
  var valid_588988 = query.getOrDefault("upload_protocol")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "upload_protocol", valid_588988
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("prettyPrint")
  valid_588998 = validateParameter(valid_588998, JBool, required = false,
                                 default = newJBool(true))
  if valid_588998 != nil:
    section.add "prettyPrint", valid_588998
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

proc call*(call_589000: Call_CloudbillingBillingAccountsCreate_588985;
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
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_CloudbillingBillingAccountsCreate_588985;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var query_589002 = newJObject()
  var body_589003 = newJObject()
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589003 = body
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  result = call_589001.call(nil, query_589002, nil, nil, body_589003)

var cloudbillingBillingAccountsCreate* = Call_CloudbillingBillingAccountsCreate_588985(
    name: "cloudbillingBillingAccountsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsCreate_588986, base: "/",
    url: url_CloudbillingBillingAccountsCreate_588987, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsList_588711(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("$.xgafv")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("1"))
  if valid_588847 != nil:
    section.add "$.xgafv", valid_588847
  var valid_588848 = query.getOrDefault("pageSize")
  valid_588848 = validateParameter(valid_588848, JInt, required = false, default = nil)
  if valid_588848 != nil:
    section.add "pageSize", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  var valid_588850 = query.getOrDefault("filter")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "filter", valid_588850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588873: Call_CloudbillingBillingAccountsList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_588873.validator(path, query, header, formData, body)
  let scheme = call_588873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588873.url(scheme.get, call_588873.host, call_588873.base,
                         call_588873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588873, url, valid)

proc call*(call_588944: Call_CloudbillingBillingAccountsList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudbillingBillingAccountsList
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
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
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  var query_588945 = newJObject()
  add(query_588945, "upload_protocol", newJString(uploadProtocol))
  add(query_588945, "fields", newJString(fields))
  add(query_588945, "pageToken", newJString(pageToken))
  add(query_588945, "quotaUser", newJString(quotaUser))
  add(query_588945, "alt", newJString(alt))
  add(query_588945, "oauth_token", newJString(oauthToken))
  add(query_588945, "callback", newJString(callback))
  add(query_588945, "access_token", newJString(accessToken))
  add(query_588945, "uploadType", newJString(uploadType))
  add(query_588945, "key", newJString(key))
  add(query_588945, "$.xgafv", newJString(Xgafv))
  add(query_588945, "pageSize", newJInt(pageSize))
  add(query_588945, "prettyPrint", newJBool(prettyPrint))
  add(query_588945, "filter", newJString(filter))
  result = call_588944.call(nil, query_588945, nil, nil, nil)

var cloudbillingBillingAccountsList* = Call_CloudbillingBillingAccountsList_588710(
    name: "cloudbillingBillingAccountsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsList_588711, base: "/",
    url: url_CloudbillingBillingAccountsList_588712, schemes: {Scheme.Https})
type
  Call_CloudbillingServicesList_589004 = ref object of OpenApiRestCall_588441
proc url_CloudbillingServicesList_589006(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingServicesList_589005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all public cloud services.
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
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589007 = query.getOrDefault("upload_protocol")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "upload_protocol", valid_589007
  var valid_589008 = query.getOrDefault("fields")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "fields", valid_589008
  var valid_589009 = query.getOrDefault("pageToken")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "pageToken", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("callback")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "callback", valid_589013
  var valid_589014 = query.getOrDefault("access_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "access_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("$.xgafv")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("1"))
  if valid_589017 != nil:
    section.add "$.xgafv", valid_589017
  var valid_589018 = query.getOrDefault("pageSize")
  valid_589018 = validateParameter(valid_589018, JInt, required = false, default = nil)
  if valid_589018 != nil:
    section.add "pageSize", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589020: Call_CloudbillingServicesList_589004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public cloud services.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_CloudbillingServicesList_589004;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudbillingServicesList
  ## Lists all public cloud services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
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
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589022 = newJObject()
  add(query_589022, "upload_protocol", newJString(uploadProtocol))
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "pageToken", newJString(pageToken))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "callback", newJString(callback))
  add(query_589022, "access_token", newJString(accessToken))
  add(query_589022, "uploadType", newJString(uploadType))
  add(query_589022, "key", newJString(key))
  add(query_589022, "$.xgafv", newJString(Xgafv))
  add(query_589022, "pageSize", newJInt(pageSize))
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(nil, query_589022, nil, nil, nil)

var cloudbillingServicesList* = Call_CloudbillingServicesList_589004(
    name: "cloudbillingServicesList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/services",
    validator: validate_CloudbillingServicesList_589005, base: "/",
    url: url_CloudbillingServicesList_589006, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGet_589023 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsGet_589025(protocol: Scheme; host: string;
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

proc validate_CloudbillingBillingAccountsGet_589024(path: JsonNode;
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
  var valid_589040 = path.getOrDefault("name")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "name", valid_589040
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
  var valid_589041 = query.getOrDefault("upload_protocol")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "upload_protocol", valid_589041
  var valid_589042 = query.getOrDefault("fields")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fields", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("oauth_token")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "oauth_token", valid_589045
  var valid_589046 = query.getOrDefault("callback")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "callback", valid_589046
  var valid_589047 = query.getOrDefault("access_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "access_token", valid_589047
  var valid_589048 = query.getOrDefault("uploadType")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "uploadType", valid_589048
  var valid_589049 = query.getOrDefault("key")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "key", valid_589049
  var valid_589050 = query.getOrDefault("$.xgafv")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("1"))
  if valid_589050 != nil:
    section.add "$.xgafv", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589052: Call_CloudbillingBillingAccountsGet_589023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_CloudbillingBillingAccountsGet_589023; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsGet
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
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
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  add(query_589055, "upload_protocol", newJString(uploadProtocol))
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(path_589054, "name", newJString(name))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "callback", newJString(callback))
  add(query_589055, "access_token", newJString(accessToken))
  add(query_589055, "uploadType", newJString(uploadType))
  add(query_589055, "key", newJString(key))
  add(query_589055, "$.xgafv", newJString(Xgafv))
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, nil)

var cloudbillingBillingAccountsGet* = Call_CloudbillingBillingAccountsGet_589023(
    name: "cloudbillingBillingAccountsGet", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsGet_589024, base: "/",
    url: url_CloudbillingBillingAccountsGet_589025, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsPatch_589056 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsPatch_589058(protocol: Scheme; host: string;
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

proc validate_CloudbillingBillingAccountsPatch_589057(path: JsonNode;
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
  var valid_589059 = path.getOrDefault("name")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "name", valid_589059
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
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  section = newJObject()
  var valid_589060 = query.getOrDefault("upload_protocol")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "upload_protocol", valid_589060
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("callback")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "callback", valid_589065
  var valid_589066 = query.getOrDefault("access_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "access_token", valid_589066
  var valid_589067 = query.getOrDefault("uploadType")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "uploadType", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("$.xgafv")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("1"))
  if valid_589069 != nil:
    section.add "$.xgafv", valid_589069
  var valid_589070 = query.getOrDefault("prettyPrint")
  valid_589070 = validateParameter(valid_589070, JBool, required = false,
                                 default = newJBool(true))
  if valid_589070 != nil:
    section.add "prettyPrint", valid_589070
  var valid_589071 = query.getOrDefault("updateMask")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "updateMask", valid_589071
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

proc call*(call_589073: Call_CloudbillingBillingAccountsPatch_589056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_CloudbillingBillingAccountsPatch_589056; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## cloudbillingBillingAccountsPatch
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the billing account resource to be updated.
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
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  var path_589075 = newJObject()
  var query_589076 = newJObject()
  var body_589077 = newJObject()
  add(query_589076, "upload_protocol", newJString(uploadProtocol))
  add(query_589076, "fields", newJString(fields))
  add(query_589076, "quotaUser", newJString(quotaUser))
  add(path_589075, "name", newJString(name))
  add(query_589076, "alt", newJString(alt))
  add(query_589076, "oauth_token", newJString(oauthToken))
  add(query_589076, "callback", newJString(callback))
  add(query_589076, "access_token", newJString(accessToken))
  add(query_589076, "uploadType", newJString(uploadType))
  add(query_589076, "key", newJString(key))
  add(query_589076, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589077 = body
  add(query_589076, "prettyPrint", newJBool(prettyPrint))
  add(query_589076, "updateMask", newJString(updateMask))
  result = call_589074.call(path_589075, query_589076, nil, nil, body_589077)

var cloudbillingBillingAccountsPatch* = Call_CloudbillingBillingAccountsPatch_589056(
    name: "cloudbillingBillingAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsPatch_589057, base: "/",
    url: url_CloudbillingBillingAccountsPatch_589058, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsUpdateBillingInfo_589097 = ref object of OpenApiRestCall_588441
proc url_CloudbillingProjectsUpdateBillingInfo_589099(protocol: Scheme;
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

proc validate_CloudbillingProjectsUpdateBillingInfo_589098(path: JsonNode;
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
  var valid_589100 = path.getOrDefault("name")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "name", valid_589100
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
  var valid_589101 = query.getOrDefault("upload_protocol")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "upload_protocol", valid_589101
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("oauth_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "oauth_token", valid_589105
  var valid_589106 = query.getOrDefault("callback")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "callback", valid_589106
  var valid_589107 = query.getOrDefault("access_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "access_token", valid_589107
  var valid_589108 = query.getOrDefault("uploadType")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "uploadType", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("$.xgafv")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("1"))
  if valid_589110 != nil:
    section.add "$.xgafv", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
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

proc call*(call_589113: Call_CloudbillingProjectsUpdateBillingInfo_589097;
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
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_CloudbillingProjectsUpdateBillingInfo_589097;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
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
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  var body_589117 = newJObject()
  add(query_589116, "upload_protocol", newJString(uploadProtocol))
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(path_589115, "name", newJString(name))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "callback", newJString(callback))
  add(query_589116, "access_token", newJString(accessToken))
  add(query_589116, "uploadType", newJString(uploadType))
  add(query_589116, "key", newJString(key))
  add(query_589116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589117 = body
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(path_589115, query_589116, nil, nil, body_589117)

var cloudbillingProjectsUpdateBillingInfo* = Call_CloudbillingProjectsUpdateBillingInfo_589097(
    name: "cloudbillingProjectsUpdateBillingInfo", meth: HttpMethod.HttpPut,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsUpdateBillingInfo_589098, base: "/",
    url: url_CloudbillingProjectsUpdateBillingInfo_589099, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsGetBillingInfo_589078 = ref object of OpenApiRestCall_588441
proc url_CloudbillingProjectsGetBillingInfo_589080(protocol: Scheme; host: string;
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

proc validate_CloudbillingProjectsGetBillingInfo_589079(path: JsonNode;
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
  var valid_589081 = path.getOrDefault("name")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "name", valid_589081
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
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("$.xgafv")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("1"))
  if valid_589091 != nil:
    section.add "$.xgafv", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589093: Call_CloudbillingProjectsGetBillingInfo_589078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_CloudbillingProjectsGetBillingInfo_589078;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbillingProjectsGetBillingInfo
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  add(query_589096, "upload_protocol", newJString(uploadProtocol))
  add(query_589096, "fields", newJString(fields))
  add(query_589096, "quotaUser", newJString(quotaUser))
  add(path_589095, "name", newJString(name))
  add(query_589096, "alt", newJString(alt))
  add(query_589096, "oauth_token", newJString(oauthToken))
  add(query_589096, "callback", newJString(callback))
  add(query_589096, "access_token", newJString(accessToken))
  add(query_589096, "uploadType", newJString(uploadType))
  add(query_589096, "key", newJString(key))
  add(query_589096, "$.xgafv", newJString(Xgafv))
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  result = call_589094.call(path_589095, query_589096, nil, nil, nil)

var cloudbillingProjectsGetBillingInfo* = Call_CloudbillingProjectsGetBillingInfo_589078(
    name: "cloudbillingProjectsGetBillingInfo", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsGetBillingInfo_589079, base: "/",
    url: url_CloudbillingProjectsGetBillingInfo_589080, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsProjectsList_589118 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsProjectsList_589120(protocol: Scheme;
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

proc validate_CloudbillingBillingAccountsProjectsList_589119(path: JsonNode;
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
  var valid_589121 = path.getOrDefault("name")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "name", valid_589121
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589122 = query.getOrDefault("upload_protocol")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "upload_protocol", valid_589122
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("pageToken")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "pageToken", valid_589124
  var valid_589125 = query.getOrDefault("quotaUser")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "quotaUser", valid_589125
  var valid_589126 = query.getOrDefault("alt")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("json"))
  if valid_589126 != nil:
    section.add "alt", valid_589126
  var valid_589127 = query.getOrDefault("oauth_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "oauth_token", valid_589127
  var valid_589128 = query.getOrDefault("callback")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "callback", valid_589128
  var valid_589129 = query.getOrDefault("access_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "access_token", valid_589129
  var valid_589130 = query.getOrDefault("uploadType")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "uploadType", valid_589130
  var valid_589131 = query.getOrDefault("key")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "key", valid_589131
  var valid_589132 = query.getOrDefault("$.xgafv")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("1"))
  if valid_589132 != nil:
    section.add "$.xgafv", valid_589132
  var valid_589133 = query.getOrDefault("pageSize")
  valid_589133 = validateParameter(valid_589133, JInt, required = false, default = nil)
  if valid_589133 != nil:
    section.add "pageSize", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589135: Call_CloudbillingBillingAccountsProjectsList_589118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_589135.validator(path, query, header, formData, body)
  let scheme = call_589135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589135.url(scheme.get, call_589135.host, call_589135.base,
                         call_589135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589135, url, valid)

proc call*(call_589136: Call_CloudbillingBillingAccountsProjectsList_589118;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsProjectsList
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
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
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589137 = newJObject()
  var query_589138 = newJObject()
  add(query_589138, "upload_protocol", newJString(uploadProtocol))
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "pageToken", newJString(pageToken))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(path_589137, "name", newJString(name))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "callback", newJString(callback))
  add(query_589138, "access_token", newJString(accessToken))
  add(query_589138, "uploadType", newJString(uploadType))
  add(query_589138, "key", newJString(key))
  add(query_589138, "$.xgafv", newJString(Xgafv))
  add(query_589138, "pageSize", newJInt(pageSize))
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  result = call_589136.call(path_589137, query_589138, nil, nil, nil)

var cloudbillingBillingAccountsProjectsList* = Call_CloudbillingBillingAccountsProjectsList_589118(
    name: "cloudbillingBillingAccountsProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/projects",
    validator: validate_CloudbillingBillingAccountsProjectsList_589119, base: "/",
    url: url_CloudbillingBillingAccountsProjectsList_589120,
    schemes: {Scheme.Https})
type
  Call_CloudbillingServicesSkusList_589139 = ref object of OpenApiRestCall_588441
proc url_CloudbillingServicesSkusList_589141(protocol: Scheme; host: string;
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

proc validate_CloudbillingServicesSkusList_589140(path: JsonNode; query: JsonNode;
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
  var valid_589142 = path.getOrDefault("parent")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "parent", valid_589142
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
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
  ##   endTime: JString
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   currencyCode: JString
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  section = newJObject()
  var valid_589143 = query.getOrDefault("upload_protocol")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "upload_protocol", valid_589143
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("pageToken")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "pageToken", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("callback")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "callback", valid_589149
  var valid_589150 = query.getOrDefault("access_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "access_token", valid_589150
  var valid_589151 = query.getOrDefault("uploadType")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "uploadType", valid_589151
  var valid_589152 = query.getOrDefault("endTime")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "endTime", valid_589152
  var valid_589153 = query.getOrDefault("currencyCode")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "currencyCode", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("$.xgafv")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("1"))
  if valid_589155 != nil:
    section.add "$.xgafv", valid_589155
  var valid_589156 = query.getOrDefault("pageSize")
  valid_589156 = validateParameter(valid_589156, JInt, required = false, default = nil)
  if valid_589156 != nil:
    section.add "pageSize", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  var valid_589158 = query.getOrDefault("startTime")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "startTime", valid_589158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589159: Call_CloudbillingServicesSkusList_589139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  let valid = call_589159.validator(path, query, header, formData, body)
  let scheme = call_589159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589159.url(scheme.get, call_589159.host, call_589159.base,
                         call_589159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589159, url, valid)

proc call*(call_589160: Call_CloudbillingServicesSkusList_589139; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          endTime: string = ""; currencyCode: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          startTime: string = ""): Recallable =
  ## cloudbillingServicesSkusList
  ## Lists all publicly available SKUs for a given cloud service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
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
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  ##   endTime: string
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   currencyCode: string
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  var path_589161 = newJObject()
  var query_589162 = newJObject()
  add(query_589162, "upload_protocol", newJString(uploadProtocol))
  add(query_589162, "fields", newJString(fields))
  add(query_589162, "pageToken", newJString(pageToken))
  add(query_589162, "quotaUser", newJString(quotaUser))
  add(query_589162, "alt", newJString(alt))
  add(query_589162, "oauth_token", newJString(oauthToken))
  add(query_589162, "callback", newJString(callback))
  add(query_589162, "access_token", newJString(accessToken))
  add(query_589162, "uploadType", newJString(uploadType))
  add(path_589161, "parent", newJString(parent))
  add(query_589162, "endTime", newJString(endTime))
  add(query_589162, "currencyCode", newJString(currencyCode))
  add(query_589162, "key", newJString(key))
  add(query_589162, "$.xgafv", newJString(Xgafv))
  add(query_589162, "pageSize", newJInt(pageSize))
  add(query_589162, "prettyPrint", newJBool(prettyPrint))
  add(query_589162, "startTime", newJString(startTime))
  result = call_589160.call(path_589161, query_589162, nil, nil, nil)

var cloudbillingServicesSkusList* = Call_CloudbillingServicesSkusList_589139(
    name: "cloudbillingServicesSkusList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{parent}/skus",
    validator: validate_CloudbillingServicesSkusList_589140, base: "/",
    url: url_CloudbillingServicesSkusList_589141, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGetIamPolicy_589163 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsGetIamPolicy_589165(protocol: Scheme;
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

proc validate_CloudbillingBillingAccountsGetIamPolicy_589164(path: JsonNode;
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
  var valid_589166 = path.getOrDefault("resource")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "resource", valid_589166
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589167 = query.getOrDefault("upload_protocol")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "upload_protocol", valid_589167
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("callback")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "callback", valid_589172
  var valid_589173 = query.getOrDefault("access_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "access_token", valid_589173
  var valid_589174 = query.getOrDefault("uploadType")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "uploadType", valid_589174
  var valid_589175 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589175 = validateParameter(valid_589175, JInt, required = false, default = nil)
  if valid_589175 != nil:
    section.add "options.requestedPolicyVersion", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("$.xgafv")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("1"))
  if valid_589177 != nil:
    section.add "$.xgafv", valid_589177
  var valid_589178 = query.getOrDefault("prettyPrint")
  valid_589178 = validateParameter(valid_589178, JBool, required = false,
                                 default = newJBool(true))
  if valid_589178 != nil:
    section.add "prettyPrint", valid_589178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589179: Call_CloudbillingBillingAccountsGetIamPolicy_589163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_589179.validator(path, query, header, formData, body)
  let scheme = call_589179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589179.url(scheme.get, call_589179.host, call_589179.base,
                         call_589179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589179, url, valid)

proc call*(call_589180: Call_CloudbillingBillingAccountsGetIamPolicy_589163;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsGetIamPolicy
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589181 = newJObject()
  var query_589182 = newJObject()
  add(query_589182, "upload_protocol", newJString(uploadProtocol))
  add(query_589182, "fields", newJString(fields))
  add(query_589182, "quotaUser", newJString(quotaUser))
  add(query_589182, "alt", newJString(alt))
  add(query_589182, "oauth_token", newJString(oauthToken))
  add(query_589182, "callback", newJString(callback))
  add(query_589182, "access_token", newJString(accessToken))
  add(query_589182, "uploadType", newJString(uploadType))
  add(query_589182, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589182, "key", newJString(key))
  add(query_589182, "$.xgafv", newJString(Xgafv))
  add(path_589181, "resource", newJString(resource))
  add(query_589182, "prettyPrint", newJBool(prettyPrint))
  result = call_589180.call(path_589181, query_589182, nil, nil, nil)

var cloudbillingBillingAccountsGetIamPolicy* = Call_CloudbillingBillingAccountsGetIamPolicy_589163(
    name: "cloudbillingBillingAccountsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudbillingBillingAccountsGetIamPolicy_589164, base: "/",
    url: url_CloudbillingBillingAccountsGetIamPolicy_589165,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsSetIamPolicy_589183 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsSetIamPolicy_589185(protocol: Scheme;
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

proc validate_CloudbillingBillingAccountsSetIamPolicy_589184(path: JsonNode;
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
  var valid_589186 = path.getOrDefault("resource")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "resource", valid_589186
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
  var valid_589187 = query.getOrDefault("upload_protocol")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "upload_protocol", valid_589187
  var valid_589188 = query.getOrDefault("fields")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "fields", valid_589188
  var valid_589189 = query.getOrDefault("quotaUser")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "quotaUser", valid_589189
  var valid_589190 = query.getOrDefault("alt")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("json"))
  if valid_589190 != nil:
    section.add "alt", valid_589190
  var valid_589191 = query.getOrDefault("oauth_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "oauth_token", valid_589191
  var valid_589192 = query.getOrDefault("callback")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "callback", valid_589192
  var valid_589193 = query.getOrDefault("access_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "access_token", valid_589193
  var valid_589194 = query.getOrDefault("uploadType")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "uploadType", valid_589194
  var valid_589195 = query.getOrDefault("key")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "key", valid_589195
  var valid_589196 = query.getOrDefault("$.xgafv")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("1"))
  if valid_589196 != nil:
    section.add "$.xgafv", valid_589196
  var valid_589197 = query.getOrDefault("prettyPrint")
  valid_589197 = validateParameter(valid_589197, JBool, required = false,
                                 default = newJBool(true))
  if valid_589197 != nil:
    section.add "prettyPrint", valid_589197
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

proc call*(call_589199: Call_CloudbillingBillingAccountsSetIamPolicy_589183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_589199.validator(path, query, header, formData, body)
  let scheme = call_589199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589199.url(scheme.get, call_589199.host, call_589199.base,
                         call_589199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589199, url, valid)

proc call*(call_589200: Call_CloudbillingBillingAccountsSetIamPolicy_589183;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsSetIamPolicy
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589201 = newJObject()
  var query_589202 = newJObject()
  var body_589203 = newJObject()
  add(query_589202, "upload_protocol", newJString(uploadProtocol))
  add(query_589202, "fields", newJString(fields))
  add(query_589202, "quotaUser", newJString(quotaUser))
  add(query_589202, "alt", newJString(alt))
  add(query_589202, "oauth_token", newJString(oauthToken))
  add(query_589202, "callback", newJString(callback))
  add(query_589202, "access_token", newJString(accessToken))
  add(query_589202, "uploadType", newJString(uploadType))
  add(query_589202, "key", newJString(key))
  add(query_589202, "$.xgafv", newJString(Xgafv))
  add(path_589201, "resource", newJString(resource))
  if body != nil:
    body_589203 = body
  add(query_589202, "prettyPrint", newJBool(prettyPrint))
  result = call_589200.call(path_589201, query_589202, nil, nil, body_589203)

var cloudbillingBillingAccountsSetIamPolicy* = Call_CloudbillingBillingAccountsSetIamPolicy_589183(
    name: "cloudbillingBillingAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudbillingBillingAccountsSetIamPolicy_589184, base: "/",
    url: url_CloudbillingBillingAccountsSetIamPolicy_589185,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsTestIamPermissions_589204 = ref object of OpenApiRestCall_588441
proc url_CloudbillingBillingAccountsTestIamPermissions_589206(protocol: Scheme;
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

proc validate_CloudbillingBillingAccountsTestIamPermissions_589205(
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
  var valid_589207 = path.getOrDefault("resource")
  valid_589207 = validateParameter(valid_589207, JString, required = true,
                                 default = nil)
  if valid_589207 != nil:
    section.add "resource", valid_589207
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
  var valid_589208 = query.getOrDefault("upload_protocol")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "upload_protocol", valid_589208
  var valid_589209 = query.getOrDefault("fields")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "fields", valid_589209
  var valid_589210 = query.getOrDefault("quotaUser")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "quotaUser", valid_589210
  var valid_589211 = query.getOrDefault("alt")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("json"))
  if valid_589211 != nil:
    section.add "alt", valid_589211
  var valid_589212 = query.getOrDefault("oauth_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "oauth_token", valid_589212
  var valid_589213 = query.getOrDefault("callback")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "callback", valid_589213
  var valid_589214 = query.getOrDefault("access_token")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "access_token", valid_589214
  var valid_589215 = query.getOrDefault("uploadType")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "uploadType", valid_589215
  var valid_589216 = query.getOrDefault("key")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "key", valid_589216
  var valid_589217 = query.getOrDefault("$.xgafv")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("1"))
  if valid_589217 != nil:
    section.add "$.xgafv", valid_589217
  var valid_589218 = query.getOrDefault("prettyPrint")
  valid_589218 = validateParameter(valid_589218, JBool, required = false,
                                 default = newJBool(true))
  if valid_589218 != nil:
    section.add "prettyPrint", valid_589218
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

proc call*(call_589220: Call_CloudbillingBillingAccountsTestIamPermissions_589204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  let valid = call_589220.validator(path, query, header, formData, body)
  let scheme = call_589220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589220.url(scheme.get, call_589220.host, call_589220.base,
                         call_589220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589220, url, valid)

proc call*(call_589221: Call_CloudbillingBillingAccountsTestIamPermissions_589204;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsTestIamPermissions
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589222 = newJObject()
  var query_589223 = newJObject()
  var body_589224 = newJObject()
  add(query_589223, "upload_protocol", newJString(uploadProtocol))
  add(query_589223, "fields", newJString(fields))
  add(query_589223, "quotaUser", newJString(quotaUser))
  add(query_589223, "alt", newJString(alt))
  add(query_589223, "oauth_token", newJString(oauthToken))
  add(query_589223, "callback", newJString(callback))
  add(query_589223, "access_token", newJString(accessToken))
  add(query_589223, "uploadType", newJString(uploadType))
  add(query_589223, "key", newJString(key))
  add(query_589223, "$.xgafv", newJString(Xgafv))
  add(path_589222, "resource", newJString(resource))
  if body != nil:
    body_589224 = body
  add(query_589223, "prettyPrint", newJBool(prettyPrint))
  result = call_589221.call(path_589222, query_589223, nil, nil, body_589224)

var cloudbillingBillingAccountsTestIamPermissions* = Call_CloudbillingBillingAccountsTestIamPermissions_589204(
    name: "cloudbillingBillingAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudbilling.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudbillingBillingAccountsTestIamPermissions_589205,
    base: "/", url: url_CloudbillingBillingAccountsTestIamPermissions_589206,
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
